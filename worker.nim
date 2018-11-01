
import jsffi

proc postMessage(d: JsObject) {. importc: "postMessage" .}
proc newWebSocket(url, protocol: cstring): JsObject {.importcpp: "new WebSocket(@)".}

var console {.importcpp, noDecl.}: JsObject 

console.log("starting worker")

var ws = newWebSocket(cstring "ws://localhost:8080", cstring"myproto")
console.log("webSocket:", ws)

ws.onmessage = proc(event: JsObject) =
  console.log("Message from server: ", event.data)
  postMessage(event.data)

var onmessage {.exportc.} =  proc(d: JsObject)  =
  console.log("in worker: ", d)
  ws.send(cstring"message from client")
  var resp = newJsObject()
  resp["data"] = "from worker" 
  postMessage(resp)
