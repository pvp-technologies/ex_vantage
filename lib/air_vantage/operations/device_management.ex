defmodule AirVantage.Operations.DeviceManagement do
  import AirVantage.Request

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
