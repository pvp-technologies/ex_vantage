use Mix.Config

config :ex_vantage, :api_client, AirVantage.API
config :logger, level: :debug

# Import environment configuration
import_config "#{Mix.env()}.exs"
