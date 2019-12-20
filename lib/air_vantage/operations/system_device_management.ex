defmodule AirVantage.Operations.SystemDeviceManagement do
  @moduledoc false

  import AirVantage.Request

  @doc """
  Wakes up a communication application deployed on a selection of systems in order to force this application to communicate with the Operating Portal.
  """
  @spec wake_up(list) :: {:ok, map} | {:error, Error.t()}
  def wake_up(uids) do
    params = %{
      "action" => "READYAGENT_DM_CONNECT",
      "systems" => %{
        "uids" => uids
      }
    }

    new_request()
    |> put_endpoint("/v1/operations/systems/wakeup")
    |> put_params(params)
    |> put_method(:post)
    |> make_request()
  end
end
