defmodule AirVantage.Operations.SystemCommunicationTest do
  use ExUnit.Case, async: true

  alias AirVantage.Operations.SystemCommunication

  import Mox

  setup :verify_on_exit!

  describe "send_sms" do
    test "responds with success by returning an operation number" do
      AirVantage.APIMock
      |> expect(:request, fn _params, _method, _endpoint, _headers, _opts ->
        {:ok,
         %{
           "operation" => "4b89657f63aac4b299c1d46e98a495326"
         }}
      end)

      {:ok, response} =
        SystemCommunication.send_sms(["0fda23be05fc4edaa8d92c4091dd7f93"], "SMS message content")

      assert !is_nil(response["operation"])
    end
  end
end
