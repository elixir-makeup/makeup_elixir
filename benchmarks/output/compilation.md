# Benchmark

Benchmark run from 2020-10-01 13:43:05.162879Z UTC

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

## Statistics

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
    <td style="white-space: nowrap">Lexer compilation time - ascii only</td>
    <td style="white-space: nowrap; text-align: right">0.0579</td>
    <td style="white-space: nowrap; text-align: right">17.28 s</td>
    <td style="white-space: nowrap; text-align: right">±0.00%</td>
    <td style="white-space: nowrap; text-align: right">17.28 s</td>
    <td style="white-space: nowrap; text-align: right">17.28 s</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">Lexer compilation time - custom parsec</td>
    <td style="white-space: nowrap; text-align: right">0.0511</td>
    <td style="white-space: nowrap; text-align: right">19.57 s</td>
    <td style="white-space: nowrap; text-align: right">±0.00%</td>
    <td style="white-space: nowrap; text-align: right">19.57 s</td>
    <td style="white-space: nowrap; text-align: right">19.57 s</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">Lexer compilation time - regex</td>
    <td style="white-space: nowrap; text-align: right">0.0497</td>
    <td style="white-space: nowrap; text-align: right">20.13 s</td>
    <td style="white-space: nowrap; text-align: right">±0.00%</td>
    <td style="white-space: nowrap; text-align: right">20.13 s</td>
    <td style="white-space: nowrap; text-align: right">20.13 s</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">Lexer compilation time - parsec</td>
    <td style="white-space: nowrap; text-align: right">0.0298</td>
    <td style="white-space: nowrap; text-align: right">33.54 s</td>
    <td style="white-space: nowrap; text-align: right">±0.00%</td>
    <td style="white-space: nowrap; text-align: right">33.54 s</td>
    <td style="white-space: nowrap; text-align: right">33.54 s</td>
  </tr>
</table>
Comparison
<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">Lexer compilation time - ascii only</td>
    <td style="white-space: nowrap;text-align: right">0.0579</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">Lexer compilation time - custom parsec</td>
    <td style="white-space: nowrap; text-align: right">0.0511</td>
    <td style="white-space: nowrap; text-align: right">1.13x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">Lexer compilation time - regex</td>
    <td style="white-space: nowrap; text-align: right">0.0497</td>
    <td style="white-space: nowrap; text-align: right">1.16x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">Lexer compilation time - parsec</td>
    <td style="white-space: nowrap; text-align: right">0.0298</td>
    <td style="white-space: nowrap; text-align: right">1.94x</td>
  </tr>
</table>
<hr/>
