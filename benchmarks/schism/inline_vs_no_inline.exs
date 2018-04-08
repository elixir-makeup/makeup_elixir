defmodule Makeup.Lexers.ElixirLexer.Benchmarks.Schism.InlineVsNoInline do
  alias Makeup.Lexers.ElixirLexer
  # Test file taken from the Pygments' test suite
  # Read the file into a variable because we're not interested in the time it takes to read from disk.
  @code File.read!("benchmarks/data/example_file.exs")

  def run() do
    # Runtime speed
    Benchee.run(%{
      "Without inline" => {
        fn _input -> ElixirLexer.lex(@code) end,
        before_scenario: fn _input ->
          Schism.convert(%{"inline vs no inline" => "no inline"})
        end
      },
      "With inline" => {
        fn _input -> ElixirLexer.lex(@code) end,
        before_scenario: fn _input ->
          Schism.convert(%{"inline vs no inline" => "inline"})
        end
      },
    }, formatters: [
        Benchee.Formatters.HTML,
        Benchee.Formatters.Console
      ],
      formatter_options: [
        html: [file: "assets/benchmarks/inline_vs_no_inline-lexing-speed.html", auto_open: false]
      ]
    )

    # Compilation speed
    Benchee.run(%{
      "Without inline" => {
        fn _input ->
          Kernel.ParallelCompiler.compile(["lib/makeup/lexers/elixir_lexer.ex"])
        end,
        before_scenario: fn _input ->
          Schism.convert(%{"inline vs no inline" => "no inline"})
        end
      },
      "With inline" => {
        fn _input ->
          Kernel.ParallelCompiler.compile(["lib/makeup/lexers/elixir_lexer.ex"])
        end,
        before_scenario: fn _input ->
          Schism.convert(%{"inline vs no inline" => "inline"})
        end
      },
    }, formatters: [
        Benchee.Formatters.HTML,
        Benchee.Formatters.Console
      ],
      formatter_options: [
        html: [file: "assets/benchmarks/inline_vs_no_inline-compilation-speed.html", auto_open: false]
      ]
    )
  end
end
