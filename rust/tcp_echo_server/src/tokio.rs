use tokio::{
    io::{AsyncReadExt, AsyncWriteExt},
    net::TcpListener,
};

pub fn run() {
    let rt = tokio::runtime::Runtime::new().unwrap();
    rt.block_on(async {
        async move {
            let addr = "0.0.0.0:4000";
            let listener = TcpListener::bind(&addr).await.unwrap();
            println!("Listening on: {addr}");
            loop {
                let (mut socket, _) = listener.accept().await.unwrap();

                tokio::spawn(async move {
                    let mut buf = vec![0; 1024];

                    loop {
                        let n = socket
                            .read(&mut buf)
                            .await
                            .expect("failed to read data from socket");

                        if n == 0 {
                            return;
                        }

                        socket
                            .write_all(&buf[0..n])
                            .await
                            .expect("failed to write data to socket");
                    }
                });
            }
        }
        .await;
    });
}
