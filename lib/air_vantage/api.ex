defmodule AirVantage.API do
  alias AirVantage.Error

  @type method :: :get | :post | :put | :delete
  @type headers :: %{String.t() => String.t()} | %{}
  @type body :: String.t()
  @typep http_success :: {:ok, integer, [{String.t(), String.t()}], String.t()}
  @typep http_failure :: {:error, term}

  @spec request(body, method, String.t(), headers, list) ::
          {:ok, map} | {:error, Error.t()}
  def request(body, :get, endpoint, headers, opts) do
    base_url = get_base_url()

    req_url =
      body
      |> encode_query()
      |> prepend_url("#{base_url}#{endpoint}")

    perform_request(req_url, :get, "", headers, opts)
  end

  def request(body, method, endpoint, headers, opts) do
    base_url = get_base_url()
    req_url = "#{base_url}#{endpoint}"
    req_body = encode_query(body)

    perform_request(req_url, method, req_body, headers, opts)
  end

  @spec perform_request(String.t(), method, body, headers, list) ::
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
    authorization_token = Base.encode64("#{get_client_id()}:#{get_client_secret()}")
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
    base_url = get_base_url() <> "/oauth"
    req_url = base_url <> "/token"

    req_body =
      %{
        "grant_type" => "password",
        "username" => get_username(),
        "password" => get_password()
      }
      |> encode_query()

    req_headers =
      %{}
      |> add_default_headers()
      |> add_basic_auth_token()
      |> Map.to_list()

    do_perform_request(:post, req_url, req_headers, req_body)
  end

  @spec do_perform_request(method, String.t(), [headers], body, list | nil) ::
          {:ok, map} | {:error, Error.t()}
  defp do_perform_request(method, url, headers, body, opts \\ []) do
    response = :hackney.request(method, url, headers, body, opts)
    handle_response(response)
  end

  @doc """
  Takes a map and turns it into proper query values.
  """
  @spec encode_query(map) :: String.t()
  def encode_query(map) do
    map |> UriQuery.params() |> URI.encode_query()
  end

  @spec prepend_url(String.t(), String.t()) :: String.t()
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
