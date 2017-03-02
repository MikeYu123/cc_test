# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :test_task_contacts, TestTaskContacts.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "gIAIyYTMKht/BmWI9EkDsUWo7fTGwJ0zidl0LpL7PMsJu+dQlDxjgUwx3I8jtt23",
  render_errors: [view: TestTaskContacts.ErrorView, accepts: ~w(html json)],
  pubsub: [name: TestTaskContacts.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :bolt_sips, Bolt,
  hostname: 'localhost',
  basic_auth: [username: "neo4j", password: "mikeyu123"],
  port: 7687,
  pool_size: 5,
  max_overflow: 1

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
