defmodule AirVantage.APITest do
  use ExUnit.Case, async: true

  describe "Systems: find_system" do
    test "find system filtering by IMEI" do
      response =
        AirVantage.API.find_system("uid,name,gateway,subscription", "imei:359377060750279")

      assert !is_nil(response["items"])
      assert response["items"] != []

      Enum.each(response["items"], fn item ->
        assert item["gateway"]["imei"] == "359377060750279"
      end)
    end
  end

  describe "Device management: wake_up" do
    test "responds with success by returning the operation number" do
      response = AirVantage.API.wake_up(["ebec8233db9047388a2b00e82c7e8a1b"])
      assert !is_nil(response["operation"])
    end
  end
end
