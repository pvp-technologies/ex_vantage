defmodule AirVantage.Error do
  @type error_source :: :network | :air_vantage

  @type error_status ::
          :bad_request
          | :unauthorized
          | :request_failed
          | :not_found
          | :conflict
          | :too_many_requests
          | :server_error
          | :unknown_error

  @type t :: %__MODULE__{
          source: error_source,
          code: error_status | :network_error,
          message: String.t()
        }

  @enforce_keys [:source, :code, :message]
  defstruct [:source, :code, :message]

  @doc false
  @spec new(Keyword.t()) :: t
  def new(fields) do
    struct!(__MODULE__, fields)
  end

  @doc false
  @spec oauth_error(String.t()) :: t
  def oauth_error(reason) do
    %__MODULE__{
      source: :network,
      code: :network_error,
      message:
        "An error occurred while making the network request. The HTTP client returned the following reason: #{
          inspect(reason)
        }"
    }
  end

  @doc false
  @spec air_vantage_error(400..599, nil | nil) :: t
  def air_vantage_error(status, nil) do
    %__MODULE__{
      source: :air_vantage,
      code: code_from_status(status),
      message: message_from_status(status)
    }
  end

  @spec air_vantage_error(400..599, map) :: t
  def air_vantage_error(status, error_data) do
    case Map.get(error_data, "errorParameters") do
      nil ->
        air_vantage_error(status, nil)

      error_details ->
        message = Map.get(error_data, "errorParameters")

        %__MODULE__{
          source: :air_vantage,
          code: error_details,
          message: message
        }
    end
  end

  defp code_from_status(400), do: :bad_request
  defp code_from_status(401), do: :unauthorized
  defp code_from_status(402), do: :request_failed
  defp code_from_status(404), do: :not_found
  defp code_from_status(409), do: :conflict
  defp code_from_status(429), do: :too_many_requests
  defp code_from_status(s) when s in [500, 502, 503, 504], do: :server_error
  defp code_from_status(_), do: :unknown_error

  defp message_from_status(400),
    do: "The request was unacceptable, often due to missing a required parameter."

  defp message_from_status(401), do: "No valid API key provided."
  defp message_from_status(402), do: "The parameters were valid but the request failed."
  defp message_from_status(404), do: "The requested resource doesn't exist."

  defp message_from_status(409),
    do:
      "The request conflicts with another request (perhaps due to using the same idempotent key)."

  defp message_from_status(429),
    do:
      "Too many requests hit the API too quickly. We recommend an exponential backoff of your requests."

  defp message_from_status(s) when s in [500, 502, 503, 504],
    do: "Something went wrong on AirVantage's end."

  defp message_from_status(s), do: "An unknown HTTP code of #{s} was received."
end
