defmodule MakeupElixir.SchismBenchmarksVariablesAndAtoms do
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

    settings = {"variables and atoms", ["split", "together"]}

    lexer_performance_benchmarks =
      setup_conversions(
        "Lexer performance",
        fn _ -> ElixirLexer.lex(code) end,
        settings
      )

    compilation_benchmarks =
      setup_conversions(
        "Project compilation time",
        fn _ ->
          Mix.Tasks.Compile.Elixir.run(["--force"])
        end,
        settings
      )

    benchmarks = [
      {lexer_performance_benchmarks, "lexer_performance"},
      {compilation_benchmarks, "project_compilation"}
    ]

    for {benchmark, name} <- benchmarks do
      path = Path.join("benchmarks/output/variables_and_atoms", name <> ".md")
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

MakeupElixir.SchismBenchmarksVariablesAndAtoms.run()