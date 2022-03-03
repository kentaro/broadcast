defmodule Broadcast.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {ThousandIsland, port: 1234, handler_module: Broadcast.Handler},
      {Registry, keys: :duplicate, name: Broadcast.Registry}
    ]

    opts = [strategy: :one_for_one, name: Broadcast.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
