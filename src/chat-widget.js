/**
 * Career-chat widget for the CV site.
 *
 * Two presentations, one engine:
 *   - On the root path "/", it mounts a FULL-SCREEN chat (the home page is the
 *     conversation): full-width scroll area, centered message column, composer
 *     pinned to the bottom, ChatGPT / Claude.ai style.
 *   - On any CV route, it mounts a floating launcher + panel.
 *
 * Jumping-in points (companies, stack, projects, personas) live in a "/" command
 * menu in the composer, hinted below the input. Summarise, then drill down.
 *
 * Lives in a Shadow DOM host appended to <html> (not <body>), so it stays
 * isolated from the Elm app and its CSS can't leak in or out. POSTs the running
 * message history to the cv-agent Worker and renders the streamed SSE reply.
 */

// Same-origin path so the call is HTTPS + same-origin behind Caddy (cv.dev) and
// proxied by vite in dev. Prod builds set VITE_AGENT_URL to the deployed Worker.
const AGENT_URL = import.meta.env.VITE_AGENT_URL || "/agent/chat";

const GREETING =
  "Hi, I'm Oliver's career assistant. What brings you here today, hiring, scoping a contract, or just looking? Tell me what you need, or press / to browse topics.";

// Every company, reverse-chronological.
const COMPANIES = [
  "XP Flow (Alfie)", "Tree3", "Tastermonial", "Boulevard", "Vorwerk",
  "CompareTheMarket", "TwentyBN", "LIQID", "Zapnito", "Lytbulb",
  "Myschooldirect", "Informa", "Nutshell Development",
];

// Stack, grouped into the popover's tech sections.
const FRONTEND = ["TypeScript", "React", "Next.js", "Elm"];
const BACKEND = ["Elixir", "Phoenix", "OTP", "Node.js", "NestJS", "Python", "Ruby on Rails", "GraphQL"];
const DATA = ["PostgreSQL", "Redis", "Ecto", "Drizzle"];
const PLATFORM = ["AWS", "Terraform", "Vercel", "SQS / Broadway", "RabbitMQ", "Inngest"];

const techItems = (arr) => arr.map((t) => ({ label: t, query: `What is Oliver's experience with ${t}?` }));

// Flagship projects (proof points).
const PROJECTS = [
  { label: "Alfie (agentic AI, XP Flow)", query: "Tell me about Alfie, the agentic AI product Oliver built at XP Flow." },
  { label: "Bean (Open Banking, CompareTheMarket)", query: "Tell me about the Bean Open Banking platform Oliver rebuilt at CompareTheMarket." },
  { label: "Boulevard API platform", query: "Tell me about the API platform work Oliver did at Boulevard." },
  { label: "Zapnito (realtime community SaaS)", query: "Tell me about the realtime community platform Oliver built at Zapnito." },
  { label: "Vorwerk (IoT cloud)", query: "Tell me about the IoT cloud services Oliver built at Vorwerk." },
  { label: "His hardest engineering problem", query: "What was Oliver's hardest engineering problem and how did he solve it?" },
];

// Discovery / persona openers, mapped to the live hiring demand.
const PERSONAS = [
  "I'm hiring a founding engineer",
  "We need a fractional CTO or Head of Eng",
  "Senior Elixir / Phoenix at scale",
  "Building something AI or agentic",
  "What's he looking for?",
];

// AI tools, frameworks and ways of working.
const AI = [
  { label: "Agentic systems", query: "Tell me about Oliver's experience building agentic AI systems." },
  { label: "LangChain", query: "What is Oliver's experience with LangChain?" },
  { label: "LangGraph", query: "What is Oliver's experience with LangGraph?" },
  { label: "LangSmith", query: "What is Oliver's experience with LangSmith?" },
  { label: "OpenAI", query: "What is Oliver's experience with OpenAI's models?" },
  { label: "Claude Code", query: "How does Oliver use Claude Code?" },
  { label: "Cursor", query: "How does Oliver use Cursor?" },
];

// The "/" command menu, grouped.
const TOPIC_GROUPS = [
  { group: "Ask about", items: PERSONAS.map((p) => ({ label: p, query: p })) },
  { group: "Projects", items: PROJECTS },
  { group: "AI", items: AI },
  { group: "Frontend", items: techItems(FRONTEND) },
  { group: "Backend", items: techItems(BACKEND) },
  { group: "Data", items: techItems(DATA) },
  { group: "Platform", items: techItems(PLATFORM) },
  { group: "Companies", items: COMPANIES.map((c) => ({ label: c, query: `Tell me about Oliver's work at ${c}.` })) },
];

// In-browser persistence of MULTIPLE conversations (localStorage; tiny text).
const STORE_KEY = "cv-agent-chats:v1";
const STORE_MAX_MESSAGES = 40; // per chat
const STORE_MAX_CHATS = 60;

function loadChats() {
  try {
    const s = JSON.parse(localStorage.getItem(STORE_KEY) || "null");
    if (s && Array.isArray(s.chats)) return s;
  } catch {
    /* corrupt / disabled */
  }
  return { chats: [], currentId: null };
}
function saveChats(state) {
  try {
    localStorage.setItem(
      STORE_KEY,
      JSON.stringify({ chats: state.chats.slice(0, STORE_MAX_CHATS), currentId: state.currentId }),
    );
  } catch {
    /* quota exceeded or storage disabled — degrade silently */
  }
}

// A pasted job description, fetched server-side once and remembered GLOBALLY so
// it stays in context for every chat and thread until the visitor clears it.
const JOB_KEY = "cv-agent-active-job:v1";
const jobListeners = new Set();
function loadActiveJob() {
  try {
    return JSON.parse(localStorage.getItem(JOB_KEY) || "null");
  } catch {
    return null;
  }
}
function setActiveJob(job) {
  try {
    job ? localStorage.setItem(JOB_KEY, JSON.stringify(job)) : localStorage.removeItem(JOB_KEY);
  } catch {
    /* ignore */
  }
  jobListeners.forEach((fn) => fn(job));
}
function onActiveJobChange(fn) {
  jobListeners.add(fn);
  return () => jobListeners.delete(fn);
}
/** A short label for the job pill, from the JD's first line (often the title). */
function jobLabel(job) {
  const first = (job?.text || "").split("\n").find((l) => l.trim());
  const t = (first || "Active job").replace(/\s+/g, " ").trim();
  return t.length > 34 ? t.slice(0, 34) + "…" : t;
}

