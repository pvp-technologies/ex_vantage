defmodule AirVantage.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_vantage,
      version: "0.0.1",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {AirVantage, [env: Mix.env()]},
      applications: applications(Mix.env())
    ]
  end

  defp applications(:test), do: applications(:default) ++ [:cowboy, :plug]
  defp applications(_), do: [:hackney]

  defp deps do
    [
      {:jason, "~> 1.1"},
      {:hackney, "~> 1.15"},
      {:plug, "~> 1.8"},
      {:plug_cowboy, "~> 2.1"},
      {:uri_query, "~> 0.1"},
      {:credo, "~> 1.1", only: :dev, runtime: false},
      {:dialyxir, "~> 1.0.0-rc.7", only: :dev, runtime: false},
      {:excoveralls, "~> 0.10", only: :test},
      {:inch_ex, github: "rrrene/inch_ex", only: :dev, runtime: false}
    ]
  end
end
