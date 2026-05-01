const puppeteer = require("puppeteer");

var finalhandler = require("finalhandler");
var http = require("http");
var path = require("path");
var fs = require("fs");
var serveStatic = require("serve-static");

var distDir = "dist";
var serve = serveStatic(distDir, { index: ["index.html", "index.htm"] });
var indexHtml = fs.readFileSync(path.join(distDir, "index.html"));

// SPA fallback: any path that serve-static can't resolve returns index.html
// so the Elm app can read the URL on first load.
var server = http.createServer(function onRequest(req, res) {
  serve(req, res, function fallback(err) {
    if (err) {
      finalhandler(req, res)(err);
      return;
    }
    res.setHeader("Content-Type", "text/html; charset=utf-8");
    res.end(indexHtml);
  });
});

var variants = [
  { path: "/", file: "public/opsb.pdf" },
  { path: "/engineer", file: "public/opsb-engineer.pdf" },
];

server.on("listening", function () {
  (async () => {
    const browser = await puppeteer.launch();
    try {
      for (const variant of variants) {
        const page = await browser.newPage();
        const url = "http://localhost:3001" + variant.path;
        console.log("Rendering " + url + " -> " + variant.file);
        await page.goto(url, { waitUntil: "networkidle2" });
        await page.pdf({ path: variant.file, format: "A4" });
        await page.close();
      }
    } finally {
      await browser.close();
      server.close();
    }
  })();
});

server.listen(3001);
