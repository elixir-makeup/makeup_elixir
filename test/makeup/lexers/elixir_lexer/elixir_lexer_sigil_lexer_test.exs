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
  end
end
