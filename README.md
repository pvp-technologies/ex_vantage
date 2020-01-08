<p align="center">
	<a href="https://doc.airvantage.net/av">
		<img alt="AirVantage Logo" width="400" src="https://user-images.githubusercontent.com/112219/71285004-1e2faf80-2332-11ea-816b-ba6b87319eab.png">
	</a>
</p>
<p align="center">
	<a href="https://circleci.com/gh/pvp-technologies/ex_vantage">
		<img alt="CircleCI status badge" src="https://circleci.com/gh/pvp-technologies/ex_vantage.svg?style=shield">
	</a>
	<a href='https://coveralls.io/github/pvp-technologies/ex_vantage?branch=master'>
		<img alt="Coveralls status badge" src="https://coveralls.io/repos/github/pvp-technologies/ex_vantage/badge.svg?branch=master" /></a>

</p>

# ExVantage

An Elixir library to work with [AirVantage API](https://doc.airvantage.net/av).

## Installation

By adding the version of this dependency to your `mix.exs`:

```ex
{:ex_vantage, "~> 0.0.1"}
```
Or using git:

```ex
{:ex_vantage, git: "https://github.com/pvp-technologies/ex_vantage"}
```
If your using `elixir < 1.4` you might need to add it to your application:

```ex
defp application do
  [applications: [:ex_vantage]]
end
```

## Configuration

To make API calls, it is necessary to configure your AirVantage account by adding few configurations:

```ex
config :ex_vantage, api_base_url: "https://eu.airvantage.net/api",
                    client_id: "12345678a567abc70de2551d18feed",
                    client_secret: "182n263b368f44a419149bf8db7f2a6aa",
                    username: "your.email@exvantage.com",
                    password: "yourSecureP@ssword!"
```

# Contributing

Feedback, feature requests, and fixes are welcomed and encouraged. Please make appropriate use of [Issues](https://github.com/pvp-technologies/ex_vantage/issues) and [Pull Requests](https://github.com/pvp-technologies/ex_vantage/pulls). All code should have accompanying tests.

# License

Please see [LICENSE](MIT-LICENSE) for licensing details.
