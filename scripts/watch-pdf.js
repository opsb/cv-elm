// watch-pdf.js — local background daemon that keeps `dist/` and the per-route
// PDFs in sync with the Elm source.
//
// On any change under `src/**/*.elm` it debounces, runs a full `npm run build`
// (Vite emits a single bundle for every route, so the whole `dist/` always
// rebuilds), then regenerates ONLY the PDFs whose routes the changed files can
// affect — see `classify()` for the file -> route map. Shared modules (Main,
// View/*, Util/*, LeadershipData, Cv/* for the portrait cuts) widen the set.
//
// Runs are serialized: edits landing mid-build are coalesced and replayed once
// the in-flight build finishes, so a burst of saves collapses into one rebuild.
//
// Start/stop it via the Justfile recipes (`just watch-pdf` / `just watch-pdf-stop`).

const { spawn } = require("child_process");
const fs = require("fs");
const path = require("path");

const projectRoot = path.resolve(__dirname, "..");
const srcDir = path.join(projectRoot, "src");
const distDir = path.join(projectRoot, "dist");
const stashDir = path.join(projectRoot, "private-notes", "daemon", ".pdf-stash");

// Every route that has a PDF (must stay in sync with generate-pdf.js).
const ALL_ROUTES = [
  "/",
  "/elixir",
  "/experimental",
  "/node",
  "/node?leader=true",
  "/cto",
  "/team-lead",
  "/em",
  "/node-staff",
  "/node-lead",
  "/elixir-staff",
  "/elixir-lead",
];

// The six portrait cuts that share Cv/PortraitView + Cv/Types.
const PORTRAIT_ROUTES = [
  "/team-lead",
  "/em",
  "/node-staff",
  "/node-lead",
  "/elixir-staff",
  "/elixir-lead",
];

// Maps a changed file (path relative to src/, posix separators) to the routes
// it can affect. First matching prefix wins; an unmatched file is treated as
// shared and regenerates everything (safe default).
function classify(relPath) {
  const rules = [
    { prefix: "Em/", routes: ["/team-lead", "/em"] },
    { prefix: "NodePortrait/", routes: ["/node-staff", "/node-lead"] },
    { prefix: "ElixirPortrait/", routes: ["/elixir-staff", "/elixir-lead"] },
    { prefix: "Node/", routes: ["/node", "/node?leader=true"] },
    { prefix: "Experimental2/", routes: ["/elixir"] },
    { prefix: "Experimental/", routes: ["/experimental"] },
    { prefix: "Cto/", routes: ["/cto", "/"] },
    { prefix: "Directory/", routes: [] }, // /directory has no PDF
    { prefix: "Cv/", routes: PORTRAIT_ROUTES }, // shared portrait view + types
  ];

  const match = rules.find((rule) => relPath.startsWith(rule.prefix));
  return match ? match.routes : ALL_ROUTES; // Main, View/, Util/, LeadershipData, Data/ ...
}

function affectedRoutes(changedRelPaths) {
  const routes = new Set();
  for (const rel of changedRelPaths) {
    for (const route of classify(rel)) {
      routes.add(route);
    }
    if (routes.size === ALL_ROUTES.length) break; // already everything
  }
  return [...routes];
}

// `vite build` empties dist/, so it deletes every previously-generated PDF.
// Affected-only regen only rewrites a couple of them, which would leave the
// rest missing. So we move the existing PDFs aside before the build and move
// them back after — survivors stay, then generate-pdf refreshes the affected
// ones. (CI is untouched: it always regenerates all PDFs after its build.)
function stashPdfs() {
  if (!fs.existsSync(distDir)) return [];
  fs.mkdirSync(stashDir, { recursive: true });
  const pdfs = fs.readdirSync(distDir).filter((f) => f.endsWith(".pdf"));
  for (const f of pdfs) {
    fs.renameSync(path.join(distDir, f), path.join(stashDir, f));
  }
  return pdfs;
}

function restorePdfs(files) {
  fs.mkdirSync(distDir, { recursive: true });
  for (const f of files) {
    const from = path.join(stashDir, f);
    if (fs.existsSync(from)) fs.renameSync(from, path.join(distDir, f));
  }
}

function run(command, args) {
  return new Promise((resolve, reject) => {
    const child = spawn(command, args, {
      cwd: projectRoot,
      stdio: "inherit",
    });
    child.on("error", reject);
    child.on("close", (code) =>
      code === 0
        ? resolve()
        : reject(new Error(`${command} ${args.join(" ")} exited ${code}`))
    );
  });
}

function stamp() {
  // Date.now() is fine in a normal Node process; only restricted inside the
  // workflow sandbox. Kept ISO-ish and short for log readability.
  return new Date().toISOString().replace("T", " ").slice(0, 19);
}

function log(message) {
  console.log(`[watch-pdf ${stamp()}] ${message}`);
}

let running = false;
const pending = new Set();

async function flush() {
  if (running) return; // a run is in flight; it will replay `pending` when done
  if (pending.size === 0) return;

  running = true;
  const changed = [...pending];
  pending.clear();

  const routes = affectedRoutes(changed);
  log(`changed: ${changed.join(", ")}`);

  const stashed = stashPdfs(); // preserve PDFs across the dist-emptying build
  let built = false;
  try {
    await run("npm", ["run", "build"]);
    built = true;
  } catch (err) {
    log(`build failed: ${err.message}`);
  }
  restorePdfs(stashed); // survivors return whether or not the build succeeded

  try {
    if (built) {
      if (routes.length === 0) {
        log("no PDF routes affected (build refreshed)");
      } else {
        log(`regenerating: ${routes.join(", ")}`);
        await run("node", ["scripts/generate-pdf.js", ...routes]);
        log("done");
      }
    }
  } catch (err) {
    log(`pdf regen failed: ${err.message}`);
  } finally {
    running = false;
    if (pending.size > 0) flush(); // replay edits that arrived mid-run
  }
}

let debounceTimer = null;
function schedule() {
  if (debounceTimer) clearTimeout(debounceTimer);
  debounceTimer = setTimeout(flush, 300);
}

async function start() {
  const skipInitial = process.env.WATCH_SKIP_INITIAL === "1";
  log(`watching ${path.relative(projectRoot, srcDir)}/ for *.elm changes`);

  if (!skipInitial) {
    log("initial full build + PDF regen (set WATCH_SKIP_INITIAL=1 to skip)");
    try {
      await run("npm", ["run", "build"]);
      await run("node", ["scripts/generate-pdf.js"]);
      log("initial regen done");
    } catch (err) {
      log(`initial regen failed: ${err.message}`);
    }
  }

  // fs.watch with recursive is supported on macOS (and Windows). Linux gained
  // recursive support in Node 20; this daemon is for local macOS dev.
  fs.watch(srcDir, { recursive: true }, (_eventType, filename) => {
    if (!filename) return;
    const rel = filename.split(path.sep).join("/");
    if (!rel.endsWith(".elm")) return;
    pending.add(rel);
    schedule();
  });
}

start();
