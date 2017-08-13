# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :fexr, FexrWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ZfDWlMNcl7Bz2nY2wXM5vi9w2SOu4rmtBpNKgVJUqCJ46M9c4+SfP8kjIr1qZmW1",
  render_errors: [view: FexrWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Fexr.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
