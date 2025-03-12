use std::{
    io::{Read, Write},
    net::{TcpListener, TcpStream},
};

pub fn run() {
    let listener = TcpListener::bind("0.0.0.0:4000").unwrap();
    println!("server listening on port 4000");

    for stream in listener.incoming() {
        let stream = stream.unwrap();

        handle_connection(stream);
    }
}

fn handle_connection(mut stream: TcpStream) {
    let mut buffer = [0; 1024];

    let size = stream.read(&mut buffer[..]).unwrap();

    stream.write(&buffer[..size]).unwrap();
    stream.flush().unwrap();
}
