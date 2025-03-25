defmodule Chat.AcceptorPool.Listener do
  use GenServer, restart: :transient

  alias Chat.AcceptorPool.AcceptorSupervisor

  require Logger

  @spec start_link(keyword()) :: GenServer.on_start()
  def start_link({options, supervisor}) do
    GenServer.start_link(__MODULE__, {options, supervisor})
  end

  @impl true
  def init({options, supervisor}) do
    port = Keyword.fetch!(options, :port)

    listen_options = [
      :binary,
      active: :once,
      exit_on_close: false,
      reuseaddr: true
    ]

    case :gen_tcp.listen(port, listen_options) do
      {:ok, listen_socket} ->
        Logger.info("Started pooled chart server on port #{port}")
        state = {listen_socket, supervisor}
        {:ok, state, {:continue, :start_acceptor_pool}}

      {:error, reason} ->
        {:stop, {:listen_error, reason}}
    end
  end
end
