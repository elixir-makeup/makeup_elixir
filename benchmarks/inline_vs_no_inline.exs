alias Makeup.Lexers.ElixirLexer
# Test file taken from the Pygments' test suite
source_path = "benchmarks/data/example_file.exs"
# Read the file into a variable because we're not interested in the time it takes to read from disk.
code = File.read!(source_path)

# Runtime speed
Benchee.run(%{
  "Without inline" => {
    fn _input -> ElixirLexer.lex(code) end,
    before_scenario: fn _input ->
      BranchPoint.pick_alternatives(inline_vs_no_inline: :default)
    end
  },
  "With inline" => {
    fn _input -> ElixirLexer.lex(code) end,
    before_scenario: fn _input ->
      BranchPoint.pick_alternatives(inline_vs_no_inline: "with inline")
    end
  },
}, print: [benchmarking: true])

# Compilation speed
Benchee.run(%{
  "Without inline" => {
    fn _input ->
      Kernel.ParallelCompiler.compile(["lib/makeup/lexers/elixir_lexer.ex"])
    end,
    before_scenario: fn _input ->
      BranchPoint.pick_alternatives(inline_vs_no_inline: :default)
    end
  },
  "With inline" => {
    fn _input ->
      Kernel.ParallelCompiler.compile(["lib/makeup/lexers/elixir_lexer.ex"])
    end,
    before_scenario: fn _input ->
      BranchPoint.pick_alternatives(inline_vs_no_inline: "with inline")
    end
  },
}, print: [benchmarking: true])
