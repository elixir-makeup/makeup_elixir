Kernel.ParallelCompiler.compile([
  "benchmarks/schism/inline_vs_no_inline.exs",
  "benchmarks/schism/map_lookup_vs_pattern_matching.exs",
  "benchmarks/schism/complexity.exs"
])

alias Makeup.Lexers.ElixirLexer.Benchmarks.Schism.{
  InlineVsNoInline,
  MapLookupVsPatternMatching,
  Complexity
}

InlineVsNoInline.run()
MapLookupVsPatternMatching.run()
Complexity.run()
