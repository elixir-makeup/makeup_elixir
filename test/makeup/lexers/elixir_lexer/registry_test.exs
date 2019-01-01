defmodule Makeup.Lexers.ElixirLexer.RegistryTest do
  use ExUnit.Case, async: true

  alias Makeup.Registry
  alias Makeup.Lexers.ElixirLexer

  describe "the elixir lexer has successfully registered itself:" do
    test "language name" do
      assert {:ok, {ElixirLexer, []}} == Registry.fetch_lexer_by_name("elixir")
      assert {:ok, {ElixirLexer, []}} == Registry.fetch_lexer_by_name("iex")
    end

    test "file extension" do
      assert {:ok, {ElixirLexer, []}} == Registry.fetch_lexer_by_extension("exs")
      assert {:ok, {ElixirLexer, []}} == Registry.fetch_lexer_by_extension("ex")
    end
  end
end
