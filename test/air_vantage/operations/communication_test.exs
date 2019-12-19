defmodule AirVantage.Operations.CommunicationTest do
  use ExUnit.Case, async: true

  alias AirVantage.Operations.Communication

  describe "send_sms" do
    test "responds with success by returning an operation number" do
      response =
        Communication.send_sms(["0fda23be05fc4edaa8d92c4091dd7f93"], "SMS message content")

      assert !is_nil(response["operation"])
    end
  end
end
