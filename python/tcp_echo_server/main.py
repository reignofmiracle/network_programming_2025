import socket


listener = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
listener.bind(("0.0.0.0", 4000))
listener.listen(5)

while True:
    client_socket, client_address = listener.accept()
    print(f"{client_address}")

    try:
        data = client_socket.recv(1024).decode("utf-8")
        if not data:
            continue

        print(f"{data} received")

        client_socket.send(data.encode("utf-8"))

    finally:
        client_socket.close()