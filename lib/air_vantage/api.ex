defmodule AirVantage.API do
  def find_system(fields, gateway) do
    OAuth2.Client.get!(
      client(),
      "/v1/systems",
      [{"Content-Type", "application/json"}],
      params: %{
        "fields" => fields,
        "gateway" => gateway
      }
    ).body
  end

  def wake_up(uids) do
    OAuth2.Client.post!(
      client(),
      "/v1/operations/systems/wakeup",
      %{
        "action" => "READYAGENT_DM_CONNECT",
        "systems" => %{
          "uids" => uids
        }
      },
      [{"Content-Type", "application/json"}]
    ).body
  end

  defp client do
    OAuth2.Client.get_token!(init_client())
  end

  defp init_client do
    OAuth2.Client.new(
      strategy: OAuth2.Strategy.Password,
      client_id: get_client_id(),
      client_secret: get_client_secret(),
      site: get_api_base_url(),
      params: %{"username" => get_username(), "password" => get_password()},
      headers: [{"content-type", "application/x-www-form-urlencoded"}],
      serializers: %{"application/json" => Jason}
    )
  end

  @spec get_api_base_url() :: String.t()
  defp get_api_base_url() do
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
