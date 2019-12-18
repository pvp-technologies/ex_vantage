defmodule AirVantage.Operations.DeviceManagementTest do
  use ExUnit.Case, async: true

  alias AirVantage.Operations.DeviceManagement

  describe "wake_up" do
    test "responds with success by returning an operation number" do
      response = DeviceManagement.wake_up(["ebec8233db9047388a2b00e82c7e8a1b"])
      assert !is_nil(response["operation"])
    end
  end
end
