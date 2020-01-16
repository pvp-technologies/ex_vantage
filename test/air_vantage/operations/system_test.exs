defmodule AirVantage.Operations.SystemTest do
  use ExUnit.Case, async: true

  alias AirVantage.Operations.System

  import Mox

  setup :verify_on_exit!

  describe "find" do
    test "returns systems filtered by IMEI" do
      AirVantage.APIMock
      |> expect(:request, fn _params, _method, _endpoint, _headers, _opts ->
        {:ok,
         %{
           "items" => [
             %{
               "uid" => "1f4bd0e2b0f545269ec4c4bb9d7c328b",
               "gateway" => %{
                 "type" => "",
                 "serialNumber" => "LL911700871210",
                 "macAddress" => "DD:74:86:46:62:B6",
                 "uid" => "5f7149a3529041688a943007418e29dd",
                 "imei" => "359377060750279"
               },
               "subscription" => %{
                 "state" => "ACTIVE",
                 "identifier" => "89332401000012951329",
                 "uid" => "27b421ada9e14d6fb6df0eb80d877340",
                 "mobileNumber" => "+337000022546739",
                 "networkIdentifier" => "206018039508660",
                 "requestedIp" => nil,
                 "ipAddress" => "100.71.142.115",
                 "operator" => "SIERRA_WIRELESS",
                 "technology" => "4G",
                 "orderId" => "SO-E1593640",
                 "eid" => nil,
                 "mobileNumber2" => nil,
                 "productRefName" => "SmartSIM Advanced 3FF",
                 "confType" => "ADVANCED",
                 "appletGeneration" => "V4",
                 "formFactor" => "3FF"
               },
               "name" => "SIM 89332401000012951329"
             }
           ],
           "count" => 1,
           "size" => 1,
           "offset" => 0
         }}
      end)

      {:ok, response} = System.find("uid,name,gateway,subscription", "imei:359377060750279")

      assert !is_nil(response["items"])
      assert response["items"] != []

      Enum.each(response["items"], fn item ->
        assert item["gateway"]["imei"] == "359377060750279"
      end)
    end
  end
end
