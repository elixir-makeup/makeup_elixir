defmodule ElixirLexerTokenizerTestSnippet do
  use ExUnit.Case, async: false
  import Makeup.Lexers.ElixirLexer.Testing, only: [lex: 1]

  test "builtins" do
    # is a builtin and not an unused variable!
    assert lex("_") == [{:name_builtin_pseudo, %{}, "_"}]
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
      assert lex("...") ==  [{:name, %{}, "..."}]
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
      assert lex("defcallback") == [{:keyword_declaration, %{}, "defcallback"}]
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
    {"(", ")"}
  ]

  describe "interpolation" do
    test "sigils with interpolation (lowercase letters)" do
      for b <- ?a..?z do
        for {llim, rlim} <- @sigil_delimiters do
          left = "~#{<< b >>}#{llim}x"
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
          sigil = "~#{<< b >>}#{llim}x\#{y}z#{rlim}"

          assert [{_sigil_tag, %{}, ^sigil}] = lex(sigil)
        end
      end
    end
  end

  describe "strings and sigils" do
    test "unicode codepoints" do
      assert lex(~S["\u0000"]) ==  [
        {:string, %{}, "\""},
        {:string_escape, %{}, "\\u0000"},
        {:string, %{}, "\""}
      ]

      # Uppercase decimal digits are allowed
      assert lex(~S["\ua1B2"]) ==  [
        {:string, %{}, "\""},
        {:string_escape, %{}, "\\ua1B2"},
        {:string, %{}, "\""}
      ]

      assert lex(~S["X\ua1B2Y"]) ==  [
        {:string, %{}, "\"X"},
        {:string_escape, %{}, "\\ua1B2"},
        {:string, %{}, "Y\""}
      ]
    end
  end
end
