defmodule AirVantage.Operations.System do
  @moduledoc """
  The system is the core representation used in AirVantage to define and interact with a real system. A system is composed of:
  - a gateway: the physical module enabling the connectivity of the system
  - a subscription: a subscription is the configuration of the connectivity defined with the operator
  - one or several applications: an application defines a piece of logic executing on the system. It can be a firmware, a software, etc.
  """

  import AirVantage.Request

  @doc """
  Returns a paginated list of systems with their complete details.
  It is possible to filter out the result list using criteria parameters.
  Though system creation date is not publicly exposed, the default sort order is based on the creation date.
  """
  @spec find(String.t(), String.t()) :: {:ok, map} | {:error, Error.t()}
  def find(fields, gateway) do
    params = %{
      "fields" => fields,
      "gateway" => gateway
    }

    new_request()
    |> put_endpoint("/v1/systems")
    |> put_params(params)
    |> put_method(:get)
    |> make_request()
  end
end
