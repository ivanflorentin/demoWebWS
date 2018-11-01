nim js -o:worker.js worker.nim 
nim js -o:index.js index.nim
#python3 -m http.server 5000 & 
nim c -r server.nim
