using System.Net;
using System.Net.Sockets;
using System.Text;

var ipEndPoint = new IPEndPoint(IPAddress.Any, 4000);

Socket listener = new(ipEndPoint.AddressFamily, SocketType.Stream, ProtocolType.Tcp);
listener.Bind(ipEndPoint);
listener.Listen(100);

var handler = await listener.AcceptAsync();

var buf = new byte[1024];
var received = await handler.ReceiveAsync(buf, SocketFlags.None);
var message = Encoding.UTF8.GetString(buf, 0, received);

Console.WriteLine(message);

await handler.SendAsync(buf[..received], 0);
