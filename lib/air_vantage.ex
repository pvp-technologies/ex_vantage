defmodule AirVantage do
  def start(_type, args) do
    children =
      case args do
        [env: :test] ->
          [{Plug.Cowboy, scheme: :http, plug: AirVantage.MockServer, options: [port: 8081]}]

        _ ->
          []
      end

    opts = [strategy: :one_for_one, name: AirVantage.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
