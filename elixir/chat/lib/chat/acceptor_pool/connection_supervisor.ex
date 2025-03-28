defmodule Chat.AcceptorPool.ConnectionSupervisor do
  use DynamicSupervisor

  @spec start_link(keyword()) :: Supervisor.on_start()
  def start_link(options) do
    DynamicSupervisor.start_link(__MODULE__, options, name: __MODULE__)
  end

  @spec start_connection(:gen_tcp.socket()) :: Supervisor.on_start()
  def start_connection(socket) do
    DynamicSupervisor.start_child(__MODULE__, {Chat.Connection, socket})
  end

  @impl true
  def init(_options) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
