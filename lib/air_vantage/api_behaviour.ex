defmodule AirVantage.APIBehaviour do
  @moduledoc false

  @callback request(map(), atom(), String.t(), map(), list()) :: tuple()
  @callback get_oauth_token() :: tuple()
end
