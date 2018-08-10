defmodule Blaces.Mixfile do
  use Mix.Project

  def project do
    [app: :blaces,
     version: "0.0.1",
     elixir: "~> 1.2",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps(),
     test_coverage: [tool: ExCoveralls],
     preferred_cli_env: ["coveralls": :test,
                         "coveralls.detail": :test,
                         "coveralls.post": :test,
                         "coveralls.html": :test]]
  end

  def application do
    [mod: {Blaces, []},
     applications: [:phoenix, :phoenix_pubsub, :phoenix_html,
                    :cowboy, :logger, :gettext, :phoenix_ecto,
                    :postgrex, :yelp_ex, :comeonin, :ex_machina]]
  end

  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  defp deps do
    [{:phoenix, "~> 1.2.1"},
     {:phoenix_pubsub, "~> 1.0"},
     {:phoenix_ecto, "~> 3.0"},
     {:postgrex, "~> 0.13.5"},
     {:phoenix_html, "~> 2.6"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:gettext, "~> 0.11"},
     {:cowboy, "~> 1.0"},

     # Other deps
     {:yelp_ex, "~> 0.2.0"},
     {:poison, ">= 0.0.0", override: true},  # Workaround for YelpEx/Phoenix dep conflict
     {:comeonin, "~> 3.0"},
     {:guardian, "~> 0.14"},
     {:excoveralls, "~> 0.6", only: :test},
     {:ex_machina, "~> 2.0"}]
  end

  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
