
## copied from https://github.com/niv/websocket.nim

import websocket, asynchttpserver, asyncnet, asyncdispatch

let server = newAsyncHttpServer()

proc cb(req: Request) {.async.} =
  let (ws, error) = await verifyWebsocketRequest(req, "myproto")
  if ws.isNil:
    echo "WS negotiation failed: ", error
    await req.respond(Http400, "Websocket negotiation failed: " & error)
    req.client.close()
    return

  echo "New websocket customer arrived!"
  while true:
    let (opcode, data) = await ws.readData()
    try:
      echo ".........................."
      echo "Received data from client:"
      echo $data
      echo "__________________________"
      case opcode
      of Opcode.Text:
        waitFor ws.sendText("Thanks for the data!")
      of Opcode.Binary:
        waitFor ws.sendBinary(data)
      of Opcode.Close:
        asyncCheck ws.close()
        let (closeCode, reason) = extractCloseData(data)
        echo "socket went away, close code: ", closeCode, ", reason: ", reason
      else: discard
    except:
      echo "encountered exception: ", getCurrentExceptionMsg()

echo "Starting server on port 8080"
waitFor server.serve(Port(8080), cb)
