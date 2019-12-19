defmodule AirVantage.API do
  alias AirVantage.Error
  alias OAuth2.{Client, Request, Response}

  @type method :: :get | :post | :put | :delete
  @type headers :: [{String.t(), String.t()}] | []
  @type body :: String.t()
  @typep http_success :: {:ok, Response.t()}
  @typep http_failure :: {:error, OAuth2.Error.t()}

  @doc """
  A low level utility function to make a direct request to the AirVantage API.
  """
  @spec request(method, String.t(), headers, body, list) ::
          {:ok, map} | {:error, Error.t()}
  def request(method, endpoint, headers, body, opts \\ []) do
    url = "#{get_base_url()}#{endpoint}"
    response = Request.request(method, client(), url, body, headers, opts)

    handle_response(response)
  end

  @spec client() :: Client.t()
  defp client do
    Client.get_token!(init_client())
  end

  @spec init_client() :: Client.t()
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

  @spec handle_response(http_success | http_failure) :: {:ok, map} | {:error, Error.t()}
  defp handle_response({:ok, %Response{status_code: status, body: body}})
       when status >= 200 and status <= 299 do
    {:ok, body}
  end

  defp handle_response({:ok, %Response{status_code: status, body: body}})
       when status >= 300 and status <= 599 do
    error =
      case body do
        %{"error" => _, "error_description" => _} ->
          Error.air_vantage_error(status, body)

        _ ->
          Error.air_vantage_error(status, nil)
      end

    {:error, error}
  end

  defp handle_response({:error, %OAuth2.Error{reason: reason}}) do
    error = Error.oauth_error(reason)
    {:error, error}
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
