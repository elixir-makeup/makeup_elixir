# MakeupElixir

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `makeup_elixir` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:makeup_elixir, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/makeup_elixir](https://hexdocs.pm/makeup_elixir).

## Benchmarks

### Inlining parsecs

* Lexing speed:
  [comparison](assets/benchmarks/inline_vs_no_inline-lexing-speed_comparison.html);
  [with inlined parsecs](assets/benchmarks/inline_vs_no_inline-lexing-speed_with_inline.html);
  [without inlined parsecs](assets/benchmarks/inline_vs_no_inline-lexing-speed_without_inline.html).
  Very weird performance characteristics.
  Faster on average but extremely high latency in the worst case.

* Compilation speed:
  [comparison](assets/benchmarks/inline_vs_no_inline-compilation-speed_comparison.html);
  [with inlined parsecs](assets/benchmarks/inline_vs_no_inline-compilation-speed_with_inline.html);
  [without inlined parsecs](assets/benchmarks/inline_vs_no_inline-compilation-speed_without_inline.html).
  As expected, compiling the inlined parsecs is much slower (about 2x slower)

### Postprocessing the token lists using map lookup VS pattern matching

* Lexing speed:
  [comparison](assets/benchmarks/map_lookup_vs_pattern_matching-lexing-speed_comparison.html);
  [map lookup](assets/benchmarks/map_lookup_vs_pattern_matching-lexing-speed_map_lookup.html);
  [pattern matching](assets/benchmarks/map_lookup_vs_pattern_matching-lexing-speed_pattern_matching.html).
  Very weird performance characteristics.
  Faster on average but extremely high latency in the worst case.

* Compilation speed:
  [comparison](assets/benchmarks/map_lookup_vs_pattern_matching-compilation-speed_comparison.html);
  [map lookup](assets/benchmarks/map_lookup_vs_pattern_matching-compilation-speed_map_lookup.html);
  [pattern matching](assets/benchmarks/map_lookup_vs_pattern_matching-compilation-speed_pattern matching.html).

### Keep language-specific metadata

This is important if one wants to embed a lexer inside another lexer.
Unfortunately, it does slow down the lexer a bit.

* Lexing speed:
  [comparison](assets/benchmarks/language_metadata-lexing-speed_comparison.html);
  [with language metadata](assets/benchmarks/language_metadata-lexing-speed_with_language_metadata.html);
  [without language metadata](assets/benchmarks/language_metadata-lexing-speed_without_language_metadata.html).

* Compilation speed:
  [comparison](assets/benchmarks/language_metadata-compilation-speed_comparison.html);
  [with language metadata](assets/benchmarks/language_metadata-compilation-speed_with_with_language_metadata.html);
  [without language metadata](assets/benchmarks/language_metadata-compilation-speed_without_language_metadata.html).