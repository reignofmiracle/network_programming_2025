defmodule RedisClient do
  use GenServer

  @spec start_link(keyword()) :: GenServer.on_start()
  def start_link(options) do
    GenServer.start_link(__MODULE__, options)
  end

  defstruct [:host, :port, :socket, :caller_monitor]

  @impl true
  def init(options) do
    initial_state = %__MODULE__{
      host: Keyword.fetch!(options, :host),
      port: Keyword.fetch!(options, :port)
    }

    {:ok, initial_state, {:continue, :connect}}
  end
end
