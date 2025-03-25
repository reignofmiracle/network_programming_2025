defmodule Chat.AcceptorPool.Application do
  def start(_type, _args) do
    children = [
      {Registry, keys: :duplicate, name: Chat.BroadcastRegistry},
      {Registry, keys: :unique, name: Chat.UsernameRegistry},
      {Chat.AcceptorPool.ConnectionSupervisor, []},
      {Chat.AcceptorPool.TCPSupervisor, port: 4000}
    ]
  end
end
