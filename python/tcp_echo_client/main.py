import socket

host = "127.0.0.1"
port = 4000

client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client_socket.connect((host, port))

client_socket.send(b"Hello world\n")

print(client_socket.recv(1024))

client_socket.close()
