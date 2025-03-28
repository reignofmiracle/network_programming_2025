defmodule TCPEchoServer.IntegrationTest do
  use ExUnit.Case, async: true

  test "sends back the received data" do
    {:ok, socket} =
      :gen_tcp.connect(~c"localhost", 4000, [:binary, active: false])

    assert :ok = :gen_tcp.send(socket, "Hello world\n")
    assert {:ok, data} = :gen_tcp.recv(socket, 0, 500)
    assert data == "Hello world\n"
  end
end
