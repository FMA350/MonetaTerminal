import socket

class ServerWrapper:
    port = 1337

    def __init__(self):
        connections = []
        server_port = -1

    def _start_server(self, port):
        print("Starting TCP server on port " + str(port))
        self.server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        try:
            self.server.bind(("localhost", port))
        except socket.error as e:
            print("Bind failed:", e)
            return self._start_server(port+1)
        if self.server.getsockname():
            print("Bind worked!")
        else:
            print("Bind failed...")
            exit(1)
        self.server.listen(10)
        self.server_port = port


    def run_server(self):
        self._start_server(ServerWrapper.port)
        while True:
            connection, address = self.server.accept()
            print("Connection from", address)
            self.connections.append(connection)
            connection.send("Connected to the price simulator".encode())
            connection.close()
    