// --- light, minimal palette ---
const STYLES = `
  :host { all: initial; }
  * { box-sizing: border-box; font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif; }

  :host {
    --bg: #ffffff;
    --text: #1d1d1f;
    --muted: #71717a;
    --user-bg: #f4f4f5;
    --border: #e7e7ea;
    --accent: #1d1d1f;
  }

  /* ---------- messages (shared) ---------- */
  .messages { display: flex; flex-direction: column; gap: 18px; }
  .msg { font-size: 15.5px; line-height: 1.72; color: var(--text); }
  .msg.user {
    align-self: flex-end; max-width: 85%;
    background: var(--user-bg); padding: 10px 15px; border-radius: 18px;
    white-space: pre-wrap; word-wrap: break-word;
  }
  .msg.assistant { align-self: stretch; max-width: 100%; }
  .msg.error {
    align-self: center; color: #b42318; background: #fef3f2;
    border: 1px solid #fecdca; padding: 8px 12px; border-radius: 10px; font-size: 13.5px;
  }
  .caret {
    display: inline-block; width: 7px; height: 1em; margin-left: 2px;
    background: var(--text); opacity: .5; vertical-align: text-bottom;
    animation: blink 1.05s steps(2, start) infinite;
  }
  @keyframes blink { 50% { opacity: 0; } }

  .msg p { margin: 0 0 10px; }
  .msg p:last-child { margin-bottom: 0; }
  .msg .md-h { font-size: 17.5px; font-weight: 700; line-height: 1.3; margin: 22px 0 8px; color: var(--text); }
  .msg .md-h:first-child { margin-top: 0; }
  .msg .md-h.entity { display: inline-flex; align-items: center; gap: 7px; cursor: pointer; border-bottom: none; border-radius: 7px; padding: 2px 7px; margin-left: -7px; }
  .msg .md-h.entity:hover { background: #eef1ff; color: #2b3380; }
  .msg .md-h.entity .logo { width: 20px; height: 20px; margin-right: 0; border-radius: 4px; }
  .msg ul, .msg ol { margin: 6px 0 10px; padding-left: 22px; }
  .msg li { margin: 3px 0; }
  .msg strong { font-weight: 600; }
  .msg .entity { cursor: pointer; border-bottom: 1px dotted #c0c0c6; transition: background .12s ease, border-color .12s ease; border-radius: 2px; }
  .msg .entity:hover { background: #eef1ff; border-bottom-color: #6b78d6; color: #2b3380; }
  .msg .entity:focus-visible { outline: 2px solid #6b78d6; outline-offset: 1px; }
  .msg .entity .logo { width: 15px; height: 15px; margin-right: 5px; border-radius: 3px; object-fit: contain; vertical-align: -2px; background: #fff; }
  .more-btn { display: inline-grid; place-items: center; vertical-align: -3px; width: 18px; height: 18px; margin-left: 1px; padding: 0; border: none; border-radius: 50%; background: none; color: var(--muted); cursor: pointer; transition: color .12s ease, background .12s ease; }
  .more-btn:hover { color: #fff; background: var(--accent); }
  .section-more { display: inline-block; margin-top: 2px; border: none; background: none; padding: 0; font: inherit; font-size: 13px; color: #6b78d6; cursor: pointer; }
  .section-more:hover { color: #2b3380; text-decoration: underline; }
  .msg code { font-family: ui-monospace, Menlo, monospace; font-size: .9em; background: #f4f4f5; padding: 1px 5px; border-radius: 5px; }
  .msg.user code { background: rgba(0,0,0,.06); }
  .msg a { color: #2563eb; text-decoration: underline; }

  /* ---------- composer (shared) ---------- */
  .composer { position: relative; }
  .form {
    display: flex; align-items: center; gap: 8px;
    background: #fff; border: 1px solid var(--border); border-radius: 26px;
    padding: 6px 6px 6px 18px; box-shadow: 0 1px 2px rgba(0,0,0,.04);
  }
  .form:focus-within { border-color: #c7c7cc; }
  .form input {
    flex: 1; border: none; outline: none; background: transparent;
    font-size: 15.5px; color: var(--text); padding: 9px 0;
  }
  .form input::placeholder { color: var(--muted); }
  .send {
    flex: none; width: 36px; height: 36px; border: none; border-radius: 50%;
    background: var(--accent); color: #fff; cursor: pointer; font-size: 18px;
    display: grid; place-items: center; transition: opacity .12s ease;
  }
  .send:hover { opacity: .85; }
  .send:disabled { background: #d4d4d8; cursor: default; }
  .mic { flex: none; width: 36px; height: 36px; border: none; border-radius: 50%; background: transparent; color: var(--muted); cursor: pointer; display: grid; place-items: center; }
  .mic:hover { color: var(--text); background: #f1f1f3; }
  .mic[hidden] { display: none; }
  .mic.listening { color: #fff; background: #e5484d; animation: micpulse 1.3s ease-in-out infinite; }
  @keyframes micpulse { 0%, 100% { box-shadow: 0 0 0 0 rgba(229,72,77,.45); } 50% { box-shadow: 0 0 0 6px rgba(229,72,77,0); } }
  .hint { margin-top: 9px; padding-left: 19px; text-align: left; font-size: 12px; color: var(--muted); }
  .hint kbd { font-family: ui-monospace, Menlo, monospace; font-size: 11px; background: #f4f4f5; border: 1px solid var(--border); border-bottom-width: 2px; border-radius: 5px; padding: 1px 6px; color: #3f3f46; }

  /* ---------- "/" command menu (multi-column) ---------- */
  .slash {
    position: absolute; left: 0; right: 0; bottom: calc(100% + 8px);
    max-height: 62vh; overflow-y: auto;
    background: #fff; border: 1px solid var(--border); border-radius: 16px;
    box-shadow: 0 16px 48px rgba(0,0,0,.18); padding: 18px 22px; z-index: 20;
    display: flex; flex-direction: column; gap: 10px;
  }
  .slash[hidden] { display: none; }
  .slash-none { padding: 4px 8px 8px; font-size: 12.5px; color: var(--muted); }
  /* wrap into ~4 columns per row -> two rows for the 8 groups, with room to breathe */
  .slash-grid { display: flex; flex-wrap: wrap; gap: 18px 30px; align-items: flex-start; }
  .slash-col { flex: 1 1 240px; min-width: 200px; }
  .slash-group { font-size: 10px; letter-spacing: .13em; text-transform: uppercase; color: #a1a1aa; padding: 4px 10px 8px; }
  .slash-item {
    display: block; width: 100%; text-align: left; border: none; background: none;
    border-radius: 8px; padding: 8px 11px; font: inherit; font-size: 13px;
    line-height: 1.35; color: var(--text); cursor: pointer;
  }
  .slash-item:hover, .slash-item.active { background: #f4f4f5; }

  /* ---------- starter chips (initial visible openers) ---------- */
  .starters { display: flex; flex-wrap: wrap; gap: 8px; margin-top: 18px; }
  .chip {
    padding: 8px 14px; border: 1px solid var(--border); border-radius: 999px;
    background: #fff; color: var(--text); font-size: 13.5px; cursor: pointer;
  }
  .chip:hover { background: #f7f7f8; }

  /* ---------- full-screen ---------- */
  .fs { position: fixed; inset: 0; z-index: 2147483000; display: flex; flex-direction: row; background: var(--bg); color: var(--text); }
  .sidebar { width: 252px; flex: none; display: flex; flex-direction: column; background: #f7f7f8; border-right: 1px solid var(--border); }
  .sidebar-new { margin: 12px; padding: 9px 12px; border: 1px solid var(--border); border-radius: 10px; background: #fff; color: var(--text); cursor: pointer; font-size: 14px; display: flex; align-items: center; gap: 8px; }
  .sidebar-new:hover { border-color: #c7c7cc; }
  .sidebar-new span { font-size: 16px; line-height: 1; }
  .job-pill { display: flex; align-items: center; gap: 6px; margin: 0 12px 8px; padding: 7px 9px; background: #eef1fb; border: 1px solid #d6dcf5; border-radius: 9px; font-size: 12.5px; }
  .job-pill-tag { flex: none; font-size: 9px; font-weight: 700; letter-spacing: .08em; color: #fff; background: #6b78d6; border-radius: 4px; padding: 2px 5px; }
  .job-pill-label { flex: 1; min-width: 0; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; color: #2b3380; }
  .job-pill-clear { flex: none; border: none; background: none; color: #6b78d6; cursor: pointer; font-size: 16px; line-height: 1; padding: 0 2px; }
  .job-pill-clear:hover { color: #b42318; }
  .sidebar-list { flex: 1; overflow-y: auto; padding: 2px 8px 14px; display: flex; flex-direction: column; gap: 2px; }
  .sidebar-item { display: flex; align-items: center; gap: 6px; padding: 8px 10px; border-radius: 8px; cursor: pointer; font-size: 13.5px; color: var(--text); }
  .sidebar-item:hover { background: #ececee; }
  .sidebar-item.active { background: #e4e4e7; }
  .sidebar-title { flex: 1; min-width: 0; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
  .sidebar-del { flex: none; border: none; background: none; color: var(--muted); cursor: pointer; font-size: 16px; line-height: 1; padding: 0 2px; opacity: 0; }
  .sidebar-item:hover .sidebar-del { opacity: 1; }
  .sidebar-del:hover { color: #b42318; }
  .fs-main { flex: 1; min-width: 0; display: flex; flex-direction: column; }
  /* Slack-style side thread */
  .thread { display: none; flex: none; width: 42%; min-width: 340px; flex-direction: column; border-left: 1px solid var(--border); background: var(--bg); }
  .fs.thread-open .thread { display: flex; }
  .fs.thread-open .fs-main { flex: 1 1 0; min-width: 0; }
  .thread-head { display: flex; align-items: center; justify-content: space-between; gap: 12px; padding: 14px 20px; border-bottom: 1px solid var(--border); font-size: 14px; font-weight: 600; }
  .thread-title { min-width: 0; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
  .thread-close { border: none; background: none; color: var(--muted); cursor: pointer; font-size: 20px; line-height: 1; }
  .thread-close:hover { color: var(--text); }
  .thread-scroll { flex: 1; overflow-y: auto; padding: 20px; }
  .thread-composer { border-top: 1px solid var(--border); padding: 12px 16px 16px; }
  .fs-scroll { flex: 1; overflow-y: auto; }
  .fs-col { max-width: 768px; margin: 0 auto; padding: 0 20px; }
  .fs-intro { padding: 52px 0 24px; text-align: left; }
  .fs-intro h1 { font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif; font-weight: 650; font-size: clamp(28px, 4.4vw, 38px); margin: 0; }
  .fs-intro .tagline { margin: 12px 0 0; max-width: 620px; color: var(--muted); font-size: 16px; line-height: 1.5; }
  .fs-scroll .messages { padding-bottom: 28px; }
  .fs-composer { background: var(--bg); border-top: 1px solid var(--border); }
  .fs-composer .fs-col { padding-top: 14px; padding-bottom: 18px; }
  /* widen the menu beyond the message column so all columns sit side by side */
  .fs-composer .slash { left: 50%; right: auto; transform: translateX(-50%); width: min(1240px, 95vw); }

  /* ---------- floating ---------- */
  .launcher {
    position: fixed; right: 20px; bottom: 20px; z-index: 2147483000;
    display: flex; align-items: center; gap: 8px;
    padding: 11px 17px; border: none; border-radius: 999px; cursor: pointer;
    background: var(--accent); color: #fff; font-size: 14.5px;
    box-shadow: 0 4px 16px rgba(0,0,0,.18); transition: opacity .12s ease;
  }
  .launcher:hover { opacity: .9; }
  .launcher[hidden] { display: none; }
  .panel {
    position: fixed; right: 20px; bottom: 20px; z-index: 2147483000;
    width: min(400px, calc(100vw - 40px)); height: min(600px, calc(100vh - 40px));
    display: none; flex-direction: column; overflow: hidden;
    background: var(--bg); border: 1px solid var(--border); border-radius: 16px;
    box-shadow: 0 16px 48px rgba(0,0,0,.22);
  }
  .panel.open { display: flex; }
  .p-header { display: flex; align-items: center; justify-content: space-between; padding: 14px 16px; border-bottom: 1px solid var(--border); }
  .p-header h2 { margin: 0; font-size: 14.5px; font-weight: 600; }
  .p-header p { margin: 1px 0 0; font-size: 12px; color: var(--muted); }
  .close { background: none; border: none; color: var(--muted); cursor: pointer; font-size: 20px; line-height: 1; }
  .close:hover { color: var(--text); }
  .p-actions { display: flex; align-items: center; gap: 4px; }
  .newchat-sm { background: none; border: none; color: var(--muted); cursor: pointer; font-size: 17px; line-height: 1; padding: 0 2px; }
  .newchat-sm:hover { color: var(--text); }
  .p-scroll { flex: 1; overflow-y: auto; padding: 16px; }
  .p-composer { padding: 12px; border-top: 1px solid var(--border); }
  .p-composer .slash { max-height: 260px; }
  /* the floating panel is too narrow for 5 columns; let them wrap there */
  .p-composer .slash-grid { flex-wrap: wrap; }
  .p-composer .slash-col { flex: 1 1 118px; min-width: 116px; }

  /* Let the OS use overlay scrollbars (appear only while scrolling, no reserved
     gutter). Styling ::-webkit-scrollbar would force a persistent one. */
`;

