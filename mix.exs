defmodule AirVantage.MixProject do
  use Mix.Project

  @version "0.0.1"

  def project do
    [
      app: :ex_vantage,
      deps: deps(),
      docs: docs(),
      elixirc_paths: elixirc_paths(Mix.env()),
      elixir: "~> 1.9",
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      version: @version
    ]
  end

  def application do
    [
      extra_applications: [:logger, :jason, :uri_query],
      mod: {AirVantage, []}
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.1", only: :dev, runtime: false},
      {:dialyxir, "~> 1.0.0-rc.7", only: :dev, runtime: false},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
      {:excoveralls, "~> 0.10", only: :test},
      {:hackney, "~> 1.15"},
      {:inch_ex, github: "rrrene/inch_ex", only: :dev, runtime: false},
      {:jason, "~> 1.1"},
      {:mox, "~> 0.5", only: :test},
      {:sobelow, "~> 0.9", only: :dev, runtime: false},
      {:uri_query, "~> 0.1"}
    ]
  end

  defp elixirc_paths(:test), do: ["test/support", "lib"]
  defp elixirc_paths(_), do: ["lib"]

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
end
