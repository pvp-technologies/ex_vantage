ExUnit.start()

Application.put_env(:ex_vantage, :api_base_url, "http://localhost:8081")
Application.put_env(:ex_vantage, :client_id, "test_client_id")
Application.put_env(:ex_vantage, :client_secret, "test_client_secret")
Application.put_env(:ex_vantage, :username, "tester")
Application.put_env(:ex_vantage, :password, "test_password")
