
This is a simple test for webWorkers and WebSockets

It needs karax to render the front end an websocket.nim to compile the server

start a web server to serve the static content:

$ python3 -m http.server 5000
and then 

$ sh ./run.sh

It will compile the client front end with karax,
the client back end wrapping webSockets
and the server, listening for sockets on port 8080