/** Parse an Anthropic SSE stream, invoking onText for each text delta. */
async function streamReply(messages, onText, onJd) {
  const res = await fetch(AGENT_URL, {
    method: "POST",
    headers: { "content-type": "application/json" },
    body: JSON.stringify({ messages }),
  });

  if (!res.ok || !res.body) {
    const detail = await res.json().catch(() => ({}));
    throw new Error(detail.error || `Request failed (${res.status})`);
  }

  const reader = res.body.getReader();
  const decoder = new TextDecoder();
  let buffer = "";

  while (true) {
    const { value, done } = await reader.read();
    if (done) break;
    buffer += decoder.decode(value, { stream: true });

    const events = buffer.split("\n\n");
    buffer = events.pop() ?? "";

    for (const event of events) {
      const evType = event.split("\n").find((l) => l.startsWith("event:"))?.slice(6).trim();
      const dataLine = event.split("\n").find((l) => l.startsWith("data:"));
      if (!dataLine) continue;
      const data = dataLine.slice(5).trim();
      if (!data || data === "[DONE]") continue;
      try {
        const json = JSON.parse(data);
        if (evType === "cv_jd") {
          onJd?.(json); // the server fetched a job description; remember it globally
          continue;
        }
        if (json.type === "content_block_delta" && json.delta?.type === "text_delta") {
          onText(json.delta.text);
        }
      } catch {
        /* ignore keep-alive / non-JSON lines */
      }
    }
  }
}

