defmodule MakeupElixir.SchismBenchmarksSigilsAndIdentifiers do
  alias Makeup.Lexers.ElixirLexer
  alias Makeup.Formatters.HTML.HTMLFormatter
  require Logger

  def all_combinations([]), do: [[]]

  def all_combinations([{x, xs} | rest]) do
    x_pairs = Enum.map(xs, fn v -> {x, v} end)
    next_combinations = all_combinations(rest)

    nested =
      for combination <- next_combinations do
        for x_pair <- x_pairs do
          [x_pair | combination]
        end
      end

    Enum.concat(nested)
  end

  def setup_conversions(name, fun, schisms_and_conversions) do
    combinations = all_combinations(schisms_and_conversions)

    for combination <- combinations, into: %{} do
      schism_to_belief_map = Enum.into(combination, %{})
      key = name <> " " <> inspect(schism_to_belief_map)
      value =
        {
          fun,
          [
            before_scenario: fn _input ->
              Schism.convert(schism_to_belief_map)
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

    settings = [
      {"sigils", ["internal", "external"]},
      {"variables and atoms", ["split", "together"]}
    ]

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

MakeupElixir.SchismBenchmarksSigilsAndIdentifiers.run()