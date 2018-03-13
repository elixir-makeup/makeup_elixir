defmodule Makeup.Lexers.ElixirLexer.ElixirLexerTokenizerTest do
  # The tests need to be checked manually!!!
  use ExUnit.Case, async: true
  alias Makeup.Lexers.ElixirLexer

  describe "iex prompt" do
    test "parses iex prompt correctly (first line)" do
      assert ElixirLexer.lex("iex>") == [{:generic_prompt, "iex>", %{selectable: false}}]
      assert ElixirLexer.lex("iex(1)>") == [{:generic_prompt, "iex(1)>", %{selectable: false}}]
      assert ElixirLexer.lex("iex(12)>") == [{:generic_prompt, "iex(12)>", %{selectable: false}}]
    end

    test "accepts correct iex prompt (continuation)" do
      # misses the `>`
      assert ElixirLexer.lex("...>") == nil
    end

    test "rejects incomplete iex prompt (first line)" do
      # missing the `>`
      assert ElixirLexer.lex("iex") == [{:name, %{}, "iex"}]
      # missing the `>`
      assert ElixirLexer.lex("iex(8)", group_prefix: "group") == nil
      # missing the number
      assert ElixirLexer.lex("iex()>", group_prefix: "group") == [
        {:name, %{}, "iex"},
        {:punctuation, %{group_id: "group-1"}, "("},
        {:punctuation, %{group_id: "group-1"}, ")"},
        {:operator, %{}, ">"}
      ]
    end

    test "rejects incomplete iex prompt (continuation)" do
      # missing the `>`
      assert ElixirLexer.lex("...") ==  [{:name, %{}, "..."}]
      # missing the `>`
      assert ElixirLexer.lex("...<") == [{:name, %{}, "..."}, {:operator, %{}, "<"}]
    end
  end
end