/** Minimal, safe markdown -> HTML for replies (bold, italic, code, links, headings, lists). */
function renderMarkdown(md) {
  const escape = (s) =>
    s.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");

  const inline = (s) =>
    escape(s)
      .replace(/`([^`]+)`/g, "<code>$1</code>")
      .replace(/\*\*([^*]+)\*\*/g, '<strong class="entity" role="button" tabindex="0">$1</strong>')
      .replace(/(^|[^*])\*([^*\n]+)\*(?!\*)/g, "$1<em>$2</em>")
      .replace(/\[([^\]]+)\]\((https?:\/\/[^)\s]+)\)/g, '<a href="$2" target="_blank" rel="noopener noreferrer">$1</a>');

  let html = "";
  let list = null;
  const closeList = () => { if (list) { html += `</${list}>`; list = null; } };

  for (const line of md.split("\n")) {
    if (!line.trim()) { closeList(); continue; }
    let m;
    if ((m = line.match(/^\s*[-*]\s+(.*)$/))) {
      if (list !== "ul") { closeList(); html += "<ul>"; list = "ul"; }
      html += `<li>${inline(m[1])}</li>`;
    } else if ((m = line.match(/^\s*\d+\.\s+(.*)$/))) {
      if (list !== "ol") { closeList(); html += "<ol>"; list = "ol"; }
      html += `<li>${inline(m[1])}</li>`;
    } else if ((m = line.match(/^(#{1,6})\s+(.*)$/))) {
      closeList();
      html += `<div class="md-h">${inline(m[2])}</div>`;
    } else {
      closeList();
      html += `<p>${inline(line)}</p>`;
    }
  }
  closeList();
  return html;
}

/** Pull `[[suggest: ...]]` follow-up options out of a reply. */
function extractSuggestions(text) {
  return [...text.matchAll(/\[\[suggest:\s*([^\]]+?)\s*\]\]/gi)].map((m) => m[1].trim()).slice(0, 4);
}

/** Pull the single `[[more: ...]]` deep-dive query (the circle-arrow expand). */
function extractMore(text) {
  const m = text.match(/\[\[more:\s*([^\]]+?)\s*\]\]/i);
  return m ? m[1].trim() : null;
}

/** Strip control tokens (and any trailing partial one mid-stream) for display. */
function stripTokens(text) {
  return text
    .replace(/\[\[(?:suggest|more):\s*[^\]]*?\s*\]\]/gi, "") // complete tokens
    .replace(/\[\[[^\]]*$/, "") // a trailing, not-yet-closed "[[..." while streaming
    .replace(/[ \t]+\n/g, "\n")
    .replace(/\n{3,}/g, "\n\n")
    .trimEnd();
}

// Company names that should render as clickable drill-in titles.
const COMPANY_SET = new Set([
  "boulevard", "comparethemarket", "bean", "vorwerk", "informa", "zapnito",
  "liqid", "tastermonial", "twentybn", "tree3", "lytbulb", "myschooldirect",
  "nutshell", "nutshell development", "xp flow", "xpflow", "alfie",
]);
// Subset with a bundled logo in public/logos/. Defunct firms are omitted, so
// they simply show no logo (no broken icon, no gap).
const COMPANY_LOGO_KEYS = {
  boulevard: "boulevard",
  comparethemarket: "comparethemarket",
  bean: "comparethemarket",
  vorwerk: "vorwerk",
  informa: "informa",
  zapnito: "zapnito",
  liqid: "liqid",
  tastermonial: "tastermonial",
  "xp flow": "xpflow",
  xpflow: "xpflow",
  alfie: "xpflow",
};
const companyHead = (text) => text.toLowerCase().trim().split(/[/(]/)[0].trim();
const isCompany = (text) => COMPANY_SET.has(text.toLowerCase().trim()) || COMPANY_SET.has(companyHead(text));
function companyLogo(text) {
  const t = text.toLowerCase().trim();
  const key = COMPANY_LOGO_KEYS[t] || COMPANY_LOGO_KEYS[companyHead(t)];
  return key ? `/logos/${key}.png` : null;
}

/**
 * Make company names interactive: section-headings that name a company become
 * clickable titles, and any company entity (heading or inline bold) gets a logo.
 */
function decorateEntities(bubble) {
  // A "### Company" heading becomes a clickable, drill-in title.
  bubble.querySelectorAll(".md-h").forEach((h) => {
    if (isCompany(h.textContent.trim())) {
      h.classList.add("entity");
      h.setAttribute("role", "button");
      h.setAttribute("tabindex", "0");
    }
  });
  // Prepend the bundled logo to any company entity (heading or inline bold). The
  // image is inserted only once it has loaded, so a missing logo leaves no gap.
  bubble.querySelectorAll(".entity").forEach((el) => {
    if (el.dataset.logo) return;
    const src = companyLogo(el.textContent.trim());
    if (!src) return;
    el.dataset.logo = "1";
    const img = new Image();
    img.className = "logo";
    img.alt = "";
    img.onload = () => el.prepend(img);
    img.src = src;
  });
}

/**
 * Wire the "/" command menu onto the input. The "/" and the filter text live in
 * the input box: a leading "/" opens a filterable, keyboard-navigable popover of
 * topics, and the rest of the input filters it. Selecting one sends its query.
 */
function setupSlashMenu(input, slashEl, onPick) {
  let open = false;
  let cols = []; // [[{ query, el }, ...], ...] — one inner array per column
  let aCol = 0;
  let aRow = 0;

  const close = () => {
    open = false;
    cols = [];
    slashEl.hidden = true;
    if (input.value.startsWith("/")) input.value = ""; // closed menu => no leading slash
  };
  const choose = (query) => { close(); input.value = ""; onPick(query); };

  const filtered = (q) =>
    TOPIC_GROUPS
      .map((g) => ({ group: g.group, items: g.items.filter((it) => it.label.toLowerCase().includes(q)) }))
      .filter((g) => g.items.length);

  function setActive(col, row) {
    if (!cols.length) return;
    aCol = (col + cols.length) % cols.length;
    aRow = Math.max(0, Math.min(row, cols[aCol].length - 1));
    for (const c of cols) for (const it of c) it.el.classList.remove("active");
    const cur = cols[aCol][aRow];
    cur.el.classList.add("active");
    cur.el.scrollIntoView({ block: "nearest" });
  }

  // Up/down move within a column and roll into the next/previous one;
  // left/right jump columns directly, keeping the same row.
  function down() {
    if (aRow + 1 < cols[aCol].length) setActive(aCol, aRow + 1);
    else setActive(aCol + 1, 0);
  }
  function up() {
    if (aRow > 0) setActive(aCol, aRow - 1);
    else { const p = (aCol - 1 + cols.length) % cols.length; setActive(p, cols[p].length - 1); }
  }

  function render(q) {
    slashEl.innerHTML = "";
    cols = [];

    const groups = filtered(q);
    if (!groups.length) {
      const none = document.createElement("div");
      none.className = "slash-none";
      none.textContent = "No matching topics";
      slashEl.appendChild(none);
    } else {
      const grid = document.createElement("div");
      grid.className = "slash-grid";
      for (const g of groups) {
        const colEl = document.createElement("div");
        colEl.className = "slash-col";
        const h = document.createElement("div");
        h.className = "slash-group";
        h.textContent = g.group;
        colEl.appendChild(h);
        const col = [];
        for (const it of g.items) {
          const b = document.createElement("button");
          b.className = "slash-item";
          b.type = "button";
          b.textContent = it.label;
          b.addEventListener("mousedown", (e) => e.preventDefault()); // keep input focus
          b.addEventListener("click", () => choose(it.query));
          colEl.appendChild(b);
          col.push({ query: it.query, el: b });
        }
        cols.push(col);
        grid.appendChild(colEl);
      }
      slashEl.appendChild(grid);
      setActive(0, 0);
    }

    open = true;
    slashEl.hidden = false;
    slashEl.scrollTop = 0;
  }

  // The input value drives the menu: a leading "/" opens it, the rest filters.
  const sync = () => {
    const v = input.value;
    if (v.startsWith("/")) render(v.slice(1).toLowerCase().trim());
    else if (open) close();
  };
  input.addEventListener("input", sync);

  input.addEventListener("keydown", (e) => {
    if (!open) return;
    switch (e.key) {
      case "ArrowDown": e.preventDefault(); down(); break;
      case "ArrowUp": e.preventDefault(); up(); break;
      case "ArrowRight": e.preventDefault(); setActive(aCol + 1, aRow); break;
      case "ArrowLeft": e.preventDefault(); setActive(aCol - 1, aRow); break;
      case "Enter": { e.preventDefault(); const cur = cols[aCol]?.[aRow]; if (cur) choose(cur.query); break; }
      case "Escape":
        e.preventDefault();
        if (input.value.length > 1) { input.value = "/"; render(""); } // first clears the filter
        else close(); // second closes (close() strips the leading slash)
        break;
    }
  });
  input.addEventListener("blur", () => setTimeout(close, 120));

  // Used by type-to-focus: put the "/" in the box and open.
  function openMenu() {
    if (!input.value.startsWith("/")) input.value = "/";
    render(input.value.slice(1).toLowerCase().trim());
  }
  return { open: openMenu };
}

/**
 * Shared conversation engine. `scrollEl` is the scroll container; `messagesEl`
 * is where bubbles append. Auto-scroll sticks to the bottom only when already
 * near it. Wires the "/" menu if a `.slash` element is present in the composer.
 */
function createConversation({ scrollEl, messagesEl, input, form, sendBtn, startersEl, onUpdate, onMore, contextMessages = [], lite = false }) {
  const messages = [];
  let followupsEl = null; // the suggested-follow-up chip row after the last reply
  const NEAR_BOTTOM = 90;
  const atBottom = () =>
    scrollEl.scrollHeight - scrollEl.scrollTop - scrollEl.clientHeight < NEAR_BOTTOM;
  const toBottom = () => { scrollEl.scrollTop = scrollEl.scrollHeight; };

  function addBubble(role, text) {
    const stick = atBottom();
    const el = document.createElement("div");
    el.className = `msg ${role}`;
    if (role === "assistant") {
      el.innerHTML = renderMarkdown(text);
      decorateEntities(el);
    } else {
      el.textContent = text;
    }
    messagesEl.appendChild(el);
    if (stick) toBottom();
    return el;
  }

  let currentSuggestions = [];
  const saveState = () => onUpdate?.(messages, currentSuggestions);

  function greet() { addBubble("assistant", GREETING); }

  // Render (or clear) the follow-up suggestion chips after the latest reply.
  function renderFollowups(suggestions) {
    if (followupsEl) { followupsEl.remove(); followupsEl = null; }
    currentSuggestions = suggestions || [];
    if (!currentSuggestions.length) return;
    const stick = atBottom();
    followupsEl = document.createElement("div");
    followupsEl.className = "starters"; // same chip-row styling
    buildStarters(followupsEl, currentSuggestions, (q) => send(q));
    messagesEl.appendChild(followupsEl);
    if (stick) toBottom();
  }

  // The "expand" circle-arrow appended inline after a summary that has more.
  function appendMore(bubble, query) {
    const btn = document.createElement("button");
    btn.className = "more-btn";
    btn.type = "button";
    btn.title = "More on this";
    btn.setAttribute("aria-label", "More on this");
    btn.innerHTML =
      '<svg viewBox="0 0 24 24" width="15" height="15" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><path d="M8.5 12h6M12.5 9l3 3-3 3"/></svg>';
    btn.addEventListener("click", () => send(query));
    const host = bubble.querySelector("p:last-of-type, li:last-of-type") || bubble;
    host.append(" ", btn);
  }

  // For multi-section replies, append a "Tell me more" link after each section
  // (heading + its paragraphs). Clicking opens a side thread via onMore.
  function addSectionMore(bubble) {
    [...bubble.querySelectorAll(".md-h")].forEach((h) => {
      let last = h;
      for (let n = h.nextElementSibling; n && !n.classList.contains("md-h"); n = n.nextElementSibling) last = n;
      const topic = h.textContent.trim();
      const link = document.createElement("button");
      link.className = "section-more";
      link.type = "button";
      link.textContent = "More →";
      link.addEventListener("click", () => onMore(`Tell me more about ${topic} (in the context of Oliver's career).`, messages.slice(), topic));
      last.after(link);
    });
  }

  // Multi-section replies get per-section thread links; otherwise the circle-arrow.
  function applyMore(bubble, moreQuery) {
    if (onMore && bubble.querySelector(".md-h")) addSectionMore(bubble);
    else appendMore(bubble, moreQuery);
  }

  // Clicking a bold entity drills into that topic (delegated; bubbles use innerHTML).
  const drillEntity = (el) => el && send(`Tell me more about ${el.textContent.trim()}.`);
  messagesEl.addEventListener("click", (e) => drillEntity(e.target.closest?.(".entity")));
  messagesEl.addEventListener("keydown", (e) => {
    if (e.key === "Enter" || e.key === " ") {
      const ent = e.target.closest?.(".entity");
      if (ent) { e.preventDefault(); drillEntity(ent); }
    }
  });

  async function send(text) {
    if (startersEl) startersEl.replaceChildren(); // hide the opener chips, keep the slot
    renderFollowups([]);
    messages.push({ role: "user", content: text });
    addBubble("user", text);
    toBottom();
    saveState();

    input.value = "";
    input.disabled = true;
    sendBtn.disabled = true;

    const bubble = addBubble("assistant", "");
    const caret = document.createElement("span");
    caret.className = "caret";
    bubble.appendChild(caret);

    // Thread conversations prepend a hidden snapshot of the parent chat as
    // context; ensure the sequence still begins with a user turn after capping.
    let outgoing = [...contextMessages, ...messages].slice(-20);
    while (outgoing.length && outgoing[0].role !== "user") outgoing.shift();

    // Inject the globally-active job description so EVERY chat and thread sees it,
    // unless this conversation already carries the job link (the server fetches
    // that one itself) or the JD is already in the messages.
    const job = loadActiveJob();
    if (job && job.text) {
      const ui = outgoing.findIndex((m) => m.role === "user");
      const hasLink = job.url && outgoing.some((m) => m.content.includes(job.url));
      const alreadyInjected = outgoing.some((m) => m.content.includes("[Active job description"));
      if (ui >= 0 && !hasLink && !alreadyInjected) {
        outgoing = outgoing.slice();
        outgoing[ui] = {
          ...outgoing[ui],
          content:
            "[Active job description the visitor is evaluating Oliver against — keep it in mind for this whole conversation:]\n" +
            job.text +
            "\n\n---\n\n" +
            outgoing[ui].content,
        };
      }
    }

    let answer = "";
    try {
      await streamReply(
        outgoing,
        (delta) => {
          const stick = atBottom();
          answer += delta;
          bubble.innerHTML = renderMarkdown(stripTokens(answer));
          bubble.appendChild(caret);
          if (stick) toBottom();
        },
        (jd) => setActiveJob({ url: jd.url, text: jd.text, at: Date.now() }),
      );
      caret.remove();
      const clean = stripTokens(answer);
      if (clean.trim()) {
        bubble.innerHTML = renderMarkdown(clean);
        decorateEntities(bubble);
        applyMore(bubble, extractMore(answer) || "Tell me more about that.");
        messages.push({ role: "assistant", content: clean });
        renderFollowups(extractSuggestions(answer));
        saveState();
      } else {
        bubble.remove();
        addBubble("error", "No reply received. Please try again.");
      }
    } catch (err) {
      bubble.remove();
      const unreachable = err instanceof TypeError;
      addBubble(
        "error",
        unreachable
          ? "Couldn't reach the assistant just now. Please try again in a moment."
          : err.message || "Something went wrong. Try again shortly.",
      );
    } finally {
      input.disabled = false;
      sendBtn.disabled = false;
      input.focus();
    }
  }

  form.addEventListener("submit", (e) => {
    e.preventDefault();
    const text = input.value.trim();
    if (text && !text.startsWith("/")) send(text);
  });

  // The slash menu, mic, and type-to-focus are for the main composers only, not
  // lightweight thread instances.
  if (!lite) {
    const slashEl = form.parentElement?.querySelector(".slash");
    const slash = slashEl ? setupSlashMenu(input, slashEl, (q) => send(q)) : null;

    const micBtn = form.querySelector(".mic");
    if (micBtn) setupMic(micBtn, input);

    // Type anywhere (input visible but unfocused) to focus it and capture the key.
    let inputFocused = false;
    input.addEventListener("focus", () => { inputFocused = true; });
    input.addEventListener("blur", () => { inputFocused = false; });
    const host = input.getRootNode().host;
    document.addEventListener("keydown", (e) => {
      if (inputFocused || e.metaKey || e.ctrlKey || e.altKey) return;
      if (input.getClientRects().length === 0) return; // input not visible (panel closed)
      // A field inside the widget's shadow root is focused (e.g. a thread's reply
      // box) — document.activeElement only sees the host, so check the shadow too.
      const inner = input.getRootNode().activeElement;
      if (inner && (inner.tagName === "INPUT" || inner.tagName === "TEXTAREA" || inner.isContentEditable)) return;
      const a = document.activeElement;
      if (a && a !== document.body && a !== host &&
          (a.tagName === "INPUT" || a.tagName === "TEXTAREA" || a.isContentEditable)) return;
      if (e.key === "/") { e.preventDefault(); input.focus(); slash?.open(); }
      else if (e.key.length === 1) { input.focus(); }
    });

    // Paste anywhere (when no field is focused) routes the text into the input,
    // so pasting a job-description URL always lands in the chat box.
    document.addEventListener("paste", (e) => {
      if (input.getClientRects().length === 0) return; // input not visible
      const inner = input.getRootNode().activeElement; // focused element inside the widget's shadow root
      if (inner && (inner.tagName === "INPUT" || inner.tagName === "TEXTAREA" || inner.isContentEditable)) return; // a field (this input or a thread's) is focused: let the default paste happen
      const a = document.activeElement;
      if (a && a !== document.body && a !== host &&
          (a.tagName === "INPUT" || a.tagName === "TEXTAREA" || a.isContentEditable)) return; // a light-DOM field is focused
      const text = e.clipboardData && e.clipboardData.getData("text");
      if (!text) return;
      e.preventDefault();
      input.focus();
      if (input.value && !/\s$/.test(input.value)) input.value += " ";
      input.value += text;
      const pos = input.value.length;
      input.setSelectionRange(pos, pos);
    });
  }

  // Show a given chat's messages (or, if empty, the greeting + opener chips).
  function load(chat) {
    messages.length = 0;
    currentSuggestions = [];
    followupsEl = null;
    messagesEl.replaceChildren();
    if (startersEl) startersEl.replaceChildren();
    if (chat && chat.messages && chat.messages.length) {
      for (const m of chat.messages) {
        messages.push(m);
        const el = addBubble(m.role, m.content);
        if (m.role === "assistant") applyMore(el, "Tell me more about that."); // re-add thread links on restore
      }
      renderFollowups(chat.suggestions || []);
      toBottom();
    } else {
      greet();
      if (startersEl) buildStarters(startersEl, PERSONAS, (q) => send(q));
    }
    // Focus the composer on every load (switching chats / new chat) when visible.
    if (input.getClientRects().length) input.focus();
  }

  return { send, load };
}

