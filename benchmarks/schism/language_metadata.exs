defmodule Makeup.Lexers.ElixirLexer.Benchmarks.Schism.LanguageMetadata do
  alias Makeup.Lexers.ElixirLexer
  # Test file taken from the Pygments' test suite
  # Read the file into a variable because we're not interested in the time it takes to read from disk.
  @code File.read!("benchmarks/data/example_file.exs")

  def run() do
    # Runtime speed
    Benchee.run(%{
      "Without language metadata" => {
        fn _input -> ElixirLexer.lex(@code) end,
        before_scenario: fn _input ->
          Schism.convert(%{"language metadata" => "without language metadata"})
        end
      },
      "With language metadata" => {
        fn _input -> ElixirLexer.lex(@code) end,
        before_scenario: fn _input ->
          Schism.convert(%{"language metadata" => "with language metadata"})
        end
      },
    }, formatters: [
        Benchee.Formatters.HTML,
        Benchee.Formatters.Console
      ],
      formatter_options: [
        html: [file: "assets/benchmarks/language_metadata-lexing-speed.html", auto_open: false]
      ]
    )

    # Compilation speed
    Benchee.run(%{
      "Without language metadata" => {
        fn _input ->
          Kernel.ParallelCompiler.compile(["lib/makeup/lexers/elixir_lexer.ex"])
        end,
        before_scenario: fn _input ->
          Schism.convert(%{"language metadata" => "without language metadata"})
        end
      },
      "With language metadata" => {
        fn _input ->
          Kernel.ParallelCompiler.compile(["lib/makeup/lexers/elixir_lexer.ex"])
        end,
        before_scenario: fn _input ->
          Schism.convert(%{"language metadata" => "with language metadata"})
        end
      },
    }, formatters: [
        Benchee.Formatters.HTML,
        Benchee.Formatters.Console
      ],
      formatter_options: [
        html: [file: "assets/benchmarks/language_metadata-compilation-speed.html", auto_open: false]
      ]
    )
  end
end
