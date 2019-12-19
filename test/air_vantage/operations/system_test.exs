defmodule AirVantage.Operations.SystemTest do
  use ExUnit.Case, async: true

  alias AirVantage.Operations.System

  describe "find" do
    test "returns systems filtering by IMEI" do
      {:ok, response} = System.find("uid,name,gateway,subscription", "imei:359377060750279")

      assert !is_nil(response["items"])
      assert response["items"] != []

      Enum.each(response["items"], fn item ->
        assert item["gateway"]["imei"] == "359377060750279"
      end)
    end
  end
end