// Speech recognisers mis-hear tech terms ("next jazz" -> "Next.js"). Browsers
// ignore custom grammars, so correct the transcript after the fact.
const DICTATION_FIXES = [
  [/\bnext\s*(?:\.?\s*js|jazz|j\.?\s*s\.?)\b/gi, "Next.js"],
  [/\bnode\s*(?:\.?\s*js|jazz|j\.?\s*s\.?)\b/gi, "Node.js"],
  [/\bnest\s*(?:\.?\s*js|jazz|j\.?\s*s\.?)\b/gi, "NestJS"],
  [/\btype\s*script\b/gi, "TypeScript"],
  [/\bjava\s*script\b/gi, "JavaScript"],
  [/\bgraph\s*(?:ql|q\s*l|cool|qel)\b/gi, "GraphQL"],
  [/\bpost\s*gres(?:ql|s)?\b/gi, "PostgreSQL"],
  [/\blang\s*chain\b/gi, "LangChain"],
  [/\blang\s*graph\b/gi, "LangGraph"],
  [/\blang\s*smith\b/gi, "LangSmith"],
  [/\bopen\s*a\.?\s*i\.?\b/gi, "OpenAI"],
  [/\brabbit\s*m\.?\s*q\.?\b/gi, "RabbitMQ"],
  [/\belixir\b/gi, "Elixir"],
  [/\bphoenix\b/gi, "Phoenix"],
  [/\bvercel\b/gi, "Vercel"],
  [/\bdrizzle\b/gi, "Drizzle"],
  [/\becto\b/gi, "Ecto"],
  [/\binngest\b/gi, "Inngest"],
  [/\baws\b/gi, "AWS"],
  [/\bsqs\b/gi, "SQS"],
];
const correctTranscript = (text) =>
  DICTATION_FIXES.reduce((s, [re, rep]) => s.replace(re, rep), text);

