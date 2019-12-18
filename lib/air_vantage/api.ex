defmodule AirVantage.API do
  alias OAuth2.{Client, Request, Response}

  @type method :: :get | :post | :put | :delete
  @type headers :: [{String.t(), String.t()}] | []
  @type body :: String.t()

  def find_system(fields, gateway) do
    params = %{
      "fields" => fields,
      "gateway" => gateway
    }

    AirVantage.Request.new_request()
    |> AirVantage.Request.put_endpoint("/v1/systems")
    |> AirVantage.Request.put_params(params)
    |> AirVantage.Request.put_method(:get)
    |> AirVantage.Request.make_request()
  end

  def wake_up(uids) do
    params = %{
      "action" => "READYAGENT_DM_CONNECT",
      "systems" => %{
        "uids" => uids
      }
    }

    AirVantage.Request.new_request()
    |> AirVantage.Request.put_endpoint("/v1/operations/systems/wakeup")
    |> AirVantage.Request.put_params(params)
    |> AirVantage.Request.put_method(:post)
    |> AirVantage.Request.make_request()
  end

  @doc """
  A low level utility function to make a direct request to the AirVantage API.
  """
  @spec request(method, String.t(), headers, body, list) :: {:ok, map}
  def request(method, endpoint, headers, body, opts \\ []) do
    url = "#{get_base_url()}#{endpoint}"

    case Request.request(method, client(), url, body, headers, opts) do
      {:ok, %Response{body: body}} -> body
      {:error, %Response{body: body}} -> "Something bad happen: #{inspect(body)}"
      {:error, %OAuth2.Error{reason: reason}} -> reason
    end
  end

  defp client do
    Client.get_token!(init_client())
  end

  defp init_client do
    Client.new(
      strategy: OAuth2.Strategy.Password,
      client_id: get_client_id(),
      client_secret: get_client_secret(),
      site: get_base_url(),
      params: %{"username" => get_username(), "password" => get_password()},
      headers: [{"content-type", "application/x-www-form-urlencoded"}],
      serializers: %{"application/json" => Jason}
    )
  end

  #
  @spec get_base_url() :: String.t()
  defp get_base_url() do
    Application.get_env(:ex_vantage, :api_base_url, "https://na.airvantage.net/api")
  end

  @spec get_client_id() :: String.t()
  defp get_client_id() do
    Application.get_env(:ex_vantage, :client_id)
  end

  @spec get_client_secret() :: String.t()
  defp get_client_secret() do
    Application.get_env(:ex_vantage, :client_secret)
  end

  @spec get_username() :: String.t()
  defp get_username() do
    Application.get_env(:ex_vantage, :username)
  end

  @spec get_password() :: String.t()
  defp get_password() do
    Application.get_env(:ex_vantage, :password)
  end
end
