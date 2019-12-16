defmodule AirVantage.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_vantage,
      version: "0.0.1",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :oauth2],
      mod: {AirVantage.Application, [env: Mix.env()]},
      applications: applications(Mix.env())
    ]
  end

  defp applications(:test), do: applications(:default) ++ [:cowboy, :plug]
  defp applications(_), do: [:hackney]

  defp deps do
    [
      {:jason, "~> 1.1"},
      {:hackney, "~> 1.15"},
      {:oauth2, "~> 2.0"},
      {:plug, "~> 1.8"},
      {:plug_cowboy, "~> 2.1"}
    ]
  end
end
