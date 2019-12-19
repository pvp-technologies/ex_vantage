defmodule AirVantage.Operations.DeviceManagementTest do
  use ExUnit.Case, async: true

  alias AirVantage.Operations.DeviceManagement

  describe "wake_up" do
    test "responds with success by returning an operation number" do
      response = DeviceManagement.wake_up(["0fda23be05fc4edaa8d92c4091dd7f93"])
      assert !is_nil(response["operation"])
    end
  end
end
