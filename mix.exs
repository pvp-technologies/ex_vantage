defmodule AirVantage.MixProject do
  use Mix.Project

  @version "0.0.1"

  def project do
    [
      app: :ex_vantage,
      version: @version,
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      docs: docs(),
      aliases: aliases()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :jason, :plug, :uri_query],
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
      {:plug_cowboy, "~> 1.0"},
      {:uri_query, "~> 0.1"},
      {:credo, "~> 1.1", only: :dev, runtime: false},
      {:dialyxir, "~> 1.0.0-rc.7", only: :dev, runtime: false},
      {:excoveralls, "~> 0.10", only: :test},
      {:inch_ex, github: "rrrene/inch_ex", only: :dev, runtime: false},
      {:sobelow, "~> 0.9", only: :dev, runtime: false},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false}
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: [
        "README.md"
      ],
      source_ref: "v#{@version}",
      source_url: "https://github.com/pvp-technologies/ex_vantage",
      groups_for_modules: [
        Operations: [
          AirVantage.Operations,
          AirVantage.Operations.System,
          AirVantage.Operations.SystemCommunication,
          AirVantage.Operations.SystemDeviceManagement
        ]
      ],
      nest_modules_by_prefix: [
        AirVantage.Operations,
        AirVantage.Operations.System,
        AirVantage.Operations.SystemCommunication,
        AirVantage.Operations.SystemDeviceManagement
      ]
    ]
  end

  defp aliases do
    [docs: ["docs --output docs"]]
  end
end
