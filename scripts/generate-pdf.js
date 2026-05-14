// Generates one PDF per variant by serving the built `dist/` directory and
// driving headless Chromium via Puppeteer over each route. Each PDF is written
// back into `dist/` so it ships with the deployment artifact (GitHub Pages /
// Netlify) and the in-page "Download PDF" links resolve at the root path.
//
// `preferCSSPageSize: true` makes Puppeteer respect each variant's own
// `@page { size: A4 ... }` rule. The original landscape variants declare it in
// `main.css`; `/elixir-ats` declares portrait via an inline <style>.
//
// SPA fallback: the static server below mirrors what GitHub Pages does via
// `404.html` and what Netlify does via the redirects rule — any unknown path
// returns `index.html` so the Elm router can pick the variant up.

const puppeteer = require("puppeteer");
const finalhandler = require("finalhandler");
const http = require("http");
const path = require("path");
const fs = require("fs");
const serveStatic = require("serve-static");

const distDir = "dist";
const serve = serveStatic(distDir, { index: ["index.html", "index.htm"] });
const indexHtml = fs.readFileSync(path.join(distDir, "index.html"));

const server = http.createServer((req, res) => {
  serve(req, res, (err) => {
    if (err) {
      finalhandler(req, res)(err);
      return;
    }
    res.setHeader("Content-Type", "text/html; charset=utf-8");
    res.end(indexHtml);
  });
});

const variants = [
  { path: "/", file: "Oliver-Searle-Barnes-CTO-2026.pdf" },
  { path: "/engineer", file: "Oliver-Searle-Barnes-Engineer-2026.pdf" },
  { path: "/elixir", file: "Oliver-Searle-Barnes-Staff-Elixir-Engineer-2026.pdf" },
  { path: "/experimental", file: "Oliver-Searle-Barnes-Elixir-Editorial-2026.pdf" },
  { path: "/elixir-ats", file: "Oliver-Searle-Barnes-Senior-Elixir-Engineer-ATS-2026.pdf" },
];

server.on("listening", function () {
  (async () => {
    // --no-sandbox / --disable-setuid-sandbox are needed on GitHub Actions
    // Ubuntu runners where Chromium's SUID sandbox helper isn't available.
    // Safe here: the generator hits our own static site on a localhost
    // server, running on an ephemeral CI VM.
    const browser = await puppeteer.launch({
      args: ["--no-sandbox", "--disable-setuid-sandbox"],
    });
    try {
      for (const variant of variants) {
        const page = await browser.newPage();
        const url = "http://localhost:3001" + variant.path;
        const outputPath = path.join(distDir, variant.file);
        console.log("Rendering " + url + " -> " + outputPath);
        await page.goto(url, { waitUntil: "networkidle2" });
        await page.evaluate(() => document.fonts.ready);
        await page.pdf({
          path: outputPath,
          format: "A4",
          printBackground: true,
          preferCSSPageSize: true,
        });
        await page.close();
      }
    } finally {
      await browser.close();
      server.close();
    }
  })();
});

server.listen(3001);
