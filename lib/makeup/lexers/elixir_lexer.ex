defmodule Makeup.Lexers.ElixirLexer.Helper do
  @moduledoc false
  import NimbleParsec
  alias Makeup.Lexer.Combinators

  def with_optional_separator(combinator, separator) when is_binary(separator) do
    combinator |> repeat(string(separator) |> concat(combinator))
  end

  # Allows escaping of the first character of a right delimiter.
  # This is used in sigils that don't support interpolation or character escapes but
  # must support escaping of the right delimiter.
  def escape_delim(rdelim) do
    rdelim_first_char = String.slice(rdelim, 0..0)
    string("\\" <> rdelim_first_char)
  end

  def sigil(ldelim, rdelim, ranges, middle, ttype, attrs \\ %{}) do
    left = string("~") |> utf8_string(ranges, 1) |> string(ldelim)
    right = string(rdelim)

    choices = middle ++ [utf8_char([])]

    left
    |> repeat_until(choice(choices), [right])
    |> concat(right)
    |> optional(utf8_string([?a..?z, ?A..?Z], min: 1))
    |> traverse({Combinators, :collect_raw_chars_and_binaries, [ttype, attrs]})
  end

  def escaped(literal) when is_binary(literal) do
    string("\\" <> literal)
  end
end

defmodule Makeup.Lexers.ElixirLexer do
  import NimbleParsec
  import Makeup.Lexer.Combinators
  import Makeup.Lexer.Groups
  alias Makeup.Lexer.Postprocess
  import Makeup.Lexers.ElixirLexer.Helper

  ###################################################################
  # Step #1: tokenize the input (into a list of tokens)
  ###################################################################
  # We will often compose combinators into larger combinators.
  # Sometimes, the smaller combinator is usefull on its own as a token, and sometimes it isn't.
  # We'll adopt the following "convention":
  #
  # 1. A combinator that ends with `_name` returns a string
  # 2. Other combinators will *usually* return a token
  #
  # Why this convention? Tokens can't be composed forther, while raw strings can.
  # This way, we immediately know which of the combinators we can compose.
  # TODO: check we're following this convention
  # NOTE: if Elixir had a good static type system it would hep us do the right thing here.

  whitespace = ascii_string([?\s, ?\n], min: 1) |> token(:whitespace)

  # newline = string("\n") |> token(:whitespace)
  newlines =
    string("\n")
    |> optional(ascii_string([?\s, ?\n], min: 1))
    |> token(:whitespace)

  any_char = utf8_char([]) |> token(:error)

  # Numbers
  digits = ascii_string([?0..?9], min: 1)
  bin_digits = ascii_string([?0..?1], min: 1)
  hex_digits = ascii_string([?0..?9, ?a..?f, ?A..?F], min: 1)
  oct_digits = ascii_string([?0..?7], min: 1)
  # Digits in an integer may be separated by underscores
  number_bin_part = with_optional_separator(bin_digits, "_")
  number_oct_part = with_optional_separator(oct_digits, "_")
  number_hex_part = with_optional_separator(hex_digits, "_")
  integer = with_optional_separator(digits, "_")

  # Tokens for the lexer
  number_bin = string("0b") |> concat(number_bin_part) |> token(:number_bin)
  number_oct = string("0o") |> concat(number_oct_part) |> token(:number_oct)
  number_hex = string("0x") |> concat(number_hex_part) |> token(:number_hex)
  # Base 10
  number_integer = token(integer, :number_integer)

  # Floating point numbers
  float_scientific_notation_part =
    ascii_string([?e, ?E], 1)
    |> optional(string("-"))
    |> concat(integer)

  number_float =
    integer
    |> string(".")
    |> concat(integer)
    |> optional(float_scientific_notation_part)
    |> token(:number_float)

  # Yes, Elixir supports much more than this.
  # TODO: adapt the code from the official tokenizer, which parses the unicode database
  variable_name =
    ascii_string([?a..?z, ?_], 1)
    |> optional(ascii_string([?a..?z, ?_, ?0..?9, ?A..?Z], min: 1))
    |> optional(ascii_string([??, ?!], 1))

  # Can also be a function name
  variable =
    variable_name
    |> lexeme
    |> token(:name)

  # unused_variable =
  #   string("_")
  #   |> concat(variable_name)
  #   |> token(:name_builtin_pseudo)

  # TODO: as above
  alias_part =
    ascii_string([?A..?Z], 1)
    |> optional(ascii_string([?a..?z, ?_, ?0..?9, ?A..?Z], min: 1))

  module_name =
    alias_part |> concat(repeat(string(".") |> concat(alias_part)))

  module = token(module_name, :name_class)

  operator_name = word_from_list(~W(
      <<< >>> ||| &&& ^^^ ~~~ === !== ~>> <~> |~> <|>
      == != <= >= && || \\ <> ++ -- |> =~ -> <- ~> <~
      = < > + - * / | . ^ & !
    ))

  operator = token(operator_name, :operator)

  punctuation = word_from_list(
    ~W( \\\\ => : ; , . % ),
    :punctuation
  )

  special_atom_name =
    word_from_list(~W(... <<>> %{} %{ % {}))

  triple_colon = token(":::", :operator)
  double_colon = token("::", :operator)
  triple_dot = token("...", :name)

  anon_function_arguments =
    string("&")
    |> concat(digits)
    |> token(:name_entity)

  normal_char =
    string("?")
    |> utf8_string([], 1)
    |> token(:string_char)

  escape_char =
    string("?\\")
    |> utf8_string([], 1)
    |> token(:string_char)

  special_atom =
    string(":")
    |> concat(special_atom_name)
    |> token(:string_symbol)

  attribute =
    string("@")
    |> concat(variable_name)
    |> token(:name_attribute)


  # Combinators that highlight elixir expressions surrounded by a pair of delimiters.
  # Most of the time, the delimiters can be described by symple characters, but the
  # combinator that parses a struct is more complex
  interpolation = many_surrounded_by(parsec(:root_element), "\#{", "}", :string_interpol)
  parentheses = many_surrounded_by(parsec(:root_element), "(", ")")
  list = many_surrounded_by(parsec(:root_element), "[", "]")
  map = many_surrounded_by(parsec(:root_element), "%{", "}")
  tuple = many_surrounded_by(parsec(:root_element), "{", "}")
  binary = many_surrounded_by(parsec(:root_element), "<<", ">>")
  struct = many_surrounded_by(
    parsec(:root_element),
    token("%", :punctuation) |> concat(module) |> concat(token("{", :punctuation)),
    token("}", :punctuation))
  # Only for the IEx lexer (it's not valid Elixir code):
  opaque_struct = many_surrounded_by(
    parsec(:root_element),
    token("#", :punctuation) |> concat(module) |> concat(token("<", :punctuation)),
    token(">", :punctuation))

  normal_atom_name =
    utf8_string([?A..?Z, ?a..?z, ?_], 1)
    |> optional(utf8_string([?A..?Z, ?a..?z, ?_, ?0..?9, ?@], min: 1))

  normal_atom =
    string(":")
    |> choice([operator_name, normal_atom_name])
    |> token(:string_symbol)

  escaped_char =
    string("\\")
    |> utf8_string([], 1)
    |> token(:string_char)

  string_atom =
    choice([
      string_like(":\"", "\"", [escaped_char, interpolation], :string_symbol),
      string_like(":'", "'", [escaped_char, interpolation], :string_symbol)
    ])

  atom =
    choice([
      special_atom,
      normal_atom,
      string_atom
    ])

  normal_keyword =
    choice([operator_name, normal_atom_name])
    |> token(:string_symbol)
    |> concat(token(string(":"), :punctuation))

  string_keyword =
    choice([
      string_like("\"", "\"", [escaped_char, interpolation], :string_symbol),
      string_like("'", "'", [escaped_char, interpolation], :string_symbol)
    ])
    |> concat(token(string(":"), :punctuation))

  keyword =
    choice([
      normal_keyword,
      string_keyword
    ])

  sigil_delimiters = [
    {~S["""], ~S["""]},
    {"'''", "'''"},
    {"\"", "\""},
    {"'", "'"},
    {"/", "/"},
    {"{", "}"},
    {"[", "]"},
    {"(", ")"}
  ]

  normal_sigil_interpol_range = [?a..?z, not: ?c, not: ?d, not: ?n, not: ?r, not: ?s]
  normal_sigil_no_interpol_range = [?A..?Z, not: ?c, not: ?D, not: ?N, not: ?R, not: ?S]

  sigils_interpol =
    for {ldelim, rdelim} <- sigil_delimiters do
      sigil(
        ldelim,
        rdelim,
        normal_sigil_interpol_range,
        [escaped_char, interpolation],
        :string_sigil)
    end

  sigils_no_interpol =
    for {ldelim, rdelim} <- sigil_delimiters do
      sigil(
        ldelim,
        rdelim,
        normal_sigil_no_interpol_range,
        [escape_delim(rdelim), interpolation],
        :string_sigil)
    end

  sigils_string_interpol =
    for {ldelim, rdelim} <- sigil_delimiters do
      sigil(ldelim, rdelim, [?s], [escaped_char, interpolation], :string)
    end

  sigils_string_no_interpol =
    for {ldelim, rdelim} <- sigil_delimiters do
      sigil(ldelim, rdelim, [?S], [escape_delim(rdelim), interpolation], :string)
    end

  sigils_charlist_interpol =
    for {ldelim, rdelim} <- sigil_delimiters do
      sigil(ldelim, rdelim, [?c], [escaped_char, interpolation], :string)
    end

  sigils_charlist_no_interpol =
    for {ldelim, rdelim} <- sigil_delimiters do
      sigil(ldelim, rdelim, [?C], [escape_delim(rdelim), interpolation], :string)
    end

  sigils_regex_interpol =
    for {ldelim, rdelim} <- sigil_delimiters do
      sigil(ldelim, rdelim, [?r], [escaped_char, interpolation], :string_regex)
    end

  sigils_regex_no_interpol =
    for {ldelim, rdelim} <- sigil_delimiters do
      sigil(ldelim, rdelim, [?R], [escape_delim(rdelim), interpolation], :string_regex)
    end

  # Dates (both naïve and with timezone)
  sigils_date_interpol =
    for {ldelim, rdelim} <- sigil_delimiters do
      sigil(ldelim, rdelim, [?d, ?n], [escaped_char, interpolation], :literal_date)
    end

  sigils_date_no_interpol =
    for {ldelim, rdelim} <- sigil_delimiters do
      sigil(ldelim, rdelim, [?D, ?N], [escape_delim(rdelim), interpolation], :literal_date)
    end

  all_sigils =
    sigils_interpol ++
    sigils_no_interpol ++
    sigils_string_interpol ++
    sigils_string_no_interpol ++
    sigils_charlist_interpol ++
    sigils_charlist_no_interpol ++
    sigils_regex_interpol ++
    sigils_regex_no_interpol ++
    sigils_date_interpol ++
    sigils_date_no_interpol

  double_quoted_string_interpol = string_like("\"", "\"", [escaped_char, interpolation], :string)
  single_quoted_string_interpol = string_like("'", "'", [escaped_char, interpolation], :string_char)
  double_quoted_heredocs = string_like(~S["""], ~S["""], [escaped_char, interpolation], :string)
  single_quoted_heredocs = string_like("'''", "'''", [escaped_char, interpolation], :string_char)

  line =
    repeat_until(utf8_string([], 1), [ascii_char([?\n])])

  inline_comment =
    string("#")
    |> concat(line)
    # |> lexeme
    |> token(:comment_single)

  @doc false
  def __as_elixir_language__({ttype, meta, value}) do
    {ttype, Map.put(meta, :language, :elixir), value}
  end

  # An IEx prompt is supported in the normal Elixir lexer because false positives
  # would be extremely rare
  iex_prompt =
    choice([string("iex"), string("...")])
    |> optional(string("(") |> concat(digits) |> string(")"))
    |> string(">")
    # |> lexeme
    |> token(:generic_prompt, %{selectable: false})

  stacktrace =
    string("** (")
    # The rest of the line is part of the traceback
    |> concat(line)
    # All lines indented by 4 spaces are part of the traceback
    |> repeat(string("\n    ") |> concat(line))
    # |> lexeme
    |> token(:generic_traceback)

  # Semi-public API: these two functions can be used by someone who wants to
  # embed an Elixir lexer into another lexer, but other than that, they are not
  # meant to be used by end-users.

  defparsec :root,
    repeat(parsec(:root_element))

  defparsec :root_element,
    choice([
      # START of IEx-specific tokens
      # IEx prompt must come before names
      newlines |> choice([iex_prompt, stacktrace]),
      # Opaque struct (must come before inline comments)
      opaque_struct,
      # END of IEx-specific tokens
      whitespace,
      # Comments
      inline_comment,
      # Syntax sugar for keyword lists (must come before variables and strings)
      keyword,
      # Strings and sigils
      double_quoted_heredocs,
      single_quoted_heredocs,
      double_quoted_string_interpol,
      single_quoted_string_interpol
    ] ++ all_sigils ++ [
      # Chars
      escape_char,
      normal_char,
      # Some operators (must come before the atoms)
      triple_colon,
      double_colon,
      # Atoms
      atom,
      # Module attributes
      attribute,
      # Anonymous function arguments (must come before the operators)
      anon_function_arguments,
      # Matching delimiters
      struct,
      parentheses,
      map,
      tuple,
      binary,
      list,
      # Triple dot (must come before operators)
      triple_dot,
      # Operators
      operator,
      # Numbers
      number_bin,
      number_oct,
      number_hex,
      # Floats must come before integers
      number_float,
      number_integer,
      # Names
      variable,
      # unused_variable,
      # Module names
      module,
      punctuation,
      # If we can't parse any of the above, we highlight the next character as an error
      # and proceed from there.
      # A lexer should always consume any string given as input.
      any_char
    ])

  ###################################################################
  # Step #2: postprocess the list of tokens
  ###################################################################

  @def_like ~W[def defp defprotocol defmacro defmacrop defimpl defcallback]

  @word_map Postprocess.invert_word_map(
    keyword: ~W[
      fn do end after else rescue catch with
      case cond for if unless try receive raise
      quote unquote unquote_splicing throw super],
    operator_word: ~W[not and or when in],
    keyword_declaration: ~W[
      def defp defmodule defprotocol defmacro defmacrop
      defdelegate defexception defstruct defimpl defcallback],
    keyword_namespace: ~W[import require use alias],
    name_constant: ~W[nil true false],
    name_builtin_pseudo: ~W[_ __MODULE__ __DIR__ __ENV__ __CALLER__]
  )

  # The `postprocess/1` function will require a major redesign when we decide to support
  # custom `def`-like keywords supplied by the user.
  defp postprocess([]), do: []

  # In an expression such as:
  #
  #    def a + b, do: nil
  #
  # the variable_name `a` is a parameter for the `+/2` operator.
  # It should not be highlighted as a function name.
  # for that, we must scan a little further (one additional token) for the operator.
  defp postprocess([
          {:name, attrs1, text1},
          {:whitespace, _, _} = ws1,
          {:name, _, text2} = param,
          {:whitespace, _, _} = ws2,
          {:operator, _, _} = op
          | tokens])
        when text1 in @def_like and text2 != "unquote" do
    [{:keyword_declaration, attrs1, text1}, ws1, param, ws2, op | postprocess(tokens)]
  end

  # The same as above without whitespace
  defp postprocess([
    {:name, attrs1, text1},
    {:whitespace, _, _} = ws,
    {:name, _, text2} = param,
    {:operator, _, _} = op
    | tokens])
  when text1 in @def_like and text2 != "unquote" do
[{:keyword_declaration, attrs1, text1}, ws, param, op | postprocess(tokens)]
end

  # If we're matching this branch, we already know that this is not an operator definition.
  # We can highlight the variable_name after the function name as a function name.
  defp postprocess([{:name, attrs1, text1}, {:whitespace, _, _} = ws, {:name, attrs2, text2} | tokens])
        when text1 in @def_like and text2 != "unquote" do
    [{:keyword_declaration, attrs1, text1}, ws, {:name_function, attrs2, text2} | postprocess(tokens)]
  end

  # Elixir has some "keywords" which must be highlighted differently.
  # See if the current token is one of such keywords.
  defp postprocess([{:name, attrs, text} | tokens]), do:
    [{Map.get(@word_map, text, :name), attrs, text} | postprocess(tokens)]

  # Otherwise, don't do anything with the current token and go to the next token.
  defp postprocess([token | tokens]), do: [token | postprocess(tokens)]

  ###################################################################
  # Step #3: highlight matching delimiters
  ###################################################################

  defgroupmatcher :group_matcher, [
    do_end: [
      open: [
        [{:keyword, _, "do"}]
      ],
      middle: [
        [{:keyword, _, "else"}],
        [{:keyword, _, "catch"}],
        [{:keyword, _, "rescue"}],
        [{:keyword, _, "after"}]
      ],
      close: [
        [{:keyword, _, "end"}]
      ]
    ],

    fn_end: [
      open: [[{:keyword, _, "fn"}]],
      close: [[{:keyword, _, "end"}]]
    ],

    parentheses: [
      open: [[{:punctuation, _, "("}]],
      close: [[{:punctuation, _, ")"}]]
    ],

    list: [
      open: [
        [{:punctuation, _, "["}]
      ],
      close: [
        [{:punctuation, _, "]"}]
      ]
    ],

    tuple: [
      open: [
        [{:punctuation, _, "{"}]
      ],
      close: [
        [{:punctuation, _, "}"}]
      ]
    ],

    map: [
      open: [
        [{:punctuation, _, "%{"}]
      ],
      close: [
        [{:punctuation, _, "}"}]
      ]
    ],

    struct: [
      open: [
        [{:punctuation, _, "%"}, {:name_class, _, _}, {:punctuation, _, "{"}]
      ],
      close: [
        [{:punctuation, _, "}"}]
      ]
    ],

    opaque_struct: [
      open: [
        [{:punctuation, _, "#"}, {:name_class, _, _}, {:punctuation, _, "<"}]
      ],
      close: [
        [{:punctuation, _, ">"}]
      ]
    ],

    binaries: [
      open: [
        [{:punctuation, _, "<<"}]
      ],
      close: [
        [{:punctuation, _, ">>"}]
      ]
    ],

    interpolation: [
      open: [
        [{:string_interpol, _, "\#{"}]
      ],
      close: [
        [{:string_interpol, _, "}"}]
      ]
    ]
  ]

  defp remove_initial_newline([{ttype, meta, text} | tokens]) do
    case to_string(text) do
      "\n" -> tokens
      "\n" <> rest -> [{ttype, meta, rest} | tokens]
    end
  end

  # Finally, the public API for the lexer

  def lex(text, opts \\ []) do
    group_prefix = Keyword.get(opts, :group_prefix, random_prefix(10))
    {:ok, tokens, "", _, _, _} = root("\n" <> text)

    tokens
    |> remove_initial_newline()
    |> postprocess()
    |> group_matcher(group_prefix)
  end
end
