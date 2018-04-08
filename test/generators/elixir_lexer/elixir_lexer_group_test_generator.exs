defmodule Makeup.Test.Generators.ElixirLexer.ElixirLexerGroupTestGenerator do
  require EEx
  alias Makeup.Lexers.ElixirLexer
  alias Makeup.Lexer.Postprocess

  def indent(text, n) do
    text
    |> String.split("\n")
    |> Enum.map(fn line -> String.duplicate(" ", n) <> line end)
    |> Enum.join("\n")
    |> String.trim_leading
  end

  def lex(text) do
    text
    |> ElixirLexer.lex(group_prefix: "group")
    |> Postprocess.token_values_to_binaries()
    |> Enum.map(fn {ttype, meta, value} -> {ttype, Map.delete(meta, :language), value} end)
  end

  EEx.function_from_string :def, :gen_group_test_file, """
  defmodule <%= @name %> do
    # The tests need to be checked manually!!! (remove this line when they've been checked)
    use ExUnit.Case, async: true
    alias Makeup.Lexers.ElixirLexer
    alias Makeup.Lexer.Postprocess

    # This function has two purposes:
    # 1. Ensure deterministic lexer output (no random prefix)
    # 2. Convert the token values into binaries so that the output
    #    is more obvious on visual inspection
    #    (iolists are hard to parse by a human)
    def lex(text) do
      text
      |> ElixirLexer.lex(group_prefix: "group")
      |> Postprocess.token_values_to_binaries()
      |> Enum.map(fn {ttype, meta, value} -> {ttype, Map.delete(meta, :language), value} end)
    end

    describe "all group transitions" do\
  <%= for {name1, fun1} <- @funs do %><%= for {name2, fun2} <- @funs do %>

      test "`<%= name1 %>` + `<%= name2 %>`" do\
  <% input = fun1.(fun2.("x"))
     output =
      input
      |> lex()
      |> inspect
      |> Code.format_string!
      |> Enum.join
      |> indent(6) %>
        assert lex(<%= inspect input %>) == <%= output %>
      end<% end %><% end %>
    end
  end
  """, [:assigns]

  def funs do
    [
      {"do ... end", fn s -> "do #{s} end" end},
      {"do ... else ... end", fn s -> "do #{s} else #{s} end" end},
      {"fn ... end", fn s -> "fn -> #{s} end" end},
      {"(...)", fn s -> "(#{s})" end},
      {"[...]", fn s -> "[#{s}]" end},
      {"{...}", fn s -> "{#{s}}" end},
      {"%{...}", fn s -> "%{#{s}}" end},
      {"%Struct{...}", fn s -> "%Struct{#{s}}" end},
      {"#OpaqueStruct<...>", fn s -> "#Struct<#{s}>" end},
      {"<<...>>", fn s -> "<<#{s}>>" end}
    ]
  end

  def run() do
    content = gen_group_test_file(
      funs: funs(),
      name: "Makeup.Lexers.ElixirLexer.ElixirLexerGroupsTest"
    )

    filename = "test/makeup/lexers/elixir_lexer/elixir_lexer_groups_test.exs"
    File.write!(filename, content)
    IO.puts "Done."
  end
end

Makeup.Test.Generators.ElixirLexer.ElixirLexerGroupTestGenerator.run()
