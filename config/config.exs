# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :big_canvas_live_view,
  ecto_repos: [BigCanvasLiveView.Repo]

# Configures the endpoint
config :big_canvas_live_view, BigCanvasLiveViewWeb.Endpoint,
  url: [host: "localhost"],
  live_view: [signing_salt: "kY54l7eXoaN9MwbuaXz6dyHxssPFvDDR"],
  secret_key_base: "B9PQGOglByguGeY35w00DpHAYx7io2l6SZg8VKmipSC1Ai6CTt4x5eX4BNuu4SYV",
  render_errors: [view: BigCanvasLiveViewWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: BigCanvasLiveView.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
