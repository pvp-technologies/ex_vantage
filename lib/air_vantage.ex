defmodule AirVantage do
  @moduledoc """
  A simple HTTP client to communicate with AirVantage API.
  """

  @doc """
  Callback for the application.
  It Starts the supervision tree.
  """
  @spec start(Application.start_type(), any) :: {:error, any} | {:ok, pid} | {:ok, pid, any}
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
