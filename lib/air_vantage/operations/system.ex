defmodule AirVantage.Operations.System do
  import AirVantage.Request

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
