defmodule MakeupElixir.Mixfile do
  use Mix.Project

  def project do
    [
      app: :makeup_elixir,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env == :prod,
      deps: deps()
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
      {:makeup, path: "../makeup"},
      {:benchee, "~> 0.12.1", only: [:test, :dev]}
    ]
  end
end
