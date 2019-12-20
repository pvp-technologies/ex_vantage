defmodule AirVantage.Operations.SystemCommunicationTest do
  use ExUnit.Case, async: true

  alias AirVantage.Operations.SystemCommunication

  describe "send_sms" do
    test "responds with success by returning an operation number" do
      {:ok, response} =
        SystemCommunication.send_sms(["0fda23be05fc4edaa8d92c4091dd7f93"], "SMS message content")

      assert !is_nil(response["operation"])
    end
  end
end
