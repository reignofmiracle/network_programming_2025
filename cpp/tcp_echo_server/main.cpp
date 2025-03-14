#include <WS2tcpip.h>
#include <windows.h>
#include <winsock2.h>
#include <format>
#include <iostream>

#pragma comment(lib, "Ws2_32.lib")

int main() {
    WSADATA wsa_data;
    if (WSAStartup(MAKEWORD(2, 2), &wsa_data) != 0) {
        return 1;
    }

    struct addrinfo* result = nullptr;
    struct addrinfo hints;

    ZeroMemory(&hints, sizeof(hints));
    hints.ai_family = AF_INET;
    hints.ai_socktype = SOCK_STREAM;
    hints.ai_protocol = IPPROTO_TCP;
    hints.ai_flags = AI_PASSIVE;

    if (getaddrinfo(nullptr, "4000", &hints, &result)) {
        std::clog << "error getaddrinfo" << std::endl;
        WSACleanup();
        return 1;
    }

    auto listener = socket(hints.ai_family, hints.ai_socktype, hints.ai_protocol);
    if (listener == INVALID_SOCKET) {
        std::clog << "error socket" << std::endl;
        freeaddrinfo(result);
        WSACleanup();
        return 1;
    }

    if (bind(listener, result->ai_addr, (int)result->ai_addrlen) == SOCKET_ERROR) {
        std::clog << "error bind" << std::endl;
        freeaddrinfo(result);
        closesocket(listener);
        WSACleanup();
        return 1;
    }

    freeaddrinfo(result);

    if (listen(listener, SOMAXCONN) == SOCKET_ERROR) {
        std::clog << "error listen" << std::endl;
        closesocket(listener);
        WSACleanup();
        return 1;
    }

    auto client_socket = accept(listener, nullptr, nullptr);
    if (client_socket == INVALID_SOCKET) {
        std::clog << "error accept" << std::endl;
        closesocket(listener);
        WSACleanup();
        return 1;
    }

    closesocket(listener);

    char buf[1024];

    int received_size = 0;
    do {
        auto received_size = recv(client_socket, buf, 1024, 0);
        if (received_size > 0) {
            std::clog << buf << std::endl;

            if (send(client_socket, buf, received_size, 0) == SOCKET_ERROR) {
                std::clog << "error send: " << WSAGetLastError() << std::endl;
                closesocket(client_socket);
                WSACleanup();
                return 1;
            }
        } else if (received_size == 0) {
            std::clog << "connection closing" << std::endl;
        } else {
            std::clog << "error recv: " << WSAGetLastError() << std::endl;
            closesocket(client_socket);
            WSACleanup();
            return 1;
        }
    } while (received_size > 0);

    if (shutdown(client_socket, SD_SEND) == SOCKET_ERROR) {
        std::clog << "error shutdown" << std::endl;
        closesocket(client_socket);
        WSACleanup();
        return 1;
    }

    closesocket(client_socket);
    WSACleanup();

    return 0;
}