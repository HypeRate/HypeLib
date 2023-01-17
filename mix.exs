defmodule HypeLib.MixProject do
  use Mix.Project

  def project do
    [
      app: :hype_lib,
      version: "0.0.1",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
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
      {:absinthe, "~> 1.7"},
      {:ecto, "~> 3.6.2"},
      {:type_check, "~> 0.13.2"}
    ]
  end
end
