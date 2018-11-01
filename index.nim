
include karax / prelude
import jsffi

proc newWorker(f: cstring): JsObject {.importcpp: "new Worker(@)".}

var console {.importcpp, noDecl.}: JsObject

var w: JsObject = newWorker(cstring"worker.js")

var message = cstring ""
w.onmessage = proc(d: JsObject) =
  console.log("in main: ", d)
  console.log("index -- message from server: ", d.data.to(cstring))
  message = d.data.to(cstring)
  kxi.redraw()
  
w.onmessageerror = proc(d: JsObject) =
  console.log("in error: ", d)
  
proc createDOM(data: RouterData): VNode =
  proc onClick() =
    console.log("clicked: ", w)
    var data = newJsObject()
    data["message"] = "from main"
    w.postMessage(data)

  result = buildHtml(tdiv()):
    h3: text "web worker test"
    button(class="button", onclick=onClick): text "Press me"
    h2: text message
    
setRenderer createDOM
