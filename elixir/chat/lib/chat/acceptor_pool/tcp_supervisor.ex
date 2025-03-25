defmodule Chat.AcceptorPool.TCPSupervisor do
  use Supervisor

  @spec start_link(keyword()) :: Supervisor.on_start()
  def start_link(options) do
    Supervisor.start_link(__MODULE__, options)
  end

  @impl true
  def init(options) do
    children = [
      {Chat.AcceptorPool.Listener, {options, self()}}
    ]

    Supervisor.init(children, strategy: :rest_for_one)
  end
end