/**
 * Wire speech-to-text dictation onto a mic button using the Web Speech API.
 * Transcribes voice into the input box; the user reviews and sends. If the
 * browser lacks SpeechRecognition, the mic button stays hidden.
 */
function setupMic(micBtn, input) {
  const SR = window.SpeechRecognition || window.webkitSpeechRecognition;
  if (!SR) return; // unsupported (button stays hidden)
  micBtn.hidden = false;

  let rec = null;
  let listening = false;

  const stopUI = () => {
    listening = false;
    micBtn.classList.remove("listening");
    rec = null;
    input.focus();
  };

  micBtn.addEventListener("click", () => {
    if (listening) { try { rec.stop(); } catch {} return; }

    rec = new SR();
    rec.lang = "en-GB";
    rec.interimResults = true;
    rec.continuous = true;

    const base = input.value ? input.value.replace(/\s+$/, "") + " " : "";
    let finalText = "";
    rec.onresult = (e) => {
      let interim = "";
      for (let i = e.resultIndex; i < e.results.length; i++) {
        const t = e.results[i][0].transcript;
        if (e.results[i].isFinal) finalText += t;
        else interim += t;
      }
      input.value = base + correctTranscript(finalText + interim);
    };
    rec.onend = stopUI;
    rec.onerror = stopUI;

    try {
      rec.start();
      listening = true;
      micBtn.classList.add("listening");
    } catch {
      stopUI();
    }
  });
}

