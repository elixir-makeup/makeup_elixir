alias Makeup.Lexers.ElixirLexer
alias Makeup.Formatters.HTML.HTMLFormatter

# Test file taken from the Pygments' test suite
source_path = "benchmarks/data/example_file.exs"
# Read the file into a variable because we're not interested in the time it takes to read from disk.
code = File.read!(source_path)
# Get a list of tokens from the code above, so that we can test the HTML Formatter in isolation
tokens = ElixirLexer.lex(code)

Benchee.run(%{
  "Lexer performance" => fn ->
    ElixirLexer.lex(code)
  end,
  "Formatter performance" => fn ->
    HTMLFormatter.format_as_binary(tokens)
  end,
  "Lexer + Formatter" => fn ->
    code
    |> ElixirLexer.lex()
    |> HTMLFormatter.format_as_binary()
  end,
  "Reading file from disk + Lexer + Formatter (end to end)" => fn ->
    source_path
    |> File.read!()
    |> ElixirLexer.lex()
    |> HTMLFormatter.format_as_binary()
  end,
  "Lexer compilation time" => fn ->
    Kernel.ParallelCompiler.compile(["lib/makeup/lexers/elixir_lexer.ex"])
  end
},
  console: [
    # Don't display comparisons because we're testing different things
    # Comparisons would be meaningless
    comparison: false
  ])
