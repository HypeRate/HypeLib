defmodule HypeLib.MixProject do
  use Mix.Project

  def project do
    [
      app: :hype_lib,
      version: "0.0.1",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Docs
      name: "HypeLib",
      source_url: "https://github.com/HypeRate/HypeLib",
      homepage_url: "https://hyperate.io",
      docs: [
        # The main page in the docs
        main: "HypeLib",
        extras: ["README.md"]
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
      {:ex_doc, "~> 0.27", only: :dev, runtime: false}
    ]
  end
end
