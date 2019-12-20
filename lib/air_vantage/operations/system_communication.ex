defmodule AirVantage.Operations.SystemCommunication do
  @moduledoc false

  import AirVantage.Request

  alias AirVantage.Error

  @doc """
  Sends a text SMS to a selection of systems.
  """
  @spec send_sms(list, String.t()) :: {:ok, map} | {:error, Error.t()}
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
