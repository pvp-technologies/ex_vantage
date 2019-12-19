defmodule AirVantage.Operations.Communication do
  import AirVantage.Request

  def send_sms(uids, msg_content) do
    params = %{
      "systems" => %{
        "uids" => uids
      },
      "content" => msg_content
    }

    new_request()
    |> put_endpoint("/v1/operations/systems/sms")
    |> put_method(:post)
    |> put_params(params)
    |> make_request()
  end
end
