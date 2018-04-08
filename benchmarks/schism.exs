Kernel.ParallelCompiler.compile([
  "benchmarks/schism/inline_vs_no_inline.exs",
  "benchmarks/schism/language_metadata.exs",
  "benchmarks/schism/map_lookup_vs_pattern_matching.exs"
])

alias Makeup.Lexers.ElixirLexer.Benchmarks.Schism.{
  InlineVsNoInline,
  LanguageMetadata,
  MapLookupVsPatternMatching
}

InlineVsNoInline.run()
LanguageMetadata.run()
MapLookupVsPatternMatching.run()
