defmodule Faunadoo.MixProject do
  use Mix.Project

  def project do
    [
      app: :faunadoo,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Index, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 2.2"},
      {:jason, "~> 1.4"},
      {:dotenv, "~> 3.1"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*"],
      maintainers: ["Yuliya Petrunkina", "Shadid Haque"],
      licenses: ["Apache 2.0"],
      description: "A terminal-based todo app that uses Elixir and Fauna. You can use this as a reference for how to access and use Fauna in your projects.",
      links: %{"GitHub" => "https://github.com/YuliyaPetru/elixir_faunadoo_todo"}
    ]
  end
end
