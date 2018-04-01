alias Makeup.Lexers.ElixirLexer
# Test file taken from the Pygments' test suite
source_path = "benchmarks/data/example_file.exs"
# Read the file into a variable because we're not interested in the time it takes to read from disk.
code = File.read!(source_path)

# Runtime speed
Benchee.run(%{
  "Map lookup" => {
    fn _input -> ElixirLexer.lex(code) end,
    before_scenario: fn _input ->
      BranchPoint.pick_alternatives(map_lookup_vs_pattern_matching: :default)
    end
  },
  "Pattern matching" => {
    fn _input -> ElixirLexer.lex(code) end,
    before_scenario: fn _input ->
      BranchPoint.pick_alternatives(map_lookup_vs_pattern_matching: "pattern matching")
    end
  },
}, print: [benchmarking: true])

# Compilation speed
Benchee.run(%{
  "Map lookup" => {
    fn _input ->
      Kernel.ParallelCompiler.compile(["lib/makeup/lexers/elixir_lexer.ex"])
    end,
    before_scenario: fn _input ->
      BranchPoint.pick_alternatives(map_lookup_vs_pattern_matching: :default)
    end
  },
  "Pattern matching" => {
    fn _input ->
      Kernel.ParallelCompiler.compile(["lib/makeup/lexers/elixir_lexer.ex"])
    end,
    before_scenario: fn _input ->
      BranchPoint.pick_alternatives(map_lookup_vs_pattern_matching: "pattern matching")
    end
  },
}, print: [benchmarking: true])
