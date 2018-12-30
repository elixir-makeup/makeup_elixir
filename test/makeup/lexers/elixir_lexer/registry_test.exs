defmodule Makeup.Lexers.ElixirLexer.RegistryTest do
  use ExUnit.Case, async: true

  alias Makeup.Registry
  alias Makeup.Lexers.ElixirLexer

  test "the elixir lexer has successfully registered itself" do
    assert {:ok, {ElixirLexer, []}} == Registry.fetch_lexer_by_name("elixir")
    assert {:ok, {ElixirLexer, []}} == Registry.fetch_lexer_by_name("iex")
  end
end
