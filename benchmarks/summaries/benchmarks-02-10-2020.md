## System

Benchmark suite executing on the following system:

<table style="width: 1%">
  <tr>
    <th style="width: 1%; white-space: nowrap">Operating System</th>
    <td>Linux</td>
  </tr><tr>
    <th style="white-space: nowrap">CPU Information</th>
    <td style="white-space: nowrap">Intel(R) Core(TM) i7-6700HQ CPU @ 2.60GHz</td>
  </tr><tr>
    <th style="white-space: nowrap">Number of Available Cores</th>
    <td style="white-space: nowrap">8</td>
  </tr><tr>
    <th style="white-space: nowrap">Available Memory</th>
    <td style="white-space: nowrap">7.87 GB</td>
  </tr><tr>
    <th style="white-space: nowrap">Elixir Version</th>
    <td style="white-space: nowrap">1.10.4</td>
  </tr><tr>
    <th style="white-space: nowrap">Erlang Version</th>
    <td style="white-space: nowrap">23.0.3</td>
  </tr>
</table>

## Configuration

Benchmark suite executing with the following configuration:

<table style="width: 1%">
  <tr>
    <th style="width: 1%">:time</th>
    <td style="white-space: nowrap">5 s</td>
  </tr><tr>
    <th>:parallel</th>
    <td style="white-space: nowrap">1</td>
  </tr><tr>
    <th>:warmup</th>
    <td style="white-space: nowrap">2 s</td>
  </tr>
</table>

# Lexer Performance

Run Time

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Average</th>
    <th style="text-align: right">Devitation</th>
    <th style="text-align: right">Median</th>
    <th style="text-align: right">99th&nbsp;%</th>
  </tr>
  <tr>
    <td style="white-space: nowrap">Lexer performance - external</td>
    <td style="white-space: nowrap; text-align: right">146.39</td>
    <td style="white-space: nowrap; text-align: right">6.83 ms</td>
    <td style="white-space: nowrap; text-align: right">±6.48%</td>
    <td style="white-space: nowrap; text-align: right">6.82 ms</td>
    <td style="white-space: nowrap; text-align: right">8.26 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">Lexer performance - internal</td>
    <td style="white-space: nowrap; text-align: right">141.31</td>
    <td style="white-space: nowrap; text-align: right">7.08 ms</td>
    <td style="white-space: nowrap; text-align: right">±4.55%</td>
    <td style="white-space: nowrap; text-align: right">7.02 ms</td>
    <td style="white-space: nowrap; text-align: right">8.39 ms</td>
  </tr>
</table>

Comparison

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">Lexer performance - external</td>
    <td style="white-space: nowrap;text-align: right">146.39</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">Lexer performance - internal</td>
    <td style="white-space: nowrap; text-align: right">141.31</td>
    <td style="white-space: nowrap; text-align: right">1.04x</td>
  </tr>
</table>

# Project Compilation (all files, not only the lexer)

Run Time

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Average</th>
    <th style="text-align: right">Devitation</th>
    <th style="text-align: right">Median</th>
    <th style="text-align: right">99th&nbsp;%</th>
  </tr>
  <tr>
    <td style="white-space: nowrap">Project compilation time - external</td>
    <td style="white-space: nowrap; text-align: right">0.159</td>
    <td style="white-space: nowrap; text-align: right">6.28 s</td>
    <td style="white-space: nowrap; text-align: right">±0.00%</td>
    <td style="white-space: nowrap; text-align: right">6.28 s</td>
    <td style="white-space: nowrap; text-align: right">6.28 s</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">Project compilation time - internal</td>
    <td style="white-space: nowrap; text-align: right">0.0738</td>
    <td style="white-space: nowrap; text-align: right">13.55 s</td>
    <td style="white-space: nowrap; text-align: right">±0.00%</td>
    <td style="white-space: nowrap; text-align: right">13.55 s</td>
    <td style="white-space: nowrap; text-align: right">13.55 s</td>
  </tr>
</table>

Comparison

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">Project compilation time - external</td>
    <td style="white-space: nowrap;text-align: right">0.159</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">Project compilation time - internal</td>
    <td style="white-space: nowrap; text-align: right">0.0738</td>
    <td style="white-space: nowrap; text-align: right">2.16x</td>
  </tr>
</table>

# Discussion

In the `"internal"` case the sigils are compiled in the `ElixirLexer` module. In the `"external"` case they are compiled in a different module, which allows the parallel compiler to distribute the compilation work between several cores. This leads to a very large peformance impact during compilation (compilation time is reduced by 50%)

There is no performance penalty for splitting the sigils into another module (I start to think that for complex parsers there isn't such a great performance advantage of using combinators instead of parsecs).

Splitting the sigils comes with some code organization challenges, because inside a sigil you can have pretty much any element from the lexer because of interpolation. To handle that I had to create some public combinators in the `ElixirLexer` module which are invoked inside the `Sigils` module. At the same time, the `ElixirLexer` invokes a combinator from the `Sigils` module. Because these dependencies only matter at runtime and not at compile time, this is not such a big deal, but it's inelegant. Despite the lack of elegance, the performance impact is so big that I chose to keep it.

I didn't split the `Atom` and `Variable` modules further because it didn't result in further compilation speed improvements (the relevant schisms have been deleted, otherwise the source would have become *really* confusing).

These benchmarks were done with `Schism` but for the final release and before merging into master I will remove the dependency on `Schism`. Sadly I haven't found a way of making `Schism` a `:dev`-only dependency.