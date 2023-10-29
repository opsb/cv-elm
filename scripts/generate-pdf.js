const puppeteer = require("puppeteer");

var finalhandler = require("finalhandler");
var http = require("http");
var serveStatic = require("serve-static");

// Serve up public/ftp folder
var serve = serveStatic("build", { index: ["index.html", "index.htm"] });

// Create server
var server = http.createServer(function onRequest(req, res) {
  serve(req, res, finalhandler(req, res));
});

server.on("listening", function () {
  (async () => {
    const browser = await puppeteer.launch();
    const page = await browser.newPage();
    await page.goto("http://localhost:3001", { waitUntil: "networkidle2" });
    await page.pdf({ path: "public/opsb.pdf", format: "A4" });
    await browser.close();
    server.close();
  })();
});

console.log(serve);
// Listen
server.listen(3001);
