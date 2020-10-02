Benchee.run(%{
  "Project compilation time" => fn ->
    System.cmd("mix", ["compile", "--force"])
  end
},
  formatters: [
    {Benchee.Formatters.Console, []},
    {Benchee.Formatters.Markdown, file: "benchmarks/data/compilation.md"}
  ])
