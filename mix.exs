defmodule Cyphex.Mixfile do
  use Mix.Project

  @version "0.0.1"
  @description "Cypher query language parsing library for Elixir"
  @repo_url "https://github.com/johnhamelink/cyphex"

  def project do
    [app: :cyphex,
     name: "Cyphex",
     version: @version,
     elixir: "~> 1.1",
     description: @description,
     package: package,
     source_url: @repo_url,
     homepage_url: @repo_url,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     docs: [main: "README", extras: ["README.md"]]]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:mix_test_watch, "~> 0.2", only: :dev},
      {:ex_spec, "~> 1.0.0", only: :test},
      {:inch_ex, only: :docs},
      {:earmark, "~> 0.1", only: :dev},
      {:ex_doc, "~> 0.11", only: :dev}
    ]
  end

  defp package do
    [maintainers: ["John Hamelink"],
     licenses: ["MIT"],
     links: %{"GitHub" => @repo_url},
     files: ~w(lib src/*.xrl src/*.yrl mix.exs *.md LICENSE)]
  end
end
