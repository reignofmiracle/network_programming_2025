package main

import (
	"bufio"
	"fmt"
	"log"
	"net"
)

type Client struct {
	conn net.Conn
}

func (client *Client) handleRequest() {
	reader := bufio.NewReader(client.conn)
	for {
		message, _, err := reader.ReadLine()
		if err != nil {
			client.conn.Close()
			return
		}

		fmt.Printf("Message: %s\n", string(message))

		client.conn.Write(message)
	}
}

func main() {
	listener, err := net.Listen("tcp", fmt.Sprintf("%s:%s", "0.0.0.0", "4000"))
	if err != nil {
		log.Fatal(err)
	}
	defer listener.Close()

	for {
		conn, err := listener.Accept()
		if err != nil {
			log.Fatal(err)
		}

		client := &Client{conn: conn}

		go client.handleRequest()
	}
}
