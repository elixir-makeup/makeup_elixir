defmodule Makeup.Lexers.ElixirLexer.ElixirLexerTokenizerTest do
  # The tests need to be checked manually!!!
  use ExUnit.Case, async: true
  alias Makeup.Lexers.ElixirLexer

  describe "iex prompt" do
    test "parses iex prompt correctly (first line)" do
      assert ElixirLexer.lex("iex>") == [{:generic_prompt, %{selectable: false}, "iex>"}]
      assert ElixirLexer.lex("iex(1)>") == [{:generic_prompt, %{selectable: false}, "iex(1)>"}]
      assert ElixirLexer.lex("iex(12)>") == [{:generic_prompt, %{selectable: false}, "iex(12)>"}]
    end

    test "accepts correct iex prompt (continuation)" do
      # misses the `>`
      assert ElixirLexer.lex("...>") == [{:generic_prompt, %{selectable: false}, "...>"}]
    end

    test "rejects incomplete iex prompt (first line)" do
      # missing the `>`
      assert ElixirLexer.lex("iex") == [{:name, %{}, "iex"}]
      # with number but missing the `>`
      assert ElixirLexer.lex("iex(8)", group_prefix: "group") == [
        {:name, %{}, "iex"},
        {:punctuation, %{group_id: "group-1"}, "("},
        {:number_integer, %{}, "8"},
        {:punctuation, %{group_id: "group-1"}, ")"}
      ]
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

  describe "anonymous functions" do
    test "accepts anonymous function argument" do
      assert ElixirLexer.lex("&1") == [{:name_entity, %{}, "&1"}]
      assert ElixirLexer.lex("&2") == [{:name_entity, %{}, "&2"}]
      assert ElixirLexer.lex("&666") == [{:name_entity, %{}, "&666"}]
    end

    test "rejects incorrect anonymous function argument" do
      assert ElixirLexer.lex("&p") == [{:operator, %{}, "&"}, {:name, %{}, "p"}]
      assert ElixirLexer.lex("&!") == [{:operator, %{}, "&"}, {:operator, %{}, "!"}]
      assert ElixirLexer.lex("&,") == [{:operator, %{}, "&"}, {:punctuation, %{}, ","}]
    end

    test "anonymous function with arguments" do
      assert ElixirLexer.lex("&(&1)", group_prefix: "group") == [
        {:operator, %{}, "&"},
        {:punctuation, %{group_id: "group-1"}, "("},
        {:name_entity, %{}, "&1"},
        {:punctuation, %{group_id: "group-1"}, ")"}
      ]

      assert ElixirLexer.lex("&(&1, &2)", group_prefix: "group") == [
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
end