/** Fill a container with starter-question chips that send on click. */
function buildStarters(container, items, onPick) {
  for (const q of items) {
    const chip = document.createElement("button");
    chip.className = "chip";
    chip.type = "button";
    chip.textContent = q;
    chip.addEventListener("click", () => onPick(q));
    container.appendChild(chip);
  }
}

/** The composer markup (form + "/" menu + hint), shared by both modes. */
function composerHTML(placeholder) {
  return `
    <div class="composer">
      <div class="slash" hidden></div>
      <form class="form">
        <input type="text" placeholder="${placeholder}" autocomplete="off" />
        <button class="mic" type="button" aria-label="Voice input" hidden>
          <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="9" y="2" width="6" height="11" rx="3"/><path d="M5 10v1a7 7 0 0 0 14 0v-1"/><line x1="12" y1="18" x2="12" y2="22"/></svg>
        </button>
        <button class="send" type="submit" aria-label="Send">&uarr;</button>
      </form>
      <div class="hint">Press <kbd>/</kbd> for companies, stack &amp; projects</div>
    </div>
  `;
}

/** A lighter composer for the side-thread (no slash menu / mic / hint). */
function threadComposerHTML() {
  return `
    <div class="composer">
      <form class="form">
        <input type="text" placeholder="Reply in this thread..." autocomplete="off" />
        <button class="send" type="submit" aria-label="Send">&uarr;</button>
      </form>
    </div>
  `;
}

/**
 * Manage multiple saved chats (the sidebar). Owns the chat list + current chat,
 * persists to localStorage, and drives a `convo` (createConversation) view. If
 * `listEl` is null (the floating panel) there is no sidebar, just new-chat.
 */
function createSession(convo, listEl, onChange) {
  const state = loadChats();
  let current = null;

  const genId = () => Date.now().toString(36) + Math.random().toString(36).slice(2, 7);
  const titleOf = (chat) => {
    if (chat.title) return chat.title;
    const first = chat.messages.find((m) => m.role === "user");
    const t = (first ? first.content : "New chat").replace(/\s+/g, " ").trim();
    return t.length > 42 ? t.slice(0, 42) + "…" : t || "New chat";
  };

  function renderList() {
    if (!listEl) return;
    listEl.replaceChildren();
    for (const chat of state.chats) {
      const item = document.createElement("div");
      item.className = "sidebar-item" + (chat === current ? " active" : "");
      const title = document.createElement("span");
      title.className = "sidebar-title";
      title.textContent = titleOf(chat);
      const del = document.createElement("button");
      del.className = "sidebar-del";
      del.type = "button";
      del.setAttribute("aria-label", "Delete chat");
      del.textContent = "×";
      del.addEventListener("click", (e) => { e.stopPropagation(); remove(chat); });
      item.append(title, del);
      item.addEventListener("click", () => switchTo(chat));
      listEl.appendChild(item);
    }
  }

  // Persist the current chat after each message (wired as convo's onUpdate).
  function onUpdate(messages, suggestions) {
    if (!current) return;
    current.messages = messages.slice(-STORE_MAX_MESSAGES);
    current.suggestions = suggestions;
    current.updatedAt = Date.now();
    if (current.messages.length && !state.chats.includes(current)) state.chats.unshift(current);
    state.chats.sort((a, b) => b.updatedAt - a.updatedAt);
    state.currentId = current.id;
    saveChats(state);
    renderList();
  }

  function switchTo(chat) {
    if (chat === current) return;
    current = chat;
    state.currentId = chat.id;
    convo.load(chat);
    saveChats(state);
    renderList();
    onChange?.();
  }

  function newChat() {
    current = { id: genId(), title: "", messages: [], suggestions: [], updatedAt: Date.now() };
    convo.load(current);
    renderList();
    onChange?.();
  }

  // Side threads, persisted inside the current chat, keyed by their question.
  function ensureThread(question, ctx, title) {
    if (!current.threads) current.threads = {};
    if (current.threads[question]) return { thread: current.threads[question], isNew: false };
    const thread = { question, title, context: ctx, messages: [], suggestions: [] };
    current.threads[question] = thread;
    saveChats(state);
    return { thread, isNew: true };
  }
  const saveThreads = () => saveChats(state);

  function remove(chat) {
    state.chats = state.chats.filter((c) => c !== chat);
    saveChats(state);
    if (chat === current) {
      if (state.chats.length) switchTo(state.chats[0]);
      else newChat();
    } else {
      renderList();
    }
  }

  current = state.chats.find((c) => c.id === state.currentId) || state.chats[0] || null;
  if (current) convo.load(current);
  else newChat();
  renderList();

  return { onUpdate, newChat, ensureThread, saveThreads };
}

