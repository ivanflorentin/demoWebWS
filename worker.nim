
import jsffi

# a simple wrapper over the web socket implementation on the browser
# https://developer.mozilla.org/en-US/docs/Web/API/WebSockets_API
proc newWebSocket(url, protocol: cstring): JsObject {.importcpp: "new WebSocket(@)".}

## a simple wrapper over web worker
## https://developer.mozilla.org/en-US/docs/Web/API/Worker
proc postMessage(d: JsObject) {. importc: "postMessage" .}

var console {.importcpp, noDecl.}: JsObject 

var ws = newWebSocket(cstring "ws://localhost:8080", cstring"myproto")
#console.log("Worker: webSocket:", ws)
console.log("Worker -> starting...")

ws.onmessage = proc(event: JsObject) =
  ## This gets called when a message arrives from the server
  console.log("Worker -> Message from server: ", event.data)
  ## We post this message to the UI
  postMessage(event.data)

var onmessage {.exportc.} =  proc(d: JsObject)  =
  ## This gets called when the UI thread sends a message
  console.log("Worker -> received a message from UI: ", d["data"]["message"])
  ## We just send it to the server
  ws.send(d["data"]["message"])
