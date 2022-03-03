defmodule Broadcast.Handler do
  use ThousandIsland.Handler

  def send_message(pid, from, msg) do
    GenServer.cast(pid, {:send, from, msg})
  end

  @impl ThousandIsland.Handler
  def handle_connection(socket, state) do
    Registry.register(Broadcast.Registry, "clients", socket)
    {:continue, state}
  end

  @impl ThousandIsland.Handler
  def handle_data(msg, socket, state) do
    send_message(self(), socket, msg)
    {:continue, [socket | state]}
  end

  @impl GenServer
  def handle_cast({:send, from, msg}, {socket, state}) do
    Registry.lookup(Broadcast.Registry, "clients")
    |> Enum.filter(fn {_pid, socket} ->
      socket != from
    end)
    |> Enum.each(fn {_pid, socket} ->
      ThousandIsland.Socket.send(socket, msg)
    end)

    {:noreply, {socket, state}}
  end
end
