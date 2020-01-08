defmodule AirVantage.MockServer do
  @moduledoc false

  use Plug.Router

  plug(Plug.Parsers, pass: ["application/*"], parsers: [:json], json_decoder: Jason)
  plug(:match)
  plug(:dispatch)

  post "/oauth/token" do
    success(conn, %{
      "access_token" =>
        "SuZKFt3oMd8w1M_FyhSoWz0TEpT-Xmb7Nnc3j8GdEWqvAZopbkGVDz2ZPJpoCs_Wtj2KWVfVFq96hAk3wYuH7Q",
      "expires_in" => 64_080,
      "token_type" => "Bearer",
      "refresh_token" =>
        "8Wn4Pupf-xTiXSuYAYCBXhUduS3_oV21_bisZs39wbaSCdYsUdSvBM1ElmjBWpIyPkuDNyvBVTkHu_sBS9UNiQ"
    })
  end

  get "/v1/systems" do
    success(conn, %{
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
    })
  end

  post "v1/operations/systems/wakeup" do
    success(conn, %{
      "operation" => "4b89657f63aac4562dc1d46e98a495326"
    })
  end

  post "/v1/operations/systems/sms" do
    success(conn, %{
      "operation" => "4b89657f63aac4b299c1d46e98a495326"
    })
  end

  defp success(conn, body) do
    Plug.Conn.send_resp(conn, 200, Jason.encode!(body))
  end
end
