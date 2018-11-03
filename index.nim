
include karax / prelude
import jsffi

## a simple wrapper over web worker
## https://developer.mozilla.org/en-US/docs/Web/API/Worker
proc newWorker(f: cstring): JsObject {.importcpp: "new Worker(@)".}

var console {.importcpp, noDecl.}: JsObject

# first we crete a worker
var w: JsObject = newWorker(cstring"worker.js")

var message = cstring ""
w.onmessage = proc(d: JsObject) =
  ## This gets called when the worker sends a message
  #console.log("in main: ", d)
  console.log("UI -> Message from worker: ", d.data.to(cstring))
  message = d.data.to(cstring)
  #after we update the state, we re render the interface
  kxi.redraw()
  
w.onmessageerror = proc(d: JsObject) =
  # if something goes wrong, this will be called
  console.log("in error: ", d)
  
proc createDOM(data: RouterData): VNode =
  proc onClick() =
    #console.log("UI -> Clicked!: ")
    var data = newJsObject()
    data["message"] = cstring"Somebody pressed a button on the UI"
    w.postMessage(data)

  result = buildHtml(tdiv()):
    h3: text "web worker test"
    button(class="button", onclick=onClick): text "Press me"
    h2: text message
    
setRenderer createDOM
