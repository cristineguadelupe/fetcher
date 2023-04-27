defmodule Fetcher.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, args) do
    children =
      case args do
        [env: :test] ->
          [{Plug.Cowboy, scheme: :http, plug: Fetcher.MockServer, options: [port: 8080]}]

        _ ->
          []
      end

    opts = [strategy: :one_for_one, name: Fetcher.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
