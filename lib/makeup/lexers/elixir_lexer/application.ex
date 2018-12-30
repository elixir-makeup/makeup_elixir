defmodule Makeup.Lexers.ElixirLexer.Application do
  @moduledoc false
  use Application

  alias Makeup.Registry
  alias Makeup.Lexers.ElixirLexer

  def start(_type, _args) do
    Registry.register_lexer_with_name("elixir", {ElixirLexer, []})
    # USe the normal Elixir lexer for `iex` prompts
    Registry.register_lexer_with_name("iex", {ElixirLexer, []})
    Supervisor.start_link([], strategy: :one_for_one)
  end
end
