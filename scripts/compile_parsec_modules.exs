files = [
  "lib/makeup/lexers/elixir_lexer/atoms.ex.exs",
  "lib/makeup/lexers/elixir_lexer/variables.ex.exs",
  "lib/makeup/lexers/elixir_lexer/sigils.ex.exs"
]

for file <- files do
  Mix.Tasks.NimbleParsec.Compile.run([file])
end