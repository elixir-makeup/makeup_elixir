defmodule ElixirLexerTokenizerTestSnippet do
  use ExUnit.Case, async: false
  import Makeup.Lexers.ElixirLexer.Testing, only: [lex: 1]

  test "whitespace" do
    assert lex(" ") == [{:whitespace, %{}, " "}]
    assert lex("\s") == [{:whitespace, %{}, "\s"}]
    assert lex("\n") == [{:whitespace, %{}, "\n"}]
    assert lex("\t") == [{:whitespace, %{}, "\t"}]
    assert lex("\r") == [{:whitespace, %{}, "\r"}]
  end

  test "builtins" do
    # is a builtin and not an unused variable!
    assert lex("_") == [{:name_builtin_pseudo, %{}, "_"}]
  end

  test "newlines" do
    assert lex("1+\n2") == [
             {:number_integer, %{}, "1"},
             {:operator, %{}, "+"},
             {:whitespace, %{}, "\n"},
             {:number_integer, %{}, "2"}
           ]

    assert lex("1+\r\n2") == [
             {:number_integer, %{}, "1"},
             {:operator, %{}, "+"},
             {:whitespace, %{}, "\r\n"},
             {:number_integer, %{}, "2"}
           ]
  end

  test "unused variables" do
    assert lex("_123") == [{:comment, %{}, "_123"}]
    assert lex("_a") == [{:comment, %{}, "_a"}]
    assert lex("_unused") == [{:comment, %{}, "_unused"}]
  end

  describe "iex prompt" do
    test "parses iex prompt correctly (first line)" do
      assert lex("iex>") == [{:generic_prompt, %{selectable: false}, "iex>"}]
      assert lex("iex(1)>") == [{:generic_prompt, %{selectable: false}, "iex(1)>"}]
      assert lex("iex(12)>") == [{:generic_prompt, %{selectable: false}, "iex(12)>"}]
    end

    test "accepts correct iex prompt (continuation)" do
      assert lex("...>") == [{:generic_prompt, %{selectable: false}, "...>"}]
    end

    test "parses iex prompt with extra space" do
      assert lex("iex> ") == [{:generic_prompt, %{selectable: false}, "iex> "}]
      assert lex("iex(1)> ") == [{:generic_prompt, %{selectable: false}, "iex(1)> "}]
      assert lex("...(12)> ") == [{:generic_prompt, %{selectable: false}, "...(12)> "}]
      assert lex("iex(foo@bar)> ") == [{:generic_prompt, %{selectable: false}, "iex(foo@bar)> "}]
      assert lex("...(foo@bar)> ") == [{:generic_prompt, %{selectable: false}, "...(foo@bar)> "}]
    end

    test "parses multiline iex prompt correctly" do
      source = """
      iex> x = [
      ...>   key:
      ...>     "value"
      ...> ]
      """

      assert lex(source) == [
               {:generic_prompt, %{selectable: false}, "iex> "},
               {:name, %{}, "x"},
               {:whitespace, %{}, " "},
               {:operator, %{}, "="},
               {:whitespace, %{}, " "},
               {:punctuation, %{group_id: "group-1"}, "["},
               {:whitespace, %{}, "\n"},
               {:generic_prompt, %{selectable: false}, "...> "},
               {:whitespace, %{}, "  "},
               {:string_symbol, %{}, "key"},
               {:punctuation, %{}, ":"},
               {:whitespace, %{}, "\n"},
               {:generic_prompt, %{selectable: false}, "...> "},
               {:whitespace, %{}, "    "},
               {:string, %{}, "\"value\""},
               {:whitespace, %{}, "\n"},
               {:generic_prompt, %{selectable: false}, "...> "},
               {:punctuation, %{group_id: "group-1"}, "]"},
               {:whitespace, %{}, "\n"}
             ]
    end

    test "rejects incomplete iex prompt (first line)" do
      # missing the `>`
      assert lex("iex") == [{:name, %{}, "iex"}]
      # with number but missing the `>`
      assert lex("iex(8)") == [
               {:name, %{}, "iex"},
               {:punctuation, %{group_id: "group-1"}, "("},
               {:number_integer, %{}, "8"},
               {:punctuation, %{group_id: "group-1"}, ")"}
             ]

      # missing the number
      assert lex("iex()>") == [
               {:name, %{}, "iex"},
               {:punctuation, %{group_id: "group-1"}, "("},
               {:punctuation, %{group_id: "group-1"}, ")"},
               {:operator, %{}, ">"}
             ]
    end

    test "rejects incomplete iex prompt (continuation)" do
      # missing the `>`
      assert lex("...") == [{:name, %{}, "..."}]
      # missing the `>`
      assert lex("...<") == [{:name, %{}, "..."}, {:operator, %{}, "<"}]
    end

    test "iex prompt must start a new line" do
      assert lex("x iex>") == [
               {:name, %{}, "x"},
               {:whitespace, %{}, " "},
               {:name, %{}, "iex"},
               {:operator, %{}, ">"}
             ]

      assert lex("x iex(1)>") == [
               {:name, %{}, "x"},
               {:whitespace, %{}, " "},
               {:name, %{}, "iex"},
               {:punctuation, %{group_id: "group-1"}, "("},
               {:number_integer, %{}, "1"},
               {:punctuation, %{group_id: "group-1"}, ")"},
               {:operator, %{}, ">"}
             ]

      assert lex("x ...>") == [
               {:name, %{}, "x"},
               {:whitespace, %{}, " "},
               {:name, %{}, "..."},
               {:operator, %{}, ">"}
             ]

      assert lex("x ...(1)>") == [
               {:name, %{}, "x"},
               {:whitespace, %{}, " "},
               {:name, %{}, "..."},
               {:punctuation, %{group_id: "group-1"}, "("},
               {:number_integer, %{}, "1"},
               {:punctuation, %{group_id: "group-1"}, ")"},
               {:operator, %{}, ">"}
             ]
    end

    test "iex prompt works when previous line has trailing whitespace" do
      assert lex("x \niex> ") == [
               {:name, %{}, "x"},
               {:whitespace, %{}, " \n"},
               {:generic_prompt, %{selectable: false}, "iex> "}
             ]

      assert lex("x \r\niex> ") == [
               {:name, %{}, "x"},
               {:whitespace, %{}, " \r\n"},
               {:generic_prompt, %{selectable: false}, "iex> "}
             ]
    end
  end

  describe "def-like macros" do
    test "normal function/macro definition" do
      assert lex("def f") == [
               {:keyword_declaration, %{}, "def"},
               {:whitespace, %{}, " "},
               {:name_function, %{}, "f"}
             ]

      assert lex("defp g") == [
               {:keyword_declaration, %{}, "defp"},
               {:whitespace, %{}, " "},
               {:name_function, %{}, "g"}
             ]

      assert lex("defguard h") == [
               {:keyword_declaration, %{}, "defguard"},
               {:whitespace, %{}, " "},
               {:name_function, %{}, "h"}
             ]
    end

    test "operator definition" do
      # Must not highlight the first argument!
      assert lex("def a + b") == [
               {:keyword_declaration, %{}, "def"},
               {:whitespace, %{}, " "},
               {:name, %{}, "a"},
               {:whitespace, %{}, " "},
               {:operator, %{}, "+"},
               {:whitespace, %{}, " "},
               {:name, %{}, "b"}
             ]

      assert lex("defp a - b") == [
               {:keyword_declaration, %{}, "defp"},
               {:whitespace, %{}, " "},
               {:name, %{}, "a"},
               {:whitespace, %{}, " "},
               {:operator, %{}, "-"},
               {:whitespace, %{}, " "},
               {:name, %{}, "b"}
             ]

      assert lex("defguard a <<< b") == [
               {:keyword_declaration, %{}, "defguard"},
               {:whitespace, %{}, " "},
               {:name, %{}, "a"},
               {:whitespace, %{}, " "},
               {:operator, %{}, "<<<"},
               {:whitespace, %{}, " "},
               {:name, %{}, "b"}
             ]
    end
  end

  describe "anonymous functions" do
    test "accepts anonymous function argument" do
      assert lex("&1") == [{:name_entity, %{}, "&1"}]
      assert lex("&2") == [{:name_entity, %{}, "&2"}]
      assert lex("&666") == [{:name_entity, %{}, "&666"}]
    end

    test "rejects incorrect anonymous function argument" do
      assert lex("&p") == [{:operator, %{}, "&"}, {:name, %{}, "p"}]
      assert lex("&!") == [{:operator, %{}, "&"}, {:operator, %{}, "!"}]
      assert lex("&,") == [{:operator, %{}, "&"}, {:punctuation, %{}, ","}]
    end

    test "anonymous function with arguments" do
      assert lex("&(&1)") == [
               {:operator, %{}, "&"},
               {:punctuation, %{group_id: "group-1"}, "("},
               {:name_entity, %{}, "&1"},
               {:punctuation, %{group_id: "group-1"}, ")"}
             ]

      assert lex("&(&1, &2)") == [
               {:operator, %{}, "&"},
               {:punctuation, %{group_id: "group-1"}, "("},
               {:name_entity, %{}, "&1"},
               {:punctuation, %{}, ","},
               {:whitespace, %{}, " "},
               {:name_entity, %{}, "&2"},
               {:punctuation, %{group_id: "group-1"}, ")"}
             ]
    end
  end

  test "bitwise operators" do
    assert lex("1 >>> 2") == [
             {:number_integer, %{}, "1"},
             {:whitespace, %{}, " "},
             {:operator, %{}, ">>>"},
             {:whitespace, %{}, " "},
             {:number_integer, %{}, "2"}
           ]

    assert lex("1 <<< 2") == [
             {:number_integer, %{}, "1"},
             {:whitespace, %{}, " "},
             {:operator, %{}, "<<<"},
             {:whitespace, %{}, " "},
             {:number_integer, %{}, "2"}
           ]
  end

  describe "syntax sugar for keyword lists" do
    test "keys are normal atoms" do
      assert lex("atom: value") == [
               {:string_symbol, %{}, "atom"},
               {:punctuation, %{}, ":"},
               {:whitespace, %{}, " "},
               {:name, %{}, "value"}
             ]

      assert lex("Atom: value") == [
               {:string_symbol, %{}, "Atom"},
               {:punctuation, %{}, ":"},
               {:whitespace, %{}, " "},
               {:name, %{}, "value"}
             ]

      assert lex("atom@host: value") == [
               {:string_symbol, %{}, "atom@host"},
               {:punctuation, %{}, ":"},
               {:whitespace, %{}, " "},
               {:name, %{}, "value"}
             ]
    end

    test "keys are string-like atomes" do
      assert lex(~S["atom": value]) == [
               {:string_symbol, %{}, "\"atom\""},
               {:punctuation, %{}, ":"},
               {:whitespace, %{}, " "},
               {:name, %{}, "value"}
             ]

      assert lex(~S["!a-b?c": value]) == [
               {:string_symbol, %{}, "\"!a-b?c\""},
               {:punctuation, %{}, ":"},
               {:whitespace, %{}, " "},
               {:name, %{}, "value"}
             ]

      assert lex(~S["\n\s\t": value]) == [
               {:string_symbol, %{}, "\""},
               {:string_escape, %{}, "\\n"},
               {:string_escape, %{}, "\\s"},
               {:string_escape, %{}, "\\t"},
               {:string_symbol, %{}, "\""},
               {:punctuation, %{}, ":"},
               {:whitespace, %{}, " "},
               {:name, %{}, "value"}
             ]
    end
  end

  describe "declarations" do
    test "defmodule" do
      assert lex("defmodule MyModule") == [
               {:keyword_declaration, %{}, "defmodule"},
               {:whitespace, %{}, " "},
               {:name_class, %{}, "MyModule"}
             ]
    end

    test "def, defmacro, etc. - no function name" do
      assert lex("def") == [{:keyword_declaration, %{}, "def"}]
      assert lex("defp") == [{:keyword_declaration, %{}, "defp"}]
      assert lex("defmacro") == [{:keyword_declaration, %{}, "defmacro"}]
      assert lex("defmacrop") == [{:keyword_declaration, %{}, "defmacrop"}]
      assert lex("defimpl") == [{:keyword_declaration, %{}, "defimpl"}]
    end
  end

  describe "atoms" do
    test "normal atoms" do
      assert lex(":atom") == [{:string_symbol, %{}, ":atom"}]
    end

    test "normal atoms - '@' character is valid in the middle or at the end" do
      assert lex(":atom@somewhere") == [{:string_symbol, %{}, ":atom@somewhere"}]
      assert lex(":atom@@@atom") == [{:string_symbol, %{}, ":atom@@@atom"}]
      assert lex(":atom@@@atom@@") == [{:string_symbol, %{}, ":atom@@@atom@@"}]
    end

    test "normal atoms - '@' character is not valid at the beginning" do
      assert lex(":@atom") == [
               {:punctuation, %{}, ":"},
               {:name_attribute, %{}, "@atom"}
             ]
    end

    test "string-like atoms" do
      assert lex(~S[:"a!&;//"]) == [{:string_symbol, %{}, ~S[:"a!&;//"]}]
      assert lex(~S[:'a!&;//']) == [{:string_symbol, %{}, ~S[:'a!&;//']}]
    end

    test "triple colon" do
      assert lex(":::") === [{:string_symbol, %{}, ":::"}]
    end

    test "operator names" do
      assert lex(":+") === [{:string_symbol, %{}, ":+"}]
      assert lex(":..") === [{:string_symbol, %{}, ":.."}]
    end

    test "special atom names" do
      assert lex(":...") === [{:string_symbol, %{}, ":..."}]
      assert lex(":%{}") === [{:string_symbol, %{}, ":%{}"}]
    end

    test "atoms used as modules are highlighted as modules" do
      assert lex(":crypto.strong_rand_bytes(4)") === [
               {:name_class, %{}, ":crypto"},
               {:operator, %{}, "."},
               {:name, %{}, "strong_rand_bytes"},
               {:punctuation, %{group_id: "group-1"}, "("},
               {:number_integer, %{}, "4"},
               {:punctuation, %{group_id: "group-1"}, ")"}
             ]
    end
  end

  describe "numbers" do
  end

  describe "stacktrace" do
    test "raw" do
      # real error from a `mix docs` task (some problem when interfacing with node)
      assert lex("""
             ** (ErlangError) Erlang error: :eacces
                 erlang.erl:2112: :erlang.open_port({:spawn_executable, 'c:/Program Files/nodejs/npm.cmd'}, [:use_stdio, :exit_status, :binary, :hide, {:args, ["run", "docs"]}])
                 (elixir) lib/system.ex:629: System.cmd/3
                 (mix) lib/mix/task.ex:353: Mix.Task.run_alias/3
                 (mix) lib/mix/task.ex:277: Mix.Task.run/2
                 (mix) lib/mix/cli.ex:80: Mix.CLI.run_task/2
                 (elixir) lib/code.ex:677: Code.require_file/2\
             """) == [
               {:generic_traceback, %{},
                """
                ** (ErlangError) Erlang error: :eacces
                    erlang.erl:2112: :erlang.open_port({:spawn_executable, 'c:/Program Files/nodejs/npm.cmd'}, [:use_stdio, :exit_status, :binary, :hide, {:args, ["run", "docs"]}])
                    (elixir) lib/system.ex:629: System.cmd/3
                    (mix) lib/mix/task.ex:353: Mix.Task.run_alias/3
                    (mix) lib/mix/task.ex:277: Mix.Task.run/2
                    (mix) lib/mix/cli.ex:80: Mix.CLI.run_task/2
                    (elixir) lib/code.ex:677: Code.require_file/2\
                """}
             ]
    end

    test "inside iex" do
      assert lex("""
             iex> raise_error
             ** (ErlangError) Erlang error: :eacces
                 erlang.erl:2112: :erlang.open_port({:spawn_executable, :error})
                 (elixir) lib/system.ex:629: System.cmd/3
             iex> 1 + 2
             3
             """) == [
               {:generic_prompt, %{selectable: false}, "iex> "},
               {:name, %{}, "raise_error"},
               {:whitespace, %{}, "\n"},
               {:generic_traceback, %{},
                """
                ** (ErlangError) Erlang error: :eacces
                    erlang.erl:2112: :erlang.open_port({:spawn_executable, :error})
                    (elixir) lib/system.ex:629: System.cmd/3\
                """},
               {:whitespace, %{}, "\n"},
               {:generic_prompt, %{selectable: false}, "iex> "},
               {:number_integer, %{}, "1"},
               {:whitespace, %{}, " "},
               {:operator, %{}, "+"},
               {:whitespace, %{}, " "},
               {:number_integer, %{}, "2"},
               {:whitespace, %{}, "\n"},
               {:number_integer, %{}, "3"},
               {:whitespace, %{}, "\n"}
             ]
    end
  end

  @sigil_delimiters [
    {~S["""], ~S["""]},
    {"'''", "'''"},
    {"\"", "\""},
    {"'", "'"},
    {"/", "/"},
    {"{", "}"},
    {"[", "]"},
    {"(", ")"},
    {"<", ">"},
    {"|", "|"}
  ]

  # A subset of `@sigil_delimiters`
  @string_like_delimiters [
    {~S["""], ~S["""]},
    {"'''", "'''"},
    {"\"", "\""},
    {"'", "'"}
  ]

  describe "interpolation" do
    test "sigils with interpolation (lowercase letters)" do
      for b <- ?a..?z do
        for {llim, rlim} <- @sigil_delimiters do
          left = "~#{<<b>>}#{llim}x"
          middle = "\#{y}"
          right = "z#{rlim}"

          sigil = left <> middle <> right

          assert [
                   {sigil_tag, %{}, ^left},
                   {:string_interpol, %{group_id: "group-1"}, "\#{"},
                   {:name, %{}, "y"},
                   {:string_interpol, %{group_id: "group-1"}, "}"},
                   {sigil_tag, %{}, ^right}
                 ] = lex(sigil)
        end
      end
    end

    test "sigils without interpolation (uppercase letter)" do
      for b <- ?A..?Z do
        for {llim, rlim} <- @sigil_delimiters, {llim, rlim} != {"{", "}"} do
          sigil = "~#{<<b>>}#{llim}x\#{y}z#{rlim}"

          assert [{_sigil_tag, %{}, ^sigil}] = lex(sigil)
        end
      end
    end
  end

  test "calendar sigils" do
    assert lex("~D[2020-01-01]") == [{:literal_date, %{}, "~D[2020-01-01]"}]
    assert lex("~T[01:23:45]") == [{:literal_date, %{}, "~T[01:23:45]"}]
    assert lex("~N[2020-01-01 01:23:45]") == [{:literal_date, %{}, "~N[2020-01-01 01:23:45]"}]
    assert lex("~U[2020-01-01 01:23:45Z]") == [{:literal_date, %{}, "~U[2020-01-01 01:23:45Z]"}]
  end

  describe "strings and sigils" do
    test "unicode codepoints" do
      assert lex(~S["\u0000"]) == [
               {:string, %{}, "\""},
               {:string_escape, %{}, "\\u0000"},
               {:string, %{}, "\""}
             ]

      # Uppercase decimal digits are allowed
      assert lex(~S["\ua1B2"]) == [
               {:string, %{}, "\""},
               {:string_escape, %{}, "\\ua1B2"},
               {:string, %{}, "\""}
             ]

      assert lex(~S["X\ua1B2Y"]) == [
               {:string, %{}, "\"X"},
               {:string_escape, %{}, "\\ua1B2"},
               {:string, %{}, "Y\""}
             ]
    end
  end

  test "iex prompt inside string" do
    code = """
    iex> a = "
    ...> ine1
    ...> line2
    ...> ilne3
    ...> "
    """

    assert lex(code) == [
             {:generic_prompt, %{selectable: false}, "iex> "},
             {:name, %{}, "a"},
             {:whitespace, %{}, " "},
             {:operator, %{}, "="},
             {:whitespace, %{}, " "},
             {:string, %{}, "\""},
             {:generic_prompt, %{selectable: false}, "\n...> "},
             {:string, %{}, "ine1"},
             {:generic_prompt, %{selectable: false}, "\n...> "},
             {:string, %{}, "line2"},
             {:generic_prompt, %{selectable: false}, "\n...> "},
             {:string, %{}, "ilne3"},
             {:generic_prompt, %{selectable: false}, "\n...> "},
             {:string, %{}, "\""},
             {:whitespace, %{}, "\n"}
           ]
  end

  # Generalization of the above
  test "iex prompt inside strings, charlists and heredocs" do
    for prompt_number <- ["", "(1)", "(22)"] do
      for {ldelim, rdelim} <- @string_like_delimiters do
        code = ~s'''
        iex#{prompt_number}> x = #{ldelim}
        ...#{prompt_number}> line1
        ...#{prompt_number}> line2
        ...#{prompt_number}> line3
        ...#{prompt_number}> #{rdelim}
        '''

        first_prompt = "iex#{prompt_number}> "
        other_prompt = "\n...#{prompt_number}> "

        assert [
                 {:generic_prompt, %{selectable: false}, ^first_prompt},
                 {:name, %{}, "x"},
                 {:whitespace, %{}, " "},
                 {:operator, %{}, "="},
                 {:whitespace, %{}, " "},
                 {ttype, %{}, ^ldelim},
                 {:generic_prompt, %{selectable: false}, ^other_prompt},
                 {ttype, %{}, "line1"},
                 {:generic_prompt, %{selectable: false}, ^other_prompt},
                 {ttype, %{}, "line2"},
                 {:generic_prompt, %{selectable: false}, ^other_prompt},
                 {ttype, %{}, "line3"},
                 {:generic_prompt, %{selectable: false}, ^other_prompt},
                 {ttype, %{}, ^rdelim},
                 {:whitespace, %{}, "\n"}
               ] = lex(code)
      end
    end
  end

  test "iex prompt inside sigils (not strings, charlists or heredocs)" do
    lowercase = Enum.map(?a..?z, fn c -> <<"~", c>> end)
    uppercase = Enum.map(?A..?Z, fn c -> <<"~", c>> end)
    sigil_prefixes = lowercase ++ uppercase

    for prompt_number <- ["", "(1)", "(22)"] do
      for {ldelim, rdelim} <- @sigil_delimiters do
        for sigil_prefix <- sigil_prefixes do
          code = ~s'''
          iex#{prompt_number}> x = #{sigil_prefix}#{ldelim}
          ...#{prompt_number}> line1
          ...#{prompt_number}> line2
          ...#{prompt_number}> line3
          ...#{prompt_number}> #{rdelim}
          '''

          first_prompt = "iex#{prompt_number}> "
          other_prompt = "\n...#{prompt_number}> "

          sigil_start = sigil_prefix <> ldelim

          assert [
                   {:generic_prompt, %{selectable: false}, ^first_prompt},
                   {:name, %{}, "x"},
                   {:whitespace, %{}, " "},
                   {:operator, %{}, "="},
                   {:whitespace, %{}, " "},
                   {ttype, %{}, ^sigil_start},
                   {:generic_prompt, %{selectable: false}, ^other_prompt},
                   {ttype, %{}, "line1"},
                   {:generic_prompt, %{selectable: false}, ^other_prompt},
                   {ttype, %{}, "line2"},
                   {:generic_prompt, %{selectable: false}, ^other_prompt},
                   {ttype, %{}, "line3"},
                   {:generic_prompt, %{selectable: false}, ^other_prompt},
                   {ttype, %{}, ^rdelim},
                   {:whitespace, %{}, "\n"}
                 ] = lex(code)
        end
      end
    end
  end

  test "PIDs" do
    assert lex("#PID<0.489.0>") == [
             {:punctuation, %{group_id: "group-1"}, "#"},
             {:name_class, %{group_id: "group-1"}, "PID"},
             {:punctuation, %{group_id: "group-1"}, "<"},
             {:number_integer, %{}, "0"},
             {:operator, %{}, "."},
             {:number_integer, %{}, "489"},
             {:operator, %{}, "."},
             {:number_integer, %{}, "0"},
             {:punctuation, %{group_id: "group-1"}, ">"}
           ]

    assert lex("#PID<112.489.940>") == [
             {:punctuation, %{group_id: "group-1"}, "#"},
             {:name_class, %{group_id: "group-1"}, "PID"},
             {:punctuation, %{group_id: "group-1"}, "<"},
             {:number_integer, %{}, "112"},
             {:operator, %{}, "."},
             {:number_integer, %{}, "489"},
             {:operator, %{}, "."},
             {:number_integer, %{}, "940"},
             {:punctuation, %{group_id: "group-1"}, ">"}
           ]
  end

  test "unicode variables" do
    assert lex("josé = 'awesome'") == [
             {:name, %{}, "josé"},
             {:whitespace, %{}, " "},
             {:operator, %{}, "="},
             {:whitespace, %{}, " "},
             {:string_char, %{}, "'awesome'"}
           ]
  end

  test "unicode atoms" do
    assert lex(":josé@home") == [{:string_symbol, %{}, ":josé@home"}]
  end

  test "triple dot is a special name" do
    assert lex("...") == [{:name, %{}, "..."}]
  end

  test "map" do
    assert lex("%{:a => 1}") == [
             {:punctuation, %{group_id: "group-1"}, "%{"},
             {:string_symbol, %{}, ":a"},
             {:whitespace, %{}, " "},
             {:punctuation, %{}, "=>"},
             {:whitespace, %{}, " "},
             {:number_integer, %{}, "1"},
             {:punctuation, %{group_id: "group-1"}, "}"}
           ]
  end
end
