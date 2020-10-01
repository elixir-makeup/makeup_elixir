defmodule SchismBenchmarks do
  alias Makeup.Lexers.ElixirLexer
  alias Makeup.Formatters.HTML.HTMLFormatter
  require Logger

  def setup_conversions(name, fun, _combinator = {schism, options}) do
    for option <- options, into: %{} do
      key = name <> " - " <> option
      value =
        {
          fun,
          [
            before_scenario: fn _input ->
              Schism.convert(%{schism => option})
            end
          ]
        }

      {key, value}
    end
  end

  def run() do
    # Test file taken from the Pygments' test suite
    source_path = "benchmarks/data/example_file.exs"
    # Read the file into a variable because we're not interested in the time it takes to read from disk.
    code = File.read!(source_path)
    # Get a list of tokens from the code above, so that we can test the HTML Formatter in isolation
    tokens = ElixirLexer.lex(code)

    settings = {"parsec vs regex", ["custom parsec 2", "custom parsec", "parsec", "ascii only"]}

    lexer_performance_benchmarks =
      setup_conversions(
        "Lexer performance",
        fn _ -> ElixirLexer.lex(code) end,
        settings
      )

    _format_performance_benchmarks =
      setup_conversions(
        "Formatter performance",
        fn _ -> HTMLFormatter.format_as_binary(tokens) end,
        settings
      )

    _lexer_plus_formatter_performance_benchmarks =
      setup_conversions(
        "Lexer + Formatter",
        fn _ ->
          code
          |> ElixirLexer.lex()
          |> HTMLFormatter.format_as_binary()
        end,
        settings
      )

    _end_to_end_performance_benchmarks =
      setup_conversions(
        "Reading file from disk + Lexer + Formatter (end to end)",
        fn _ ->
          source_path
          |> File.read!()
          |> ElixirLexer.lex()
          |> HTMLFormatter.format_as_binary()
        end,
        settings
      )

    compilation_benchmarks =
      setup_conversions(
        "Lexer compilation time",
        fn _ ->
          Kernel.ParallelCompiler.compile(["lib/makeup/lexers/elixir_lexer.ex"])
        end,
        settings
      )

    benchmarks = [
      {lexer_performance_benchmarks, "lexer_performance"},
      {compilation_benchmarks, "compilation"}
    ]

    for {benchmark, name} <- benchmarks do
      path = Path.join("benchmarks/output", name <> ".md")
      Benchee.run(
        benchmark,
        formatters: [
          {Benchee.Formatters.Console, []},
          {Benchee.Formatters.Markdown, file: path}
        ]
      )

      Logger.info("finished benchmark - '#{name}'; output saved in '#{path}'")
    end
  end
end

SchismBenchmarks.run()