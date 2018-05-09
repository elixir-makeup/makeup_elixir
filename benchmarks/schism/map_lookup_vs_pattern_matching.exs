defmodule Makeup.Lexers.ElixirLexer.Benchmarks.Schism.MapLookupVsPatternMatching do
  alias Makeup.Lexers.ElixirLexer
  # Test file taken from the Pygments' test suite
  # Read the file into a variable because we're not interested in the time it takes to read from disk.
  @code File.read!("benchmarks/data/example_file.exs") |> String.duplicate(10)

  def run() do
    # Runtime speed
    Benchee.run(%{
      "Map lookup" => {
        fn _input -> ElixirLexer.lex(@code) end,
        before_scenario: fn _input ->
          Schism.convert(%{"map lookup vs pattern matching" => "map lookup"})
        end
      },
      "Pattern matching" => {
        fn _input -> ElixirLexer.lex(@code) end,
        before_scenario: fn _input ->
          Schism.convert(%{"map lookup vs pattern matching" => "pattern matching"})
        end
      },
    }, formatters: [
        Benchee.Formatters.HTML,
        Benchee.Formatters.Console
      ],
      formatter_options: [
        html: [file: "assets/benchmarks/map_lookup_vs_pattern_matching-lexing-speed.html", auto_open: false]
      ]
    )

    # Compilation speed
    Benchee.run(%{
      "Map lookup" => {
        fn _input ->
          Kernel.ParallelCompiler.compile(["lib/makeup/lexers/elixir_lexer.ex"])
        end,
        before_scenario: fn _input ->
          Schism.convert(%{"map lookup vs pattern matching" => "map lookup"})
        end
      },
      "Pattern matching" => {
        fn _input ->
          Kernel.ParallelCompiler.compile(["lib/makeup/lexers/elixir_lexer.ex"])
        end,
        before_scenario: fn _input ->
          Schism.convert(%{"map lookup vs pattern matching" => "pattern matching"})
        end
      },
    }, formatters: [
        Benchee.Formatters.HTML,
        Benchee.Formatters.Console
      ],
      formatter_options: [
        html: [file: "assets/benchmarks/map_lookup_vs_pattern_matching-compilation-speed.html", auto_open: false]
      ]
    )
  end
end

# Makeup.Lexers.ElixirLexer.Benchmarks.Schism.MapLookupVsPatternMatching.run()
