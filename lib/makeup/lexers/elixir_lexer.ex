defmodule Makeup.Lexers.ElixirLexer do
  import NimbleParsec
  import Makeup.Lexer.Combinators
  import Makeup.Lexer.Groups
  alias Makeup.Lexer.Postprocess

  ###################################################################
  # Step #1: tokenize the input (into a list of tokens)
  ###################################################################
  # We will often compose combinators into larger combinators.
  # Sometimes, the smaller combinator is usefull on its own as a token, and sometimes it isn't.
  # We'll adopt the following convention:
  #
  # 1. A combinator that ends with `_name` returns a string
  # 2. Other combinators return a token
  #
  # Why this convention? Tokens can't be composed firther, while raw strings can.
  # This way, we immediately know which of the combinators we can compose.
  # TODO: check we're following this convention
  # NOTE: if Elixir had a good static type system it would hep us do the right thing here.

  whitespace = token(ascii_string([?\s, ?\n], min: 1), :whitespace)

  any_char = token(utf8_string([], 1), :error)

  # Yes, Elixir supports much more than this.
  # TODO: adapt the code from the official tokenizer, which parses the unicode database
  variable_name =
    ascii_string([?a..?z], 1)
    |> optional(ascii_string([?a..?z, ?_, ?0..?9, ?A..?Z], min: 1))
    |> optional(ascii_string([??, ?!], 1))

  # Can also be a function name
  variable = token(lexeme(variable_name), :name)
  unused_variable = token(lexeme(string("_") |> concat(variable_name)), :name_builtin_pseudo)

  # TODO: as above
  alias_part =
    ascii_string([?A..?Z], 1)
    |> optional(ascii_string([?a..?z, ?_, ?0..?9, ?A..?Z], min: 1))

  module_name =
    lexeme(
      alias_part
      |> concat(
        repeat(string(".") |> concat(alias_part))))

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

  _complex_name =
    choice([
      variable_name,
      module_name,
      operator_name
    ])

  special_atom =
    token(
      lexeme(string(":") |> concat(special_atom_name)),
      :string_symbol)

  attribute =
    token(
      lexeme(string("@") |> concat(variable_name)),
      :name_attribute)

  normal_atom =
    token(
      lexeme(
        string(":")
        |> choice([
            operator_name,
            variable_name
          ])),
      :string_symbol)

  inline_comment =
    token(
      lexeme(
        string("#")
        |> repeat_until(
            utf8_string([], 1),
            [ascii_char([?\n])])),
      :comment_single)

  parentheses = many_surrounded_by(parsec(:root_element), "(", ")")
  list = many_surrounded_by(parsec(:root_element), "[", "]")
  map = many_surrounded_by(parsec(:root_element), "%{", "}")
  tuple = many_surrounded_by(parsec(:root_element), "{", "}")
  binary = many_surrounded_by(parsec(:root_element), "<<", ">>")
  struct = many_surrounded_by(
    parsec(:root_element),
    token("%", :punctuation) |> concat(module) |> token("{", :punctuation),
    token("}", :punctuation)
  )

  # Semi-public API: these two functions can be used by someone who wants to
  # embed an Elixir lexer into another lexer, but other than that, they are not
  # meant to be used by end-users.

  defparsec :root,
    repeat(parsec(:root_element))

  defparsec :root_element,
    choice([
      whitespace,
      # Comments
      inline_comment,
      # Matching delimiters
      struct,
      parentheses,
      map,
      tuple,
      binary,
      list,
      # Attributes
      attribute,
      # Operators
      operator,
      # Numbers (in several bases)
      # TODO: ...
      # Atoms
      special_atom,
      normal_atom,
      # Names
      variable,
      unused_variable,
      module,
      # -
      punctuation,
      # If we can't parse any of the above, we highlight the next character as an error
      # and proceed from there.
      # A lexer should always consume any string given as input.
      any_char
    ])

  ###################################################################
  # Step #2: postprocess the list of tokens
  ###################################################################

  @word_map Postprocess.invert_word_map(
    keyword: ~W[fn do end after else rescue catch with],
    keyword_operators: ~W[not and or when in],
    builtin: ~W[
      case cond for if unless try receive raise
      quote unquote unquote_splicing throw super],
    builtin_declaration: ~W[
      def defp defmodule defprotocol defmacro defmacrop
      defdelegate defexception defstruct defimpl defcallback],
    builtin_namespace: ~W[import require use alias],
    constant: ~W[nil true false],
    pseudovar: ~W[_ __MODULE__ __DIR__ __ENV__ __CALLER__]
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
          {:whitespace, _, _} = ws,
          {:name, _, text2} = param,
          {:operator, _, _} = op
          | tokens])
        when text1 in ~W[def defp defmacro defmacrop defcallback] and text2 != "unquote" do
    [{:keyword_declaration, attrs1, text1}, ws, param, op | postprocess(tokens)]
  end

  # If we're matching this branch, we already know that this is not an operator definition.
  # We can highlight the variable_name after the function name as a function name.
  defp postprocess([{:name, attrs1, text1}, {:whitespace, _, _} = ws, {:name, attrs2, text2} | tokens])
        when text1 in ~W[def defp defmacro defmacrop defcallback] and text2 != "unquote" do
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

    binaries: [
      open: [
        [{:punctuation, _, "<<"}]
      ],
      close: [
        [{:punctuation, _, ">>"}]
      ]
    ]
  ]

  # Finally, the public API for the lexer

  defp random_prefix(), do: Enum.map(1..8, fn _ -> Enum.random(?0..?9) end) |> to_string

  def lex(text, opts \\ []) do
    group_prefix = Keyword.get(opts, :group_prefix, random_prefix())
    {:ok, tokens, "", _, _, _} = root(text)

    tokens |> postprocess |> group_matcher(group_prefix)
  end
end
