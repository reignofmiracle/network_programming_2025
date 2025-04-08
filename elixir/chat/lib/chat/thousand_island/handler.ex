defmodule Chat.ThousandIsland.Handler do
  use ThousandIsland.Handler

  defstruct [:username, buffer: <<>>]

  @impl ThousandIsland.Handler
  def handle_connection(_socket, [] = _options) do
    {:continue, %__MODULE__{}}
  end

  @impl ThousandIsland.Handler
  def handle_data(data, _socket, state) do
    state = update_in(state.buffer, &(&1 <> data))
    handle_new_data(state)
  end
end
