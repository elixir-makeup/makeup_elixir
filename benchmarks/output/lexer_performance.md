# Benchmark

Benchmark run from 2020-09-30 11:07:35.179159Z UTC

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
    <td style="white-space: nowrap">Lexer performance - ascii only</td>
    <td style="white-space: nowrap; text-align: right">137.10</td>
    <td style="white-space: nowrap; text-align: right">7.29 ms</td>
    <td style="white-space: nowrap; text-align: right">±7.37%</td>
    <td style="white-space: nowrap; text-align: right">7.23 ms</td>
    <td style="white-space: nowrap; text-align: right">9.17 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">Lexer performance - parsec</td>
    <td style="white-space: nowrap; text-align: right">132.52</td>
    <td style="white-space: nowrap; text-align: right">7.55 ms</td>
    <td style="white-space: nowrap; text-align: right">±8.50%</td>
    <td style="white-space: nowrap; text-align: right">7.55 ms</td>
    <td style="white-space: nowrap; text-align: right">8.98 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">Lexer performance - regex</td>
    <td style="white-space: nowrap; text-align: right">0.0717</td>
    <td style="white-space: nowrap; text-align: right">13949.59 ms</td>
    <td style="white-space: nowrap; text-align: right">±0.00%</td>
    <td style="white-space: nowrap; text-align: right">13949.59 ms</td>
    <td style="white-space: nowrap; text-align: right">13949.59 ms</td>
  </tr>
</table>
Comparison
<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">Lexer performance - ascii only</td>
    <td style="white-space: nowrap;text-align: right">137.10</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">Lexer performance - parsec</td>
    <td style="white-space: nowrap; text-align: right">132.52</td>
    <td style="white-space: nowrap; text-align: right">1.03x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">Lexer performance - regex</td>
    <td style="white-space: nowrap; text-align: right">0.0717</td>
    <td style="white-space: nowrap; text-align: right">1912.48x</td>
  </tr>
</table>
<hr/>