function mountFullscreen(root) {
  // The home page IS the chat: hide the Elm CV behind the opaque overlay and stop
  // the document from scrolling. Elm re-renders can override body display:none,
  // so also clamp documentElement overflow (Elm doesn't control <html>).
  document.body.style.display = "none";
  document.documentElement.style.overflow = "hidden";

  root.innerHTML = `
    <div class="fs">
      <aside class="sidebar">
        <button class="sidebar-new" type="button"><span>+</span> New chat</button>
        <div class="job-pill" hidden></div>
        <div class="sidebar-list"></div>
      </aside>
      <div class="fs-main">
        <div class="fs-scroll">
          <div class="fs-col">
            <div class="fs-intro">
              <h1>Oliver Searle-Barnes</h1>
              <p class="tagline">Hands-on CTO and Staff Engineer. A decade of Elixir at scale, most recently building agentic AI.</p>
            </div>
            <div class="messages"></div>
            <div class="starters"></div>
          </div>
        </div>
        <div class="fs-composer">
          <div class="fs-col">${composerHTML("Ask anything about Oliver...")}</div>
        </div>
      </div>
      <aside class="thread"></aside>
    </div>
  `;

  const fs = root.querySelector(".fs");
  const fsMain = root.querySelector(".fs-main");
  const threadEl = root.querySelector(".thread");
  const scrollEl = fsMain.querySelector(".fs-scroll");
  const messagesEl = fsMain.querySelector(".messages");
  const form = fsMain.querySelector(".form");
  const input = form.querySelector("input");
  const sendBtn = form.querySelector(".send");
  const startersEl = fsMain.querySelector(".starters");

  // Slack-style side thread: a separate conversation seeded with the parent
  // chat as hidden context, named after the section, persisted in the chat.
  function openThread(question, ctx, title) {
    const { thread, isNew } = session.ensureThread(question, ctx, title);
    const heading = thread.title || "Thread";
    threadEl.innerHTML = `
      <header class="thread-head"><span class="thread-title"></span><button class="thread-close" type="button" aria-label="Close thread">&times;</button></header>
      <div class="thread-scroll"><div class="messages"></div></div>
      <div class="thread-composer">${threadComposerHTML()}</div>
    `;
    threadEl.querySelector(".thread-title").textContent = heading;
    fs.classList.add("thread-open");
    threadEl.querySelector(".thread-close").addEventListener("click", closeThread);
    const tForm = threadEl.querySelector(".form");
    const tInput = tForm.querySelector("input");
    const tConvo = createConversation({
      scrollEl: threadEl.querySelector(".thread-scroll"),
      messagesEl: threadEl.querySelector(".messages"),
      input: tInput,
      form: tForm,
      sendBtn: tForm.querySelector(".send"),
      lite: true,
      contextMessages: thread.context,
      onUpdate: (m, s) => { thread.messages = m; thread.suggestions = s; session.saveThreads(); },
    });
    if (isNew) tConvo.send(question); // fetch the first reply
    else tConvo.load({ messages: thread.messages, suggestions: thread.suggestions }); // restore instantly
    tInput.focus();
  }
  function closeThread() {
    fs.classList.remove("thread-open");
    threadEl.replaceChildren();
  }

  let session;
  const convo = createConversation({
    scrollEl, messagesEl, input, form, sendBtn, startersEl,
    onUpdate: (m, s) => session.onUpdate(m, s),
    onMore: (q, ctx, title) => openThread(q, ctx, title),
  });
  session = createSession(convo, root.querySelector(".sidebar-list"), closeThread);
  root.querySelector(".sidebar-new").addEventListener("click", () => session.newChat());

  // The active-job pill: shows the remembered JD (injected into every chat /
  // thread) with a clear button.
  const jobPill = root.querySelector(".job-pill");
  function renderJobPill(job) {
    jobPill.replaceChildren();
    if (!job || !job.text) { jobPill.hidden = true; return; }
    jobPill.hidden = false;
    const tag = document.createElement("span");
    tag.className = "job-pill-tag";
    tag.textContent = "JOB";
    const label = document.createElement("span");
    label.className = "job-pill-label";
    label.textContent = jobLabel(job);
    label.title = "Active job description — included as context in every chat and thread";
    const clear = document.createElement("button");
    clear.className = "job-pill-clear";
    clear.type = "button";
    clear.setAttribute("aria-label", "Clear active job");
    clear.textContent = "×";
    clear.addEventListener("click", () => setActiveJob(null));
    jobPill.append(tag, label, clear);
  }
  renderJobPill(loadActiveJob());
  onActiveJobChange(renderJobPill);

  input.focus();
}

function mountFloating(root) {
  root.innerHTML = `
    <button class="launcher" aria-label="Ask about Oliver's career">
      <span>&#128172;</span><span>Ask about my career</span>
    </button>
    <section class="panel" role="dialog" aria-label="Career assistant">
      <header class="p-header">
        <div><h2>Career assistant</h2><p>Ask about Oliver's experience</p></div>
        <div class="p-actions">
          <button class="newchat-sm" type="button" aria-label="New chat" title="New chat">&#8635;</button>
          <button class="close" aria-label="Close">&times;</button>
        </div>
      </header>
      <div class="p-scroll"><div class="messages"></div><div class="starters"></div></div>
      <div class="p-composer">${composerHTML("Ask anything...")}</div>
    </section>
  `;

  const launcher = root.querySelector(".launcher");
  const panel = root.querySelector(".panel");
  const closeBtn = root.querySelector(".close");
  const scrollEl = root.querySelector(".p-scroll");
  const messagesEl = root.querySelector(".messages");
  const form = root.querySelector(".form");
  const input = form.querySelector("input");
  const sendBtn = form.querySelector(".send");
  const startersEl = root.querySelector(".starters");

  let session;
  const convo = createConversation({
    scrollEl, messagesEl, input, form, sendBtn, startersEl,
    onUpdate: (m, s) => session.onUpdate(m, s),
  });
  session = createSession(convo, null); // no sidebar list in the panel
  root.querySelector(".newchat-sm").addEventListener("click", () => session.newChat());

  launcher.addEventListener("click", () => {
    panel.classList.add("open");
    launcher.hidden = true;
    input.focus();
  });
  closeBtn.addEventListener("click", () => {
    panel.classList.remove("open");
    launcher.hidden = false;
  });
}

function mount() {
  const host = document.createElement("div");
  host.id = "cv-agent-host";
  document.documentElement.appendChild(host);

  const root = host.attachShadow({ mode: "open" });
  const style = document.createElement("style");
  style.textContent = STYLES;
  root.appendChild(style);
  const container = document.createElement("div");
  root.appendChild(container);

  const path = window.location.pathname;
  const isHome = path === "/" || path === "/index.html";
  if (isHome) mountFullscreen(container);
  else mountFloating(container);
}

mount();
