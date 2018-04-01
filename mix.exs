defmodule MakeupElixir.Mixfile do
  use Mix.Project

  def project do
    [
      app: :makeup_elixir,
      version: "0.4.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      # Package
      package: package(),
      description: description()
    ]
  end

  defp description do
    """
    Elixir lexer for the Makeup syntax highlighter.
    """
  end

  defp package do
    [
      name: :makeup_elixir,
      licenses: ["BSD"],
      maintainers: ["Tiago Barroso <tmbb@campus.ul.pt>"],
      links: %{"GitHub" => "https://github.com/tmbb/makeup_elixir"}
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:nimble_parsec, "~> 0.2.2"},
      {:makeup, "~> 0.4.0"},
      # {:makeup, path: "../makeup"},
      {:ex_doc, "~> 0.18.3", only: [:dev]},
      {:benchee, "~> 0.12.1", only: [:test, :dev]},
      {:branch_point, git: "https://github.com/tmbb/branch_point"}
    ]
  end
end
