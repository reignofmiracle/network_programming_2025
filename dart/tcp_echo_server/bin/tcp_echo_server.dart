import 'dart:io';

void main(List<String> arguments) {
  Future<ServerSocket> serverFuture = ServerSocket.bind('0.0.0.0', 4000);
  serverFuture.then((ServerSocket server) {
    server.listen((Socket socket) {
      socket.listen((List<int> data) {
        String result = String.fromCharCodes(data);
        print(result);
        socket.write(result);
      });
    });
  });
}
