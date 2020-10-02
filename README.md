# MakeupElixir
[![Build Status](https://travis-ci.org/tmbb/makeup_elixir.svg?branch=master)](https://travis-ci.org/tmbb/makeup_elixir)

A [Makeup](https://github.com/tmbb/makeup/) lexer for the Elixir language.

## Installation

Add `makeup_elixir` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:makeup_elixir, "~> 0.14.0"}
  ]
end
```

The lexer will be automatically registered in Makeup for
the languages "elixir" and "iex" as well as the extensions
".ex" and ".exs".
