defmodule Makeup.Test.Generators.ElixirLexer.ElixirLexerGroupTestGenerator do
  require EEx
  import Makeup.Lexers.ElixirLexer.Testing, only: [lex: 1]

  def indent(text, n) do
    text
    |> String.split("\n")
    |> Enum.map(fn line -> String.duplicate(" ", n) <> line end)
    |> Enum.join("\n")
    |> String.trim_leading
  end

  EEx.function_from_string :def, :gen_group_test_file, """
  defmodule <%= @name %> do
    # The tests need to be checked manually!!! (remove this line when they've been checked)
    use ExUnit.Case, async: true
    import Makeup.Lexers.ElixirLexer.Testing, only: [lex: 1]
    alias Makeup.Lexer

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
        code = <%= inspect(input) %>
        assert lex(code) == <%= output %>
        assert code |> lex() |> Lexer.unlex() == code
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
      # Extra whitespace in order to avoid syntax errors with the bitwise operators
      {"#OpaqueStruct<...>", fn s -> "#OpaqueStruct< #{s} >" end},
      # Extra whitespace for the same reason
      # TODO: find a better way to fix this without requiring the whitespace
      {"<<...>>", fn s -> "<< #{s} >>" end}
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
