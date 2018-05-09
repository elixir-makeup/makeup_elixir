defmodule Makeup.Lexers.ElixirLexer.Benchmarks.Schism.Complexity do
  alias Makeup.Lexers.ElixirLexer
  # Test file taken from the Pygments' test suite
  # Read the file into a variable because we're not interested in the time it takes to read from disk.
  @code File.read!("benchmarks/data/example_file.exs")

  def run() do
    inputs =
      for i <- 1..9, into: %{} do
        input = String.duplicate(@code, i)
        kbytes = byte_size(input) / 1000
        {"#{i}x ref. (#{kbytes}kB)", input}
      end

    Benchee.run(%{
      "parse delimited pairs" => {
        fn input -> ElixirLexer.lex(input) end,
        before_scenario: fn input ->
          Schism.convert(%{"delimited pairs" => "parse delimited pairs"})
          input
        end
      },
      "no delimited pairs" => {
        fn input -> ElixirLexer.lex(input) end,
        before_scenario: fn input ->
          Schism.convert(%{"delimited pairs" => "no delimited pairs"})
          input
        end
      }
    },
      inputs: inputs,
      formatters: [
        Benchee.Formatters.HTML,
        Benchee.Formatters.Console
      ],
      formatter_options: [
        html: [
          file: "assets/benchmarks/delimited_pairs-complexity.html",
          auto_open: false]
      ]
    )
  end
end

Makeup.Lexers.ElixirLexer.Benchmarks.Complexity.run()
