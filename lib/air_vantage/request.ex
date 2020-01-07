defmodule AirVantage.Request do
  @moduledoc """
  A module to build and execute requests to AirVantage API.
  The request does not happen until its passed to `make_request/1`.
  At a minimum, a request must have the endpoint and method specified to be valid.
  """

  alias AirVantage.{API, Error, Request}

  @type t :: %__MODULE__{
          endpoint: String.t() | nil,
          headers: map,
          method: API.method() | nil,
          opts: Keyword.t() | nil,
          params: map
        }

  defstruct endpoint: nil,
            headers: nil,
            method: nil,
            opts: [],
            params: %{}

  @doc """
  Creates a new request.
  """
  @spec new_request(list) :: t
  def new_request(headers \\ %{"Content-Type" => "application/json"}) do
    %Request{headers: headers}
  end

  @doc """
  Specifies an endpoint for the request.
  The endpoint should not include the `v1` prefix or an initial slash.
  """
  @spec put_endpoint(t, String.t()) :: t
  def put_endpoint(%Request{} = request, endpoint) do
    %{request | endpoint: endpoint}
  end

  @doc """
  Specifies a method to use for the request.
  Accepts any of the standard HTTP methods as atoms, that is `:get`, `:post`,
  `:put` or `:delete`.
  """
  @spec put_method(t, API.method()) :: t
  def put_method(%Request{} = request, method)
      when method in [:get, :post, :put, :delete] do
    %{request | method: method}
  end

  @doc """
  Specifies the parameters to be used for the request.
  If the request is a POST request, these are encoded in the request body.
  Otherwise, they are encoded in the URL.
  Calling this function multiple times will merge, not replace, the params
  currently specified.
  """
  @spec put_params(t, map) :: t
  def put_params(%Request{params: params} = request, new_params) do
    %{request | params: Map.merge(params, new_params)}
  end

  @doc """
  Specify a single param to be included in the request.
  """
  @spec put_param(t, atom, any) :: t
  def put_param(%Request{params: params} = request, key, value) do
    %{request | params: Map.put(params, key, value)}
  end

  @doc """
  Executes the request and returns the response.
  """
  @spec make_request(t) :: {:ok, map} | {:error, Error.t()}
  def make_request(%Request{
        params: params,
        endpoint: endpoint,
        method: method,
        headers: headers,
        opts: opts
      }) do
    API.request(params, method, endpoint, headers, opts)
  end
end
