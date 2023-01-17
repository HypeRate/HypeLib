defmodule HypeLib.MixProject do
  use Mix.Project

  @github_url "https://github.com/HypeRate/HypeLib"

  def project do
    [
      app: :hype_lib,
      version: "0.0.1",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Docs
      name: "HypeLib",
      source_url: @github_url,
      homepage_url: "https://hyperate.io",
      docs: [
        # The main page in the docs
        main: "HypeLib",
        extras: ["README.md"]
      ],

      # Packaging

      files: ~w(mix.exs lib LICENSE.md README.md),
      package: [
        maintainers: ["Yannick Fricke"],
        licenses: ["MIT"],
        links: %{
          "GitHub" => @github_url
        }
      ],

      # Coveralls
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
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
      {:absinthe, "~> 1.7"},
      {:ecto, "~> 3.6"},
      {:type_check, "~> 0.13.2"},
      {:ex_doc, "~> 0.27", only: :dev, runtime: false},

      # Quality assurance
      {:credo, "~> 1.5", only: [:dev, :test]},
      {:excoveralls, "~> 0.10", only: :test}
    ]
  end
end
