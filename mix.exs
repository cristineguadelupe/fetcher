defmodule Fetcher.MixProject do
  use Mix.Project

  def project do
    [
      app: :fetcher,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Fetcher.Application, [env: Mix.env()]}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:req, "~> 0.3.6"},
      {:floki, "~> 0.34.2"},
      {:plug_cowboy, "~> 2.6", only: :test}
    ]
  end
end
