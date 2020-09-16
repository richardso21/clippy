import socket

client = socket.socket()

client.connect(('127.0.1.1', 8080))

print(client.recv(1024))

client.close()