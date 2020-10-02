# Benchmark

Benchmark run from 2020-10-02 11:54:22.486565Z UTC

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
    <td style="white-space: nowrap">Lexer performance %{"sigils" => "external", "variables and atoms" => "split"}</td>
    <td style="white-space: nowrap; text-align: right">146.92</td>
    <td style="white-space: nowrap; text-align: right">6.81 ms</td>
    <td style="white-space: nowrap; text-align: right">±6.02%</td>
    <td style="white-space: nowrap; text-align: right">6.84 ms</td>
    <td style="white-space: nowrap; text-align: right">8.22 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">Lexer performance %{"sigils" => "internal", "variables and atoms" => "together"}</td>
    <td style="white-space: nowrap; text-align: right">145.01</td>
    <td style="white-space: nowrap; text-align: right">6.90 ms</td>
    <td style="white-space: nowrap; text-align: right">±6.23%</td>
    <td style="white-space: nowrap; text-align: right">6.87 ms</td>
    <td style="white-space: nowrap; text-align: right">8.14 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">Lexer performance %{"sigils" => "external", "variables and atoms" => "together"}</td>
    <td style="white-space: nowrap; text-align: right">144.83</td>
    <td style="white-space: nowrap; text-align: right">6.90 ms</td>
    <td style="white-space: nowrap; text-align: right">±7.30%</td>
    <td style="white-space: nowrap; text-align: right">6.89 ms</td>
    <td style="white-space: nowrap; text-align: right">8.59 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">Lexer performance %{"sigils" => "internal", "variables and atoms" => "split"}</td>
    <td style="white-space: nowrap; text-align: right">144.11</td>
    <td style="white-space: nowrap; text-align: right">6.94 ms</td>
    <td style="white-space: nowrap; text-align: right">±5.61%</td>
    <td style="white-space: nowrap; text-align: right">6.91 ms</td>
    <td style="white-space: nowrap; text-align: right">8.17 ms</td>
  </tr>
</table>
Comparison
<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">Lexer performance %{"sigils" => "external", "variables and atoms" => "split"}</td>
    <td style="white-space: nowrap;text-align: right">146.92</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">Lexer performance %{"sigils" => "internal", "variables and atoms" => "together"}</td>
    <td style="white-space: nowrap; text-align: right">145.01</td>
    <td style="white-space: nowrap; text-align: right">1.01x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">Lexer performance %{"sigils" => "external", "variables and atoms" => "together"}</td>
    <td style="white-space: nowrap; text-align: right">144.83</td>
    <td style="white-space: nowrap; text-align: right">1.01x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">Lexer performance %{"sigils" => "internal", "variables and atoms" => "split"}</td>
    <td style="white-space: nowrap; text-align: right">144.11</td>
    <td style="white-space: nowrap; text-align: right">1.02x</td>
  </tr>
</table>
<hr/>
