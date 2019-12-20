defmodule AirVantage.Operations.SystemDeviceManagementTest do
  use ExUnit.Case, async: true

  alias AirVantage.Operations.SystemDeviceManagement

  describe "wake_up" do
    test "responds with success by returning an operation number" do
      {:ok, response} = SystemDeviceManagement.wake_up(["0fda23be05fc4edaa8d92c4091dd7f93"])
      assert !is_nil(response["operation"])
    end
  end
end
