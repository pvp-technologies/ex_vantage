defmodule AirVantage.API do
  @moduledoc """
  Utilities for interacting with the AirVantage API.
  """

  alias AirVantage.Error

  @type body :: String.t()
  @type endpoint :: String.t()
  @type headers :: %{String.t() => String.t()} | %{}
  @type method :: :get | :post | :put | :delete
  @type params :: map
  @typep url :: String.t()
  @typep http_success :: {:ok, integer, [{String.t(), String.t()}], String.t()}
  @typep http_failure :: {:error, term}

  @doc """
  A low level function which performs any request to AirVantage API.
  This function could actually be used in order to make request to unsupported endpoints.
  """
  @spec request(params, method, endpoint, headers, list) ::
          {:ok, map} | {:error, Error.t()}
  def request(params, :get, endpoint, headers, opts) do
    base_url = get_api_base_url()

    req_url =
      params
      |> encode_query()
      |> prepend_url("#{base_url}#{endpoint}")

    perform_request(req_url, :get, "", headers, opts)
  end

  def request(params, method, endpoint, headers, opts) do
    base_url = get_api_base_url()
    req_url = "#{base_url}#{endpoint}"
    body = Jason.encode!(params)

    perform_request(req_url, method, body, headers, opts)
  end

  @spec perform_request(url, method, body, headers, list) ::
          {:ok, map} | {:error, Error.t()}
  defp perform_request(req_url, method, body, headers, opts) do
    req_headers =
      headers
      |> add_default_headers()
      |> add_oauth_token()
      |> Map.to_list()

    do_perform_request(method, req_url, req_headers, body, opts)
  end

  @spec add_basic_auth_token(headers) :: headers
  defp add_basic_auth_token(headers) do
    authorization_token = Base.encode64("#{get_api_client_id()}:#{get_api_client_secret()}")
    Map.put(headers, "Authorization", "Basic #{authorization_token}")
  end

  @spec add_default_headers(headers) :: headers
  defp add_default_headers(existing_headers) do
    existing_headers = add_common_headers(existing_headers)

    case Map.has_key?(existing_headers, "Content-Type") do
      false -> existing_headers |> Map.put("Content-Type", "application/x-www-form-urlencoded")
      true -> existing_headers
    end
  end

  @spec add_common_headers(headers) :: headers
  defp add_common_headers(headers) do
    Map.merge(headers, %{
      "Accept" => "application/json; charset=utf8",
      "Connection" => "keep-alive"
    })
  end

  @spec add_oauth_token(headers) :: headers
  defp add_oauth_token(headers) do
    {:ok, %{"access_token" => oauth_token, "token_type" => token_type}} = get_oauth_token()
    Map.put(headers, "Authorization", "#{token_type} #{oauth_token}")
  end

  @spec get_oauth_token() :: {:ok, map} | {:error, Error.t()}
  defp get_oauth_token() do
    base_url = get_api_base_url() <> "/oauth"
    req_url = base_url <> "/token"

    req_params = %{
      "grant_type" => "password",
      "username" => get_api_client_username(),
      "password" => get_api_client_password()
    }

    req_body = encode_query(req_params)

    req_headers =
      %{}
      |> add_default_headers()
      |> add_basic_auth_token()
      |> Map.to_list()

    do_perform_request(:post, req_url, req_headers, req_body)
  end

  @spec do_perform_request(method, url, [headers], body, list | nil) ::
          {:ok, map} | {:error, Error.t()}
  defp do_perform_request(method, url, headers, body, opts \\ []) do
    response = :hackney.request(method, url, headers, body, opts)
    handle_response(response)
  end

  @spec encode_query(params) :: String.t()
  defp encode_query(params) do
    params
    |> UriQuery.params()
    |> URI.encode_query()
  end

  @spec prepend_url(String.t(), url) :: url
  defp prepend_url("", url), do: url
  defp prepend_url(query, url), do: "#{url}?#{query}"

  @spec handle_response(http_success | http_failure) :: {:ok, map} | {:error, Error.t()}
  defp handle_response({:ok, status, _headers, body}) when status >= 200 and status <= 299 do
    with {:ok, encoded_body} <- :hackney.body(body),
         {:ok, decoded_body} <- Jason.decode(encoded_body) do
      {:ok, decoded_body}
    else
      {:error, error} -> Error.air_vantage_error(status, error)
      _ -> Error.air_vantage_error(status, nil)
    end
  end

  defp handle_response({:ok, status, _headers, body}) when status >= 300 and status <= 599 do
    {:ok, encoded_body} = :hackney.body(body)

    error =
      case Jason.decode(encoded_body) do
        {:ok, %{"error" => _} = api_error} ->
          Error.air_vantage_error(status, api_error)

        _ ->
          Error.air_vantage_error(status, nil)
      end

    {:error, error}
  end

  defp handle_response({:error, reason}) do
    error = Error.network_error(reason)
    {:error, error}
  end

  @spec get_api_base_url() :: String.t()
  defp get_api_base_url() do
    Application.get_env(:ex_vantage, :api_base_url, "https://na.airvantage.net/api")
  end

  @spec get_api_client_id() :: String.t()
  defp get_api_client_id() do
    Application.get_env(:ex_vantage, :client_id)
  end

  @spec get_api_client_secret() :: String.t()
  defp get_api_client_secret() do
    Application.get_env(:ex_vantage, :client_secret)
  end

  @spec get_api_client_username() :: String.t()
  defp get_api_client_username() do
    Application.get_env(:ex_vantage, :username)
  end

  @spec get_api_client_password() :: String.t()
  defp get_api_client_password() do
    Application.get_env(:ex_vantage, :password)
  end
end
