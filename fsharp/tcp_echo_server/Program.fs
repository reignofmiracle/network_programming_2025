open System
open System.Net.Sockets
open System.Net
open System.IO


let handle (client: TcpClient) =
    use stream = client.GetStream()
    use output = new StreamWriter(stream, AutoFlush = true)
    use input = new StreamReader(stream)

    while not input.EndOfStream do
        match input.ReadLine() with
        | line ->
            printfn "< %s" line
            output.WriteLine(line)

    printfn "closed %A" client.Client.RemoteEndPoint
    client.Close |> ignore

let run =
    let listener = new TcpListener(IPAddress.Loopback, 4000)
    do listener.Start()
    printfn "listening on %A" listener.Server.LocalEndPoint

    while true do
        let client = listener.AcceptTcpClient()
        printfn "connect from %A" client.Client.RemoteEndPoint

        let job =
            async {
                use c = client in

                try
                    handle client |> ignore
                with _ ->
                    ()
            }

        Async.Start job

[<EntryPoint>]
let main args =
    run
    0
