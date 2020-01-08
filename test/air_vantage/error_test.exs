defmodule AirVantage.ErrorTest do
  use ExUnit.Case, async: true

  alias AirVantage.Error

  describe "air_vantage_error/2" do
    test "works with no error data" do
      error = Error.air_vantage_error(400, nil)
      assert error.code == :bad_request

      assert error.message ==
               "The request was unacceptable, often due to missing a required parameter."

      assert error.source == :air_vantage
    end

    test "works with an invalid token" do
      error_data = %{
        "error" => "invalid_token",
        "errorParameters" => "Invalid token"
      }

      error = Error.air_vantage_error(401, error_data)
      assert error.code == :unauthorized
      assert error.message == "Invalid token"
      assert error.source == :air_vantage
    end

    test "generates message if error payload does not have one" do
      error_data = %{
        "error" => "unknown_error",
        "errorParameters" => nil
      }

      error = Error.air_vantage_error(402, error_data)
      assert error.code == :request_failed
      assert error.message == "The parameters were valid but the request failed."
      assert error.source == :air_vantage
    end
  end

  describe "network_error/1" do
    test "returns a network error with the client provided erro reason" do
      reason = "Connectivity issue"
      error = Error.network_error(reason)
      assert error.code == :network_error

      assert error.message ==
               "An error occurred while making the network request. The HTTP client returned the following reason: #{
                 reason
               }"

      assert error.source == :network
    end
  end
end
