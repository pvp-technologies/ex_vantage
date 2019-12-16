defmodule AirVantage.APITest do
  use ExUnit.Case, async: true

  describe "find_system" do
    test "filtering by IMEI" do
      response =
        AirVantage.API.find_system("uid,name,gateway,subscription", "imei:359377060750279")

      assert !is_nil(response["items"])
      assert response["items"] != []

      Enum.each(response["items"], fn item ->
        assert item["gateway"]["imei"] == "359377060750279"
      end)
    end
  end
end
