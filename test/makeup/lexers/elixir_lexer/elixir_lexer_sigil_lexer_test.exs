defmodule ElixirLexerSigilLexerTest do
  use ExUnit.Case, async: false
  import Makeup.Lexers.ElixirLexer.Testing, only: [lex: 1]

  describe "custom lexers for sigils" do
    test "can register a custom lexer" do
      defmodule MyCustomLexer do
        def lex(input, opts) do
          [{:keyword, %{opts: opts}, input}]
        end
      end

      Makeup.Lexers.ElixirLexer.register_sigil_lexer("H", MyCustomLexer, foo: :bar)

      assert lex("~H|Hello, world!|") == [
               {:string_sigil, %{}, "~H|"},
               {:keyword, %{opts: [foo: :bar]}, "Hello, world!"},
               {:string_sigil, %{}, "|"}
             ]
    after
      Application.put_env(:makeup_elixir, :sigil_lexers, %{})
    end

    test "does not lex inside iex prompts" do
      # does not exist, but should also not be invoked
      Makeup.Lexers.ElixirLexer.register_sigil_lexer("PY", DoesNotExist, foo: :bar)

      # if it tried to use the sigil lexer, it would crash
      assert lex("""
             iex> import Pythonx
             iex> x = 1
             iex> ~PY\"""
             ...> y = 10
             ...> x + y
             ...> \"""
             #Pythonx.Object<
               11
             >
             iex> x
             1
             iex> y
             #Pythonx.Object<
               10
             >
             """)
    end
  end
end
