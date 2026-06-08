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
const BACKEND = ["Elixir", "Phoenix", "OTP", "Node.js", "NestJS", "Python", "Ruby on Rails", "Java", "GraphQL"];
const DATA = ["PostgreSQL", "Redis", "Ecto", "Drizzle"];
const PLATFORM = ["AWS", "Heroku", "Terraform", "Vercel", "SQS / Broadway", "RabbitMQ", "Inngest"];

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

// Once a role is set, the visitor is a recruiter checking fit — offer the fit
// assessment + ways to interrogate the match, instead of "are you hiring?".
const FIT_CHIPS = [
  "Map him to the key requirements",
  "His strongest evidence for this role",
  "What would he bring in the first 90 days?",
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

// Icons (Lucide, MIT). Inline SVG keeps them crisp and shadow-DOM-friendly, no
// web-font loading. `.ico` applies the shared Lucide stroke style.
const ICON = {
  circleArrowRight:
    '<svg class="ico circle-arrow" viewBox="0 0 24 24" width="18" height="18" aria-hidden="true"><circle cx="12" cy="12" r="10"/><path d="M8 12h8"/><path d="m12 16 4-4-4-4"/></svg>',
  arrowLeft:
    '<svg class="ico" viewBox="0 0 24 24" width="20" height="20" aria-hidden="true"><path d="M19 12H5"/><path d="m12 19-7-7 7-7"/></svg>',
  x:
    '<svg class="ico" viewBox="0 0 24 24" width="20" height="20" aria-hidden="true"><path d="M18 6 6 18"/><path d="m6 6 12 12"/></svg>',
  arrowUp:
    '<svg class="ico" viewBox="0 0 24 24" width="20" height="20" aria-hidden="true"><path d="M12 19V5"/><path d="m5 12 7-7 7 7"/></svg>',
};

// The "/" command menu, grouped.
const LEADERSHIP = [
  { label: "Engineering management", query: "Tell me about Oliver's engineering management experience." },
  { label: "Team leadership", query: "Tell me about Oliver's team leadership across his career." },
  { label: "Coaching & 1:1s", query: "How does Oliver coach and develop the engineers he manages?" },
  { label: "Performance management", query: "How has Oliver handled performance management and hard people decisions?" },
  { label: "Hiring & building teams", query: "Tell me about Oliver's experience hiring and building engineering teams." },
  { label: "Agile & process", query: "Tell me about Oliver's approach to agile and engineering process." },
  { label: "Feedback loops", query: "Tell me about Oliver's philosophy on shortening feedback loops." },
  { label: "Operating cadence (OKRs / Shape Up)", query: "Tell me about the operating cadence Oliver designed at Alfie." },
  { label: "Fractional / interim CTO", query: "Is Oliver a fit for a fractional or interim CTO role?" },
];

const TOPIC_GROUPS = [
  { group: "Ask about", items: PERSONAS.map((p) => ({ label: p, query: p })) },
  { group: "Projects", items: PROJECTS },
  { group: "Leadership", items: LEADERSHIP },
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

// A stable per-visitor id.
const VISITOR_KEY = "cv-agent-visitor:v1";
function visitorId() {
  let v = null;
  try {
    v = localStorage.getItem(VISITOR_KEY);
  } catch {
    /* ignore */
  }
  if (!v) {
    v = Date.now().toString(36) + Math.random().toString(36).slice(2, 9);
    try {
      localStorage.setItem(VISITOR_KEY, v);
    } catch {
      /* ignore */
    }
  }
  return v;
}

// Multi-JD state: a visitor holds a list of roles ("job descriptions"); ONE is
// FOCUSED and injected as context into every chat/thread. D1 is the source of
// truth (synced via the /jobs beacon); localStorage is a fast cache.
const JOBS_KEY = "cv-agent-jobs:v1";
const JOBS_URL = AGENT_URL.replace(/\/chat$/, "/jobs");
const LOG_URL = AGENT_URL.replace(/\/chat$/, "/log");
const STATE_URL = AGENT_URL.replace(/\/chat$/, "/state");
// Stable id for a durable thread generation (the per-thread Durable Object name):
// a hash of the exact request (context + seed + injected JD), so re-opening the
// same drill-in re-attaches to the same live stream.
function threadStreamId(outgoing, jobContext) {
  const s = JSON.stringify(outgoing) + " " + (jobContext || "");
  let h = 0;
  for (let i = 0; i < s.length; i++) h = (Math.imul(h, 31) + s.charCodeAt(i)) | 0;
  return "ts" + (h >>> 0).toString(36) + s.length.toString(36);
}
const jobListeners = new Set();

function loadJobsState() {
  try {
    return JSON.parse(localStorage.getItem(JOBS_KEY)) || { jobs: [], focusedId: null };
  } catch {
    return { jobs: [], focusedId: null };
  }
}
function persistJobs(state, { sync = true } = {}) {
  try {
    localStorage.setItem(JOBS_KEY, JSON.stringify(state));
  } catch {
    /* ignore */
  }
  if (sync) {
    try {
      fetch(JOBS_URL, {
        method: "POST",
        headers: { "content-type": "application/json" },
        keepalive: true,
        body: JSON.stringify({ visitorId: visitorId(), focusedJobId: state.focusedId, jobs: state.jobs }),
      }).catch(() => {});
    } catch {
      /* ignore */
    }
  }
  jobListeners.forEach((fn) => fn(state));
}
function onJobsChange(fn) {
  jobListeners.add(fn);
  return () => jobListeners.delete(fn);
}
function jobIdFor(url, text) {
  const s = (url || "") + "\n" + (text || "");
  let h = 0;
  for (let i = 0; i < s.length; i++) h = (Math.imul(h, 31) + s.charCodeAt(i)) | 0;
  return "j" + (h >>> 0).toString(36) + s.length.toString(36);
}
/** A short label for a JD pill, from its title or first line. */
function jobLabel(job) {
  const explicit = (job?.title || "").trim();
  const first = explicit || (job?.text || "").split("\n").find((l) => l.trim()) || "Role";
  const t = first.replace(/\s+/g, " ").trim();
  return t.length > 30 ? t.slice(0, 30) + "…" : t;
}
// Heuristic: did the visitor paste a job description as text (vs ask a question)?
// A pasted JD is long and carries role-posting language; this lets a pasted
// description register as the focused role just like a pasted link does.
function isLikelyJobDescription(text) {
  if (!text || text.length < 180) return false;
  const t = text.toLowerCase();
  const kw = [
    "responsibilit", "requirement", "qualificat", "you'll", "you will", "we're looking",
    "we are looking", "about the role", "what you'll", "must have", "nice to have",
    "experience with", "experience in", "this position", "the role", "who you are",
    "what we offer", "benefits", "salary", "full-time", "full time",
  ];
  const hits = kw.filter((k) => t.includes(k)).length;
  return hits >= 2 || (text.split("\n").length >= 4 && hits >= 1);
}

function addJob({ url, text, title }) {
  if (!text && !url) return null;
  const state = loadJobsState();
  const id = jobIdFor(url, text);
  if (!state.jobs.some((j) => j.id === id))
    state.jobs.push({ id, url: url || null, text: text || "", title: title || jobLabel({ text }) });
  state.focusedId = id; // adding a role focuses it
  persistJobs(state);
  return id;
}
function removeJob(id) {
  const state = loadJobsState();
  state.jobs = state.jobs.filter((j) => j.id !== id);
  if (state.focusedId === id) state.focusedId = state.jobs.length ? state.jobs[state.jobs.length - 1].id : null;
  persistJobs(state);
}
function focusJob(id) {
  const state = loadJobsState();
  state.focusedId = state.jobs.some((j) => j.id === id) ? id : state.focusedId;
  persistJobs(state);
}
// The focused JD is the "active job" injected into chats (back-compat name).
function loadActiveJob() {
  const state = loadJobsState();
  return state.jobs.find((j) => j.id === state.focusedId) || null;
}
// The server's cv_jd event (a URL it fetched) adds + focuses that JD.
function setActiveJob(job) {
  if (job && job.text) addJob({ url: job.url, text: job.text, title: job.title });
}

// Hidden reset: clear all chats, threads and roles, AND rotate the visitor id so
// the D1 reconcile starts from a clean slate. cv.dev/#reset or cvAgentReset().
function clearAllAgentState() {
  try {
    localStorage.removeItem(STORE_KEY);
    localStorage.removeItem(JOBS_KEY);
    localStorage.removeItem(VISITOR_KEY);
  } catch {
    /* ignore */
  }
}
if (typeof window !== "undefined") {
  window.cvAgentReset = () => {
    clearAllAgentState();
    location.hash = "";
    location.reload();
  };
  if (location.hash === "#reset") {
    clearAllAgentState();
    history.replaceState(null, "", location.pathname + location.search);
  }
}

// Fire-and-forget beacon of a chat's FULL tree (main column + threads) to D1.
// `chat.nodes` is the serialised column tree; falls back to the main messages
// as a single root node.
function logConversation(chat, title) {
  if (!chat) return;
  const nodes =
    Array.isArray(chat.nodes) && chat.nodes.length
      ? chat.nodes
      : chat.messages && chat.messages.length
        ? [{ id: chat.id, parentId: null, position: 0, title: "", seed: "", sectionText: "", messages: chat.messages }]
        : [];
  if (!nodes.some((n) => n.messages && n.messages.length)) return;
  try {
    fetch(LOG_URL, {
      method: "POST",
      headers: { "content-type": "application/json" },
      keepalive: true,
      body: JSON.stringify({ visitorId: visitorId(), chatId: chat.id, title: title || "", focusedJobId: loadJobsState().focusedId, nodes }),
    }).catch(() => {});
  } catch {
    /* ignore */
  }
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
  .retry-link {
    border: none; background: none; padding: 0; font: inherit; color: #b42318;
    font-weight: 600; text-decoration: underline; cursor: pointer;
  }
  .retry-link:hover { color: #7a1b12; }
  .caret {
    display: inline-block; width: 7px; height: 1em; margin-left: 2px;
    background: var(--text); opacity: .5; vertical-align: text-bottom;
    animation: blink 1.05s steps(2, start) infinite;
  }
  @keyframes blink { 50% { opacity: 0; } }

  .msg p { margin: 0 0 10px; }
  .msg p:last-child { margin-bottom: 0; }
  .msg .md-h { font-size: 18px; font-weight: 500; line-height: 1.3; margin: 22px 0 8px; color: var(--text); }
  .msg .md-h:first-child { margin-top: 0; }
  .msg .md-h.entity { display: inline-flex; align-items: center; gap: 7px; cursor: pointer; border-bottom: none; border-radius: 7px; padding: 2px 7px; margin-left: -7px; }
  .msg .md-h.entity:hover { background: #eef1ff; color: #2b3380; }
  .msg .md-h.entity .logo { width: 20px; height: 20px; margin-right: 0; border-radius: 4px; }
  .avatar { display: inline-flex; align-items: center; justify-content: center; flex: none; color: #fff; font-weight: 700; line-height: 1; }
  .avatar::before { content: attr(data-initials); }
  .msg .md-h.entity .avatar { width: 20px; height: 20px; border-radius: 4px; font-size: 9px; }
  .msg ul, .msg ol { margin: 6px 0 10px; padding-left: 22px; }
  .msg li { margin: 3px 0; }
  .msg strong { font-weight: 600; }
  .msg .entity { cursor: pointer; border-bottom: 1px dotted #c0c0c6; transition: background .12s ease, border-color .12s ease; border-radius: 2px; }
  .msg .entity:hover { background: #eef1ff; border-bottom-color: #6b78d6; color: #2b3380; }
  .msg .entity:focus-visible { outline: 2px solid #6b78d6; outline-offset: 1px; }
  .msg .entity .logo { width: 15px; height: 15px; margin-right: 5px; border-radius: 3px; object-fit: contain; vertical-align: -2px; background: #fff; }
  .msg .entity .avatar { width: 15px; height: 15px; margin-right: 5px; border-radius: 3px; font-size: 7.5px; vertical-align: -2px; }
  .ico { fill: none; stroke: currentColor; stroke-width: 2; stroke-linecap: round; stroke-linejoin: round; }
  .more-btn { display: inline-grid; place-items: center; vertical-align: -4px; width: 20px; height: 20px; margin-left: 2px; padding: 0; border: none; background: none; color: var(--muted); cursor: pointer; transition: color .12s ease; }
  .more-btn:hover { color: var(--accent); }
  .more-btn.loaded .circle-arrow circle { fill: currentColor; }
  .more-btn.loaded .circle-arrow path { stroke: #fff; }
  .section-more { display: flex; align-items: center; gap: 5px; width: fit-content; margin: 6px 0 0 auto; border: none; background: none; padding: 0; font: inherit; font-size: 13px; color: #6b78d6; cursor: pointer; }
  .section-more:hover { color: #2b3380; }
  .section-more.loaded .circle-arrow circle { fill: currentColor; } /* opened */
  .section-more.loaded .circle-arrow path { stroke: #fff; }
  .msg code { font-family: ui-monospace, Menlo, monospace; font-size: .9em; background: #f4f4f5; padding: 1px 5px; border-radius: 5px; }
  .msg.user code { background: rgba(0,0,0,.06); }
  .msg a { color: #2563eb; text-decoration: underline; }
  .msg hr { border: none; border-top: 1px solid var(--border); margin: 18px 0; }

  /* ---------- composer (shared) ---------- */
  .composer { position: relative; }
  .form {
    display: flex; align-items: center; gap: 8px;
    background: #fff; border: 1px solid var(--border); border-radius: 26px;
    padding: 6px 6px 6px 18px; box-shadow: 0 1px 2px rgba(0,0,0,.04);
  }
  .form:focus-within { border-color: #c7c7cc; }
  .form textarea {
    flex: 1; border: none; outline: none; background: transparent; resize: none;
    font-family: inherit; font-size: 15.5px; line-height: 1.4; color: var(--text);
    padding: 9px 0; max-height: 150px; overflow-y: auto;
  }
  .form textarea::placeholder { color: var(--muted); }
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
  .hiring-cta { flex-basis: 100%; padding: 14px 16px; border: 1px solid #d6dcf5; border-radius: 12px; background: #f3f5ff; cursor: text; }
  .hiring-cta:hover { border-color: #b9c2ee; }
  .hiring-cta-title { font-weight: 650; font-size: 15px; margin-bottom: 3px; color: var(--text); }
  .hiring-cta-sub { color: var(--muted); font-size: 13.5px; line-height: 1.45; }
  .starters-or { flex-basis: 100%; margin: 4px 0 -2px; font-size: 12.5px; color: var(--muted); }
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
  .roles { display: flex; flex-direction: column; gap: 4px; margin: 0 12px 10px; }
  .roles[hidden] { display: none; }
  .roles-head { font-size: 10px; font-weight: 700; letter-spacing: .08em; text-transform: uppercase; color: #9a9aa2; margin: 2px 2px 1px; }
  .role-pill { display: flex; align-items: center; gap: 6px; padding: 5px 6px 5px 8px; background: #f4f5fb; border: 1px solid #e4e6f1; border-radius: 8px; font-size: 12.5px; }
  .role-pill.focused { background: #eef1fb; border-color: #b9c2ee; }
  .role-dot { flex: none; width: 6px; height: 6px; border-radius: 50%; background: #cfd2e0; }
  .role-pill.focused .role-dot { background: var(--accent); }
  .role-label { flex: 1; min-width: 0; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; text-align: left; border: none; background: none; padding: 0; font: inherit; color: #5a5a64; cursor: pointer; }
  .role-pill.focused .role-label { color: #2b3380; font-weight: 600; }
  .role-x { flex: none; display: inline-flex; align-items: center; border: none; background: none; color: #a6a6ae; cursor: pointer; padding: 0; }
  .role-x:hover { color: #b42318; }
  .role-x svg { width: 14px; height: 14px; }
  /* read-only admin: users → summary → replay */
  .admin-app { position: fixed; inset: 0; display: flex; flex-direction: column; background: var(--bg); color: var(--text); }
  .admin-bar { flex: none; height: 52px; display: flex; align-items: center; gap: 8px; padding: 0 20px; border-bottom: 1px solid var(--border); font-size: 14px; }
  .admin-crumb { color: var(--text); }
  .admin-crumb.link { border: none; background: none; padding: 0; font: inherit; color: var(--accent); cursor: pointer; }
  .admin-crumb.link:hover { text-decoration: underline; }
  .admin-crumb-sep { color: var(--muted); }
  .admin-body { flex: 1; min-height: 0; display: flex; }
  .admin-replay { flex: 1; min-height: 0; display: flex; }
  .admin-scroll { flex: 1; overflow-y: auto; }
  .admin-panel { max-width: 760px; margin: 0 auto; padding: 24px 20px 80px; }
  .admin-card { display: block; width: 100%; text-align: left; border: 1px solid var(--border); border-radius: 10px; background: #fff; padding: 12px 14px; margin-bottom: 8px; cursor: pointer; }
  .admin-card:hover { border-color: #c7c7cc; }
  .ac-loc { font-weight: 600; font-size: 15px; }
  .ac-meta { font-size: 12.5px; color: var(--muted); margin-top: 3px; }
  .admin-card .admin-roles { margin-top: 8px; }
  .admin-sum-head { margin-bottom: 18px; }
  .admin-sum-head h2 { margin: 0 0 4px; font-size: 22px; }
  .admin-sum-sub { color: var(--muted); font-size: 13px; }
  .admin-section { margin-bottom: 22px; }
  .admin-section h3 { font-size: 12px; text-transform: uppercase; letter-spacing: .06em; color: var(--muted); margin: 0 0 10px; }
  .admin-roles { display: flex; flex-wrap: wrap; gap: 6px; }
  .admin-role { font-size: 12px; border: 1px solid #e4e6f1; border-radius: 6px; padding: 3px 8px; color: #5a5a64; text-decoration: none; }
  .admin-role.focused { background: #eef1fb; border-color: #b9c2ee; color: #2b3380; font-weight: 600; }
  .admin-conv { display: block; width: 100%; text-align: left; border: 1px solid var(--border); border-radius: 10px; background: #fff; padding: 12px 14px; margin-bottom: 8px; cursor: pointer; }
  .admin-conv:hover { border-color: #c7c7cc; }
  .acv-title { font-weight: 600; font-size: 14.5px; }
  .acv-explored { font-size: 12.5px; color: var(--muted); margin-top: 4px; }
  .acv-open { font-size: 12.5px; color: var(--accent); margin-top: 8px; }
  .admin-empty { color: var(--muted); font-size: 14px; padding: 20px 0; }
  .admin-empty.pad { margin: auto; }
  .admin-gate { margin: auto; display: flex; flex-direction: column; gap: 10px; width: 260px; }
  .admin-gate-title { font-size: 16px; font-weight: 600; text-align: center; margin-bottom: 2px; }
  .admin-gate-input { border: 1px solid var(--border); border-radius: 8px; padding: 10px 12px; font: inherit; }
  .admin-gate-btn { border: none; background: var(--accent); color: #fff; border-radius: 8px; padding: 10px; font: inherit; cursor: pointer; }
  .admin-gate-err { color: #b42318; font-size: 13px; text-align: center; }
  .replay-visited { background: #fdf3d0; box-shadow: 0 0 0 2px #fdf3d0; border-radius: 4px; }
  .replay-more { cursor: default; }
  .sidebar-list { flex: 1; overflow-y: auto; padding: 2px 8px 14px; display: flex; flex-direction: column; gap: 2px; }
  .sidebar-item { display: flex; align-items: center; gap: 6px; padding: 8px 10px; border-radius: 8px; cursor: pointer; font-size: 13.5px; color: var(--text); }
  .sidebar-item:hover { background: #ececee; }
  .sidebar-item.active { background: #e4e4e7; }
  .sidebar-title { flex: 1; min-width: 0; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
  .sidebar-del { flex: none; border: none; background: none; color: var(--muted); cursor: pointer; font-size: 16px; line-height: 1; padding: 0 2px; opacity: 0; }
  .sidebar-item:hover .sidebar-del { opacity: 1; }
  .sidebar-del:hover { color: #b42318; }
  /* Hierarchical columns: main chat + thread columns; ~2 visible, scroll for more. */
  .columns { flex: 1; min-width: 0; min-height: 0; display: flex; overflow-x: auto; overflow-y: hidden; scroll-behavior: smooth; }
  .column { flex: 0 0 50%; min-width: 0; display: flex; flex-direction: column; border-left: 1px solid var(--border); background: var(--bg); }
  .column:first-child { border-left: none; }
  .columns:not(.multi) .column { flex: 1 1 100%; }
  .thread-col { transition: opacity .22s ease, flex-basis .22s ease; }
  .thread-col.entering { opacity: 0; }
  .thread-col.leaving { opacity: 0; flex-basis: 0 !important; min-width: 0; overflow: hidden; }
  .thread-col-head { flex: none; display: flex; align-items: center; gap: 10px; padding: 12px 16px; border-bottom: 1px solid var(--border); font-size: 14px; font-weight: 600; }
  .thread-col-title { flex: 1; min-width: 0; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
  .thread-col-back { display: inline-flex; align-items: center; border: none; background: none; color: var(--muted); cursor: pointer; padding: 0; }
  .thread-col-back:hover { color: var(--text); }
  .thread-col-close { display: inline-flex; align-items: center; border: none; background: none; color: var(--muted); cursor: pointer; padding: 0; }
  .thread-col-close:hover { color: var(--text); }
  .col-scroll { flex: 1; overflow-y: auto; }
  .col-scroll .messages { padding-bottom: 28px; }
  .col-scroll .fs-col { padding-top: 28px; }
  .thread-col .col-scroll .fs-col { padding-top: 18px; }
  .fs-col { max-width: 768px; margin: 0 auto; padding: 0 20px; }
  /* Fixed header above the chat area (sidebar stays full-height to its left), so
     the name + what-he-does are always in view. */
  .main-area { flex: 1; min-width: 0; display: flex; flex-direction: column; }
  .page-header { flex: none; display: flex; align-items: center; justify-content: space-between; gap: 20px; padding: 13px 24px; border-bottom: 1px solid var(--border); background: var(--bg); }
  .page-header-id { min-width: 0; }
  .page-header h1 { margin: 0; font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif; font-weight: 650; font-size: 20px; }
  .page-header .tagline { margin: 3px 0 0; color: var(--muted); font-size: 13.5px; line-height: 1.45; }
  /* Focused role(s) sit at the right end of the header. */
  .page-header .roles { flex: none; flex-direction: row; align-items: center; gap: 10px; margin: 0; max-width: 46%; }
  .page-header .roles-head { margin: 0; }
  .page-header .role-pill { max-width: 300px; }
  .col-composer { background: var(--bg); border-top: 1px solid var(--border); }
  .col-composer .fs-col { padding-top: 14px; padding-bottom: 18px; }
  /* widen the "/" menu beyond the message column */
  .col-composer .slash { left: 50%; right: auto; transform: translateX(-50%); width: min(1000px, 90vw); }
  /* Centered ChatGPT-style opener for an empty chat (composer in the middle). */
  /* Centred opener: the COMPOSER sits at the vertical middle (equal flex spacers
     above and below); the heading is pinned just above it. */
  .column.empty .col-scroll { flex: 1 1 0; min-height: 0; overflow: visible; display: flex; flex-direction: column; justify-content: flex-end; }
  .column.empty .col-composer { border-top: none; }
  .opener-spacer { display: none; }
  .column.empty .opener-spacer { display: block; flex: 1 1 0; }
  .opener-head { text-align: center; padding: 0 0 18px; }
  .opener-title { margin: 0; font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif; font-weight: 600; font-size: 26px; }
  .opener-sub { margin: 10px auto 0; max-width: 520px; color: var(--muted); font-size: 14.5px; line-height: 1.5; }
  .column:not(.empty) .opener-head { display: none; }
  .starters-zone { flex: none; }
  .column:not(.empty) .starters-zone { display: none; }
  .starters-zone .fs-col { padding-top: 14px; }
  .starters-zone .starters { justify-content: center; }

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
async function streamReply(messages, onText, onJd, signal, threadId, jobContext) {
  const body = { messages };
  if (threadId) body.threadId = threadId;
  if (jobContext) body.jobContext = jobContext; // appended to the SYSTEM prompt server-side
  const res = await fetch(AGENT_URL, {
    method: "POST",
    headers: { "content-type": "application/json" },
    body: JSON.stringify(body),
    signal,
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
    if (/^\s*([-*_])([ \t]*\1){2,}[ \t]*$/.test(line)) {
      // thematic break: ---, ***, ___ (also spaced) -> dividing line
      closeList();
      html += "<hr>";
    } else if ((m = line.match(/^\s*[-*]\s+(.*)$/))) {
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
/** First two initials of a company name, for the avatar fallback. */
function companyInitials(text) {
  const name = text.split(/[/(]/)[0].trim();
  const words = name.split(/\s+/).filter(Boolean);
  const raw = words.length >= 2 ? words[0][0] + words[1][0] : name.slice(0, 2);
  return raw.toUpperCase();
}
/** Deterministic background colour from the name (stable per company). */
function avatarColor(text) {
  const s = text.toLowerCase();
  let h = 0;
  for (let i = 0; i < s.length; i++) h = (h * 31 + s.charCodeAt(i)) >>> 0;
  return `hsl(${h % 360}, 50%, 42%)`;
}
/** A rounded-square initials avatar, used when a company has no logo (or it fails to load). */
function makeAvatar(name) {
  const span = document.createElement("span");
  span.className = "avatar";
  span.setAttribute("aria-hidden", "true");
  span.dataset.initials = companyInitials(name);
  span.style.background = avatarColor(name);
  return span;
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
    const name = el.textContent.trim();
    if (!isCompany(name)) return; // logos / avatars are for companies only
    el.dataset.logo = "1";
    const src = companyLogo(name);
    if (src) {
      const img = new Image();
      img.className = "logo";
      img.alt = "";
      img.onload = () => el.prepend(img);
      img.onerror = () => el.prepend(makeAvatar(name)); // logo no longer available
      img.src = src;
    } else {
      el.prepend(makeAvatar(name)); // company with no logo: initials avatar
    }
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
function createConversation({ scrollEl, messagesEl, input, form, sendBtn, startersEl, onUpdate, onMore, contextMessages = [], lite = false, durable = false, opener = false, onLayout }) {
  const messages = [];
  let abortController = null; // aborts the in-flight SSE reply (main chat or thread)
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
    buildStarters(followupsEl, currentSuggestions, (q) => drill(q, q));
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
    btn.innerHTML = ICON.circleArrowRight;
    btn.addEventListener("click", () => { btn.classList.add("loaded"); drill(query, "More"); });
    const host = bubble.querySelector("p:last-of-type, li:last-of-type") || bubble;
    host.append(" ", btn);
  }

  // For multi-section replies, append a "Tell me more" link after each section
  // (heading + its paragraphs). Clicking opens a side thread via onMore.
  function addSectionMore(bubble, { skipLast = false } = {}) {
    const heads = [...bubble.querySelectorAll(".md-h")];
    heads.forEach((h, i) => {
      // While streaming, the LAST section is still being written — don't give it a
      // "More" until it's complete; earlier sections (a heading follows them) are done.
      if (skipLast && i === heads.length - 1) return;
      let last = h;
      const parts = [h];
      for (let n = h.nextElementSibling; n && !n.classList.contains("md-h"); n = n.nextElementSibling) {
        last = n;
        parts.push(n);
      }
      const topic = h.textContent.trim();
      const sectionText = parts.map((p) => p.textContent.trim()).filter(Boolean).join("\n");
      const link = document.createElement("button");
      link.className = "section-more";
      link.type = "button";
      link.innerHTML = "More " + ICON.circleArrowRight;
      // Mark loaded immediately on click: the reply is captured server-side
      // (waitUntil) so it is never lost, and instant feedback reads better.
      link.addEventListener("click", () => {
        link.classList.add("loaded");
        drill(`Tell me more about ${topic} (in the context of Oliver's career).`, topic, sectionText);
      });
      // If the section ends with a divider (---), keep the divider LAST so it
      // separates this section + its "More" from the next, rather than splitting
      // the content from its own "More".
      if (last.tagName === "HR") last.before(link);
      else last.after(link);
    });
  }

  // Multi-section replies get per-section thread links; otherwise the circle-arrow.
  function applyMore(bubble, moreQuery) {
    if (onMore && bubble.querySelector(".md-h")) addSectionMore(bubble);
    else appendMore(bubble, moreQuery);
  }

  // While the reply streams, surface "More" links on sections that are already
  // complete (a heading follows them); the in-progress last section waits for finalize.
  function applyMoreStreaming(bubble) {
    if (onMore && bubble.querySelector(".md-h")) addSectionMore(bubble, { skipLast: true });
  }

  // Any drill-in (bold entity, section "More", circle-arrow, suggestion chip)
  // opens a NEW thread to the right when onMore is wired (fullscreen); otherwise
  // it continues in-place (the floating panel). sectionText, when present, is the
  // paragraph the link sits under, passed as focused context for the new thread.
  // onLoaded fires only once the spawned thread's reply actually completes (and
  // the thread still exists) — so a "loaded" indicator never lies about content
  // that was interrupted.
  const drill = (question, label, sectionText, onLoaded) =>
    onMore
      ? onMore(question, messages.slice(), label || question, sectionText || null, onLoaded)
      : send(question);
  const drillEntity = (el) => {
    if (!el) return;
    const t = el.textContent.trim();
    drill(`Tell me more about ${t}.`, t);
  };
  messagesEl.addEventListener("click", (e) => drillEntity(e.target.closest?.(".entity")));
  messagesEl.addEventListener("keydown", (e) => {
    if (e.key === "Enter" || e.key === " ") {
      const ent = e.target.closest?.(".entity");
      if (ent) { e.preventDefault(); drillEntity(ent); }
    }
  });

  async function send(text, hidden = false) {
    if (startersEl) startersEl.replaceChildren(); // hide the opener chips, keep the slot
    onLayout?.(false); // chat has started: drop the centered opener, composer to the bottom
    renderFollowups([]);
    messages.push({ role: "user", content: text, ...(hidden ? { hidden: true } : {}) });
    // A hidden seed (a thread's opening "More" click) goes to the model but isn't
    // shown: the thread header already makes the topic obvious.
    if (!hidden) addBubble("user", text);
    toBottom();
    saveState();
    input.value = "";
    input.style.height = ""; // collapse the auto-grown textarea back to one line
    const reply = await respondToLast();
    // If the visitor pasted a job description as text, register it as the focused
    // role AFTER this turn — so this (JD-provision) turn still gets the fit
    // assessment, and future turns carry it as context + the opener reflects it.
    if (!hidden && !lite && isLikelyJobDescription(text)) addJob({ text });
    return reply;
  }

  // Generate the assistant reply for the latest user message already in `messages`.
  // Split out from send() so a failed turn can be retried without re-posting it.
  async function respondToLast() {
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

    // The active job description is sent as SYSTEM-level background context
    // (jobContext) — NOT mixed into the messages — so the visitor's latest message
    // stays the only thing the model responds to. Skip when the JD link is already
    // in the conversation (the server fetches it itself on the JD-provision turn).
    const job = loadActiveJob();
    const hasLink = job?.url && outgoing.some((m) => m.content.includes(job.url));
    const jobContext = job && job.text && !hasLink ? job.text : null;

    let answer = "";
    try {
      // Threads use the durable server-side generation (continues in the
      // background, polled to follow along); the main chat streams live.
      if (durable) return await durableTurn(outgoing, bubble, caret, jobContext);
      abortController = new AbortController();
      await streamReply(
        outgoing,
        (delta) => {
          const stick = atBottom();
          answer += delta;
          bubble.innerHTML = renderMarkdown(stripTokens(answer));
          applyMoreStreaming(bubble);
          bubble.appendChild(caret);
          if (stick) toBottom();
        },
        (jd) => setActiveJob({ url: jd.url, text: jd.text, at: Date.now() }),
        abortController.signal,
        null,
        jobContext,
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
        return clean; // success: the loaded reply
      } else {
        bubble.remove();
        showError();
        return "";
      }
    } catch (err) {
      bubble.remove();
      // An abort is intentional (the thread was closed/replaced) — not an error.
      if (!(err && err.name === "AbortError")) showError();
      return "";
    } finally {
      abortController = null;
      input.disabled = false;
      sendBtn.disabled = false;
      input.focus();
    }
  }

  // A durable thread turn. The generation is owned by a per-thread Durable Object
  // (keyed by a stable id), which streams live and lets us re-attach: opening, an
  // already-running thread, or a finished one all look the same here — we just
  // stream. The DO sends the content-so-far up front, then live deltas. Closing the
  // column aborts our SSE; the DO keeps generating and we re-attach on return.
  async function durableTurn(outgoing, bubble, caret, jobContext) {
    const id = threadStreamId(outgoing, jobContext);
    const renderPartial = (txt) => {
      const stick = atBottom();
      bubble.innerHTML = renderMarkdown(stripTokens(txt));
      applyMoreStreaming(bubble);
      bubble.appendChild(caret);
      if (stick) toBottom();
    };
    let answer = "";
    abortController = new AbortController();
    try {
      await streamReply(
        outgoing,
        (delta) => {
          answer += delta;
          renderPartial(answer);
        },
        (jd) => setActiveJob({ url: jd.url, text: jd.text }),
        abortController.signal,
        id,
        jobContext,
      );
    } catch (err) {
      if (err && err.name === "AbortError") return ""; // column closed; the DO keeps generating
    }
    caret.remove();
    const clean = stripTokens(answer);
    if (clean.trim()) {
      bubble.innerHTML = renderMarkdown(clean);
      decorateEntities(bubble);
      applyMore(bubble, extractMore(answer) || "Tell me more about that.");
      messages.push({ role: "assistant", content: clean });
      renderFollowups(extractSuggestions(answer));
      saveState();
      return clean;
    }
    bubble.remove();
    showError();
    return "";
  }

  // Generic error bubble with an inline Retry that re-runs the last turn.
  function showError() {
    const el = addBubble("error", "Something went wrong. ");
    const retry = document.createElement("button");
    retry.type = "button";
    retry.className = "retry-link";
    retry.textContent = "Retry";
    retry.addEventListener("click", () => {
      el.remove();
      respondToLast();
    });
    el.appendChild(retry);
    toBottom();
  }

  form.addEventListener("submit", (e) => {
    e.preventDefault();
    const text = input.value.trim();
    if (text && !text.startsWith("/")) send(text);
  });

  // Textarea composer: Enter submits, Shift+Enter inserts a newline. When the
  // slash menu is open it owns Enter (item selection), so bail then.
  input.addEventListener("keydown", (e) => {
    if (e.key !== "Enter" || e.shiftKey || e.isComposing) return;
    const slashEl = form.parentElement?.querySelector(".slash");
    if (slashEl && !slashEl.hidden) return;
    e.preventDefault();
    if (form.requestSubmit) form.requestSubmit();
    else form.dispatchEvent(new Event("submit", { cancelable: true, bubbles: true }));
  });
  // Auto-grow the textarea up to its max-height.
  input.addEventListener("input", () => {
    input.style.height = "auto";
    input.style.height = Math.min(input.scrollHeight, 150) + "px";
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

  // Paint the centered opener for the current focused-job state: with a role set,
  // the visitor is a recruiter checking fit, so ask the fit question; otherwise
  // invite a JD. Re-run when the focused job changes.
  function paintOpener() {
    if (!opener) return;
    const job = loadActiveJob();
    const titleEl = scrollEl?.querySelector(".opener-title");
    const subEl = scrollEl?.querySelector(".opener-sub");
    if (titleEl && subEl) {
      titleEl.textContent = job ? "How does Oliver fit this role?" : "Hiring for a position?";
      subEl.textContent = job
        ? "Ask for an honest fit assessment, or drill into any requirement."
        : "Paste the job description or a link";
    }
    if (startersEl) {
      startersEl.replaceChildren();
      // No suggestion chips on the default opener — just the heading + composer.
      // With a role set, offer the fit-oriented prompts.
      if (job) buildStarters(startersEl, FIT_CHIPS, (q) => send(q));
      const zone = startersEl.closest(".starters-zone");
      if (zone) zone.hidden = !job;
    }
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
        if (m.hidden) continue; // the hidden thread seed: kept for context, never shown
        const el = addBubble(m.role, m.content);
        if (m.role === "assistant") applyMore(el, "Tell me more about that."); // re-add thread links on restore
      }
      renderFollowups(chat.suggestions || []);
      toBottom();
      onLayout?.(false);
    } else if (opener) {
      // Centered opener: role-aware heading/sub (live in the column DOM) + chips.
      paintOpener();
      onLayout?.(true);
    } else {
      greet();
      if (startersEl) {
        const cta = document.createElement("div");
        cta.className = "hiring-cta";
        cta.innerHTML =
          '<div class="hiring-cta-title">Hiring for a position?</div>' +
          "<div class=\"hiring-cta-sub\">Paste the job description or a link</div>";
        cta.addEventListener("click", () => input.focus());
        startersEl.appendChild(cta);
        const orLabel = document.createElement("div");
        orLabel.className = "starters-or";
        orLabel.textContent = "Or ask about Oliver:";
        startersEl.appendChild(orLabel);
        buildStarters(startersEl, PERSONAS, (q) => send(q));
      }
      onLayout?.(true);
    }
    // Focus the composer on every load (switching chats / new chat) when visible.
    if (input.getClientRects().length) input.focus();
  }

  const abort = () => {
    try {
      abortController?.abort(); // detach our SSE; a thread's DO keeps generating
    } catch {
      /* ignore */
    }
  };
  return { send, load, abort, paintOpener };
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
        <textarea class="ta" rows="1" placeholder="${placeholder}" autocomplete="off"></textarea>
        <button class="mic" type="button" aria-label="Voice input" hidden>
          <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="9" y="2" width="6" height="11" rx="3"/><path d="M5 10v1a7 7 0 0 0 14 0v-1"/><line x1="12" y1="18" x2="12" y2="22"/></svg>
        </button>
        <button class="send" type="submit" aria-label="Send">${ICON.arrowUp}</button>
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
        <textarea class="ta" rows="1" placeholder="Reply in this thread..." autocomplete="off"></textarea>
        <button class="send" type="submit" aria-label="Send">${ICON.arrowUp}</button>
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
    logConversation(current, titleOf(current)); // beacon for server-side review
  }

  function switchTo(chat) {
    if (chat === current) { onChange?.(); return; } // same chat: just collapse threads
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
        <div class="sidebar-list"></div>
      </aside>
      <div class="main-area">
        <header class="page-header">
          <div class="page-header-id">
            <h1>Oliver Searle-Barnes</h1>
            <p class="tagline">Hands-on CTO and Staff Engineer. Two decades shipping production software, most recently agentic AI.</p>
          </div>
          <div class="roles" hidden></div>
        </header>
        <div class="columns"></div>
      </div>
    </div>
  `;

  const columnsEl = root.querySelector(".columns");
  const listEl = root.querySelector(".sidebar-list");
  const rolesEl = root.querySelector(".roles");
  const genId = () => Date.now().toString(36) + Math.random().toString(36).slice(2, 7);
  const syncMulti = () => columnsEl.classList.toggle("multi", columns.length > 1);
  const scrollToEnd = () =>
    requestAnimationFrame(() => columnsEl.scrollTo({ left: columnsEl.scrollWidth, behavior: "smooth" }));
  const scrollToStart = () => columnsEl.scrollTo({ left: 0, behavior: "smooth" });

  // ---- state: a chat IS its node tree ----
  // chat = { id, title, focusedJobId, nodes:[node], updatedAt }; node = { id,
  // parentId, position, title, seed, sectionText, messages[], suggestions[] }.
  // columns (the live UI) map 1:1 to current.nodes (root = main, rest = open chain).
  const store = loadChats();
  let chats = (store.chats || []).map(normaliseChat);
  let current = null;
  const columns = []; // [{ el, convo, node }]

  function normaliseChat(c) {
    // Accept either the tree shape or a legacy {messages} shape; always end with nodes[].
    if (Array.isArray(c.nodes) && c.nodes.length) return c;
    const root = { id: c.id, parentId: null, position: 0, title: "", seed: "", sectionText: "", messages: c.messages || [], suggestions: c.suggestions || [] };
    return { id: c.id, title: c.title || "", focusedJobId: c.focusedJobId || null, nodes: [root], updatedAt: c.updatedAt || Date.now() };
  }
  function titleOf(chat) {
    if (chat.title) return chat.title;
    const first = (chat.nodes[0]?.messages || []).find((m) => m.role === "user");
    const t = (first ? first.content : "New chat").replace(/\s+/g, " ").trim();
    return t.length > 42 ? t.slice(0, 42) + "…" : t || "New chat";
  }

  function renderList() {
    listEl.replaceChildren();
    for (const chat of chats) {
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
      del.addEventListener("click", (e) => { e.stopPropagation(); removeChat(chat); });
      item.append(title, del);
      item.addEventListener("click", () => switchTo(chat));
      listEl.appendChild(item);
    }
  }

  // Serialise the live columns back onto `current`, persist (localStorage), and
  // beacon the whole tree to D1. Called after every message / structural change.
  function persist() {
    if (!current) return;
    current.nodes = columns.map((c, i) => {
      c.node.position = i;
      return c.node;
    });
    current.title = titleOf(current);
    current.focusedJobId = loadJobsState().focusedId;
    current.updatedAt = Date.now();
    if (current.nodes[0]?.messages?.length && !chats.includes(current)) chats.unshift(current);
    chats.sort((a, b) => (b.updatedAt || 0) - (a.updatedAt || 0));
    saveChats({ chats, currentId: current.id });
    logConversation(current, current.title);
    renderList();
  }

  // Build a column (DOM + conversation) bound to a node. Main column carries the
  // intro + slash composer; thread columns are lite with a header.
  function makeColumn(node, { main = false, ctx = [] } = {}) {
    const el = document.createElement("div");
    if (main) {
      el.className = "column empty";
      el.innerHTML = `
        <div class="col-scroll"><div class="fs-col">
          <div class="opener-head">
            <h2 class="opener-title">Hiring for a position?</h2>
            <p class="opener-sub">Paste the job description or a link</p>
          </div>
          <div class="messages"></div>
        </div></div>
        <div class="col-composer"><div class="fs-col">${composerHTML("Ask anything about Oliver...")}</div></div>
        <div class="starters-zone"><div class="fs-col"><div class="starters"></div></div></div>
        <div class="opener-spacer"></div>`;
    } else {
      el.className = "column thread-col";
      el.innerHTML = `
        <div class="thread-col-head">
          <button class="thread-col-back" type="button" title="Back" aria-label="Close thread">${ICON.arrowLeft}</button>
          <span class="thread-col-title"></span>
          <button class="thread-col-close" type="button" aria-label="Close thread">${ICON.x}</button>
        </div>
        <div class="col-scroll"><div class="fs-col"><div class="messages"></div></div></div>
        <div class="col-composer"><div class="fs-col">${threadComposerHTML()}</div></div>`;
      el.querySelector(".thread-col-title").textContent = node.title || "Thread";
    }
    const form = el.querySelector(".form");
    const colObj = { el, convo: null, node };
    colObj.convo = createConversation({
      scrollEl: el.querySelector(".col-scroll"),
      messagesEl: el.querySelector(".messages"),
      input: form.querySelector("textarea"),
      form,
      sendBtn: form.querySelector(".send"),
      startersEl: main ? el.querySelector(".starters") : null,
      lite: !main,
      durable: !main, // threads use the durable server-side generation
      opener: main, // main column gets the centered opener when empty
      onLayout: main ? (empty) => el.classList.toggle("empty", empty) : undefined,
      contextMessages: ctx,
      onUpdate: (m, s) => {
        node.messages = m;
        node.suggestions = s;
        persist();
      },
      onMore: (q, c, t, st, ol) => spawnFrom(colObj, q, c, t, st, ol),
    });
    if (!main) {
      const closeThis = () => closeFrom(colObj);
      el.querySelector(".thread-col-close").addEventListener("click", closeThis);
      el.querySelector(".thread-col-back").addEventListener("click", closeThis);
    }
    return colObj;
  }

  const ancestorCtx = () => columns.flatMap((c) => c.node.messages || []);

  // Open a new thread column to the right of `parentCol` (truncating any to its right).
  function spawnFrom(parentCol, question, ctx, title, sectionText, onLoaded) {
    const idx = columns.indexOf(parentCol);
    if (idx < 0) return;
    columns.splice(idx + 1).forEach((c) => {
      c.convo.abort();
      c.el.remove();
    });
    const seed = sectionText
      ? `Go deeper, expanding specifically on this part of your previous answer (in the context of Oliver's career): "${sectionText}"`
      : question;
    const node = { id: genId(), parentId: parentCol.node.id, position: idx + 1, title: title || "Thread", seed, sectionText: sectionText || "", messages: [], suggestions: [] };
    const col = makeColumn(node, { ctx: ancestorCtx() });
    columns.push(col);
    // Always play the open animation (even re-opening an already-loaded thread):
    // paint at opacity 0, force a reflow, then transition in.
    col.el.classList.add("entering");
    columnsEl.appendChild(col.el);
    void col.el.offsetWidth;
    col.el.classList.remove("entering");
    syncMulti();
    col.convo.send(seed, /* hidden */ true).then((reply) => {
      if (reply && onLoaded && columns.includes(col)) onLoaded();
    });
    persist();
    scrollToEnd();
  }

  // Fade + collapse columns from `colObj` (inclusive) to the end, then remove.
  function closeFrom(colObj, animate = true) {
    const i = columns.indexOf(colObj);
    if (i < 1) return; // never close the main column
    const removed = columns.splice(i);
    removed.forEach((c) => c.convo.abort()); // stop in-flight replies (server still caches via waitUntil)
    syncMulti();
    if (animate) {
      removed.forEach((c) => c.el.classList.add("leaving"));
      setTimeout(() => removed.forEach((c) => c.el.remove()), 220);
    } else {
      removed.forEach((c) => c.el.remove());
    }
    persist();
    scrollToEnd();
  }
  const closeRightmost = () => columns.length > 1 && closeFrom(columns[columns.length - 1]);

  // Render a chat by rebuilding its column chain from the stored nodes.
  function openChat(chat) {
    current = chat;
    columns.forEach((c) => c.convo?.abort());
    columns.length = 0;
    columnsEl.replaceChildren();
    const nodes = chat.nodes && chat.nodes.length ? chat.nodes : [{ id: chat.id, parentId: null, position: 0, title: "", seed: "", sectionText: "", messages: [], suggestions: [] }];
    nodes.forEach((node, i) => {
      const col = makeColumn(node, { main: i === 0, ctx: ancestorCtx() });
      columns.push(col);
      columnsEl.appendChild(col.el);
      const hasReply = (node.messages || []).some((m) => m.role === "assistant" && m.content.trim());
      if (i === 0 || hasReply) {
        col.convo.load({ messages: node.messages || [], suggestions: node.suggestions || [] });
      } else {
        // Thread interrupted before its reply landed: re-issue the seed (cache-hit).
        col.convo.send(node.seed || node.title, true);
      }
    });
    syncMulti();
    columnsEl.scrollTo({ left: columnsEl.scrollWidth });
    renderList();
  }

  function newChat() {
    const node = { id: genId(), parentId: null, position: 0, title: "", seed: "", sectionText: "", messages: [], suggestions: [] };
    const chat = { id: node.id, title: "", focusedJobId: loadJobsState().focusedId, nodes: [node], updatedAt: Date.now() };
    openChat(chat);
    scrollToStart();
  }
  function switchTo(chat) {
    if (chat === current) {
      // same chat: collapse threads back to the main column
      if (columns.length > 1) closeFrom(columns[1]);
      scrollToStart();
      return;
    }
    openChat(chat);
    saveChats({ chats, currentId: chat.id });
    scrollToStart();
  }
  function removeChat(chat) {
    chats = chats.filter((c) => c !== chat);
    saveChats({ chats, currentId: current?.id });
    if (chat === current) {
      chats.length ? openChat(chats[0]) : newChat();
    } else {
      renderList();
    }
  }

  root.querySelector(".sidebar-new").addEventListener("click", newChat);

  // Escape closes the rightmost thread (unless the "/" menu is open, which owns it).
  document.addEventListener("keydown", (e) => {
    if (e.key !== "Escape") return;
    if (root.querySelector(".slash:not([hidden])")) return;
    if (columns.length > 1) { e.preventDefault(); closeRightmost(); }
  });

  // Left/Right arrows scroll between panes when threads are open. We only defer to
  // the cursor when the composer actually has text to move through; an empty
  // composer (the usual browsing state) lets the arrows page across panes.
  document.addEventListener("keydown", (e) => {
    if (e.key !== "ArrowLeft" && e.key !== "ArrowRight") return;
    const ae = root.getRootNode().activeElement;
    const typing = ae && (ae.tagName === "TEXTAREA" || ae.tagName === "INPUT") && ae.value.trim() !== "";
    if (typing || columns.length < 2) return;
    e.preventDefault();
    const pane = columnsEl.clientWidth / 2;
    columnsEl.scrollBy({ left: e.key === "ArrowLeft" ? -pane : pane }); // CSS scroll-behavior animates it
  });

  // ---- initial paint (localStorage) then reconcile with D1 (source of truth) ----
  const startId = store.currentId;
  const startChat = chats.find((c) => c.id === startId) || chats[0];
  if (startChat) openChat(startChat);
  else newChat();

  (async () => {
    try {
      const data = await fetch(`${STATE_URL}?visitor=${encodeURIComponent(visitorId())}`).then((r) => r.json());
      // Jobs: D1 is the source of truth, but NEVER let an empty / not-yet-synced D1
      // wipe a locally-held role (the bug where a just-provided JD vanished). Union
      // D1 with local, and re-sync to D1 if local carried a role D1 hadn't stored.
      {
        const local = loadJobsState();
        const d1Jobs = data && Array.isArray(data.jobs) ? data.jobs : [];
        const byId = new Map(d1Jobs.map((j) => [j.id, j]));
        let added = false;
        for (const j of local.jobs) if (!byId.has(j.id)) { byId.set(j.id, j); added = true; }
        const jobs = [...byId.values()];
        let focusedId = (data && data.focusedJobId) || local.focusedId || null;
        if (!jobs.some((j) => j.id === focusedId)) focusedId = jobs.length ? jobs[jobs.length - 1].id : null;
        persistJobs({ jobs, focusedId }, { sync: added });
      }
      if (data && Array.isArray(data.chats) && data.chats.length) {
        const d1chats = data.chats.map(normaliseChat);
        const started = !!current && !!current.nodes?.[0]?.messages?.length;
        const inD1 = d1chats.find((c) => c.id === current?.id);
        if (started && !inD1) {
          // The visitor began a fresh chat before /state returned — keep it.
          chats = [current, ...d1chats.filter((c) => c.id !== current.id)];
          saveChats({ chats, currentId: current.id });
          renderList();
        } else {
          chats = d1chats;
          saveChats({ chats, currentId: current?.id });
          openChat(inD1 || chats[0]);
        }
      }
    } catch {
      /* offline: localStorage paint stands */
    }
  })();

  // The "Roles" list: every job description the visitor has added. Click a pill
  // to FOCUS it (the focused role is injected as context into chats); the × removes
  // it. State is mirrored to D1.
  function renderRoles(state) {
    rolesEl.replaceChildren();
    const jobs = state.jobs || [];
    if (!jobs.length) {
      rolesEl.hidden = true;
      return;
    }
    rolesEl.hidden = false;
    const head = document.createElement("div");
    head.className = "roles-head";
    head.textContent = jobs.length > 1 ? "Roles" : "Role";
    rolesEl.append(head);
    for (const j of jobs) {
      const focused = j.id === state.focusedId;
      const pill = document.createElement("div");
      pill.className = "role-pill" + (focused ? " focused" : "");
      const dot = document.createElement("span");
      dot.className = "role-dot";
      const label = document.createElement("button");
      label.className = "role-label";
      label.type = "button";
      label.textContent = jobLabel(j);
      label.title = focused ? "Focused — used as context in chats" : "Click to focus this role";
      label.addEventListener("click", () => focusJob(j.id));
      const x = document.createElement("button");
      x.className = "role-x";
      x.type = "button";
      x.setAttribute("aria-label", "Remove role");
      x.innerHTML = ICON.x;
      x.addEventListener("click", (e) => {
        e.stopPropagation();
        removeJob(j.id);
      });
      pill.append(dot, label, x);
      rolesEl.append(pill);
    }
  }
  renderRoles(loadJobsState());
  onJobsChange((s) => {
    renderRoles(s);
    // If the main column is sitting on the centered opener, swap it to the
    // role-aware question (or back) as roles are focused / removed.
    const main = columns[0];
    if (main && main.el.classList.contains("empty")) main.convo.paintOpener?.();
  });

  columns[0]?.el.querySelector("textarea")?.focus();
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
  const input = form.querySelector("textarea");
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

// Read-only admin replay: browse a visitor's conversations in the REAL widget UI
// (same columns / bubbles / threads), no composer, no LLM, no writes. Gated by an
// admin password sent as the X-Admin-Pass header to the worker's /admin/api/*.
function mountAdmin(root) {
  document.body.style.display = "none";
  document.documentElement.style.overflow = "hidden";
  const ADMIN_API = AGENT_URL.replace(/\/chat$/, "/admin/api");
  let pass = "";
  try {
    pass = sessionStorage.getItem("cv-agent-admin-pass") || "";
  } catch {
    /* ignore */
  }

  root.innerHTML = `<div class="admin-app"><div class="admin-bar"></div><div class="admin-body"></div></div>`;
  const barEl = root.querySelector(".admin-bar");
  const bodyEl = root.querySelector(".admin-body");
  const api = (p) => fetch(ADMIN_API + p, { headers: { "x-admin-pass": pass } });
  const setBar = (...parts) => {
    barEl.replaceChildren();
    parts.forEach((p, i) => {
      if (i) {
        const sep = document.createElement("span");
        sep.className = "admin-crumb-sep";
        sep.textContent = "/";
        barEl.append(sep);
      }
      barEl.append(p);
    });
  };
  const crumb = (text, onClick) => {
    const b = document.createElement(onClick ? "button" : "span");
    b.className = "admin-crumb" + (onClick ? " link" : "");
    b.textContent = text;
    if (onClick) b.addEventListener("click", onClick);
    return b;
  };

  const rel = (ts) => {
    if (!ts) return "";
    const d = Math.floor((Date.now() - ts) / 1000);
    if (d < 60) return "just now";
    if (d < 3600) return Math.floor(d / 60) + "m ago";
    if (d < 86400) return Math.floor(d / 3600) + "h ago";
    return Math.floor(d / 86400) + "d ago";
  };

  function bubble(m) {
    const b = document.createElement("div");
    b.className = "msg " + (m.role === "assistant" ? "assistant" : "user");
    if (m.role === "assistant") {
      b.innerHTML = renderMarkdown(m.content || "");
      decorateEntities(b);
    } else {
      b.textContent = m.content || "";
    }
    return b;
  }

  // Highlight the drill-ins the visitor actually opened (read-only only). A child
  // thread's title matches the heading/entity it was opened from; sectionText
  // present means a section "More", absent means a bolded-term drill.
  function markReplayVisited(b, children) {
    if (!children || !children.length) return;
    const sectionTitles = new Set(children.filter((c) => c.sectionText).map((c) => (c.title || "").trim()).filter(Boolean));
    const entityTitles = new Set(children.filter((c) => !c.sectionText).map((c) => (c.title || "").trim()).filter(Boolean));
    b.querySelectorAll(".md-h").forEach((h) => {
      if (!sectionTitles.has(h.textContent.trim())) return;
      h.classList.add("replay-visited");
      let last = h;
      for (let n = h.nextElementSibling; n && !n.classList.contains("md-h"); n = n.nextElementSibling) last = n;
      const mk = document.createElement("div");
      mk.className = "section-more loaded replay-more";
      mk.innerHTML = "Opened " + ICON.circleArrowRight;
      if (last.tagName === "HR") last.before(mk);
      else last.after(mk);
    });
    b.querySelectorAll(".entity").forEach((e) => {
      if (entityTitles.has(e.textContent.trim())) e.classList.add("replay-visited");
    });
  }

  const section = (title) => {
    const s = document.createElement("section");
    s.className = "admin-section";
    const h = document.createElement("h3");
    h.textContent = title;
    s.appendChild(h);
    return s;
  };
  const esc = (s) => String(s).replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");

  // ---- auth gate (in front of everything) ----
  function showAuth(failed) {
    setBar(crumb("Admin"));
    bodyEl.replaceChildren();
    const gateForm = document.createElement("form");
    gateForm.className = "admin-gate";
    gateForm.innerHTML = `
      <div class="admin-gate-title">Admin access</div>
      <input class="admin-gate-input" type="password" placeholder="Password" autocomplete="current-password" />
      <button class="admin-gate-btn" type="submit">Enter</button>
      ${failed ? '<div class="admin-gate-err">Incorrect password.</div>' : ""}`;
    bodyEl.appendChild(gateForm);
    const inp = gateForm.querySelector("input");
    inp.focus();
    gateForm.addEventListener("submit", async (e) => {
      e.preventDefault();
      pass = inp.value;
      try {
        sessionStorage.setItem("cv-agent-admin-pass", pass);
      } catch {
        /* ignore */
      }
      const r = await api("/visitors").catch(() => null);
      if (r && r.ok) showUsers(await r.json());
      else showAuth(true);
    });
  }
  async function gate() {
    const r = pass ? await api("/visitors").catch(() => null) : null;
    if (r && r.ok) showUsers(await r.json());
    else showAuth(false);
  }

  // ---- users list ----
  function showUsers(list) {
    setBar(crumb("Visitors"));
    bodyEl.replaceChildren();
    const scroll = document.createElement("div");
    scroll.className = "admin-scroll";
    const panel = document.createElement("div");
    panel.className = "admin-panel";
    if (!list.length) {
      panel.innerHTML = '<div class="admin-empty">No visitors yet.</div>';
    } else {
      for (const v of list) {
        const card = document.createElement("button");
        card.className = "admin-card";
        const loc = document.createElement("div");
        loc.className = "ac-loc";
        loc.textContent = v.location || "Unknown location";
        const meta = document.createElement("div");
        meta.className = "ac-meta";
        meta.textContent = `${v.chats} conversation${v.chats === 1 ? "" : "s"} · last active ${rel(v.lastSeen)}`;
        card.append(loc, meta);
        const roles = Array.isArray(v.roles) ? v.roles : [];
        if (roles.length) {
          const chips = document.createElement("div");
          chips.className = "admin-roles";
          for (const t of roles) {
            const chip = document.createElement("span");
            chip.className = "admin-role";
            chip.textContent = t;
            chips.appendChild(chip);
          }
          card.appendChild(chips);
        }
        card.addEventListener("click", () => openUser(v));
        panel.appendChild(card);
      }
    }
    scroll.appendChild(panel);
    bodyEl.appendChild(scroll);
  }

  async function openUser(v) {
    setBar(crumb("Visitors", gate), crumb(v.location || v.id));
    bodyEl.replaceChildren();
    const loading = document.createElement("div");
    loading.className = "admin-empty pad";
    loading.textContent = "Loading…";
    bodyEl.appendChild(loading);
    const r = await api("/visitor?id=" + encodeURIComponent(v.id)).catch(() => null);
    if (!r || !r.ok) {
      loading.textContent = "Failed to load.";
      return;
    }
    showSummary(v, await r.json());
  }

  // ---- per-user summary: roles + conversations + what they explored ----
  function showSummary(v, state) {
    setBar(crumb("Visitors", gate), crumb(v.location || v.id));
    bodyEl.replaceChildren();
    const scroll = document.createElement("div");
    scroll.className = "admin-scroll";
    const panel = document.createElement("div");
    panel.className = "admin-panel";

    const head = document.createElement("div");
    head.className = "admin-sum-head";
    head.innerHTML = `<h2>${esc(v.location || "Unknown location")}</h2>
      <div class="admin-sum-sub">visitor ${esc((v.id || "").slice(0, 10))} · last active ${rel(v.lastSeen)}</div>`;
    panel.appendChild(head);

    if (state.jobs && state.jobs.length) {
      const sec = section("Roles evaluated");
      const chips = document.createElement("div");
      chips.className = "admin-roles";
      for (const j of state.jobs) {
        const chip = document.createElement(j.url ? "a" : "span");
        chip.className = "admin-role" + (j.id === state.focusedJobId ? " focused" : "");
        chip.textContent = j.title || "role";
        if (j.url) {
          chip.href = j.url;
          chip.target = "_blank";
          chip.rel = "noopener";
        }
        chips.appendChild(chip);
      }
      sec.appendChild(chips);
      panel.appendChild(sec);
    }

    const sec = section(`Conversations (${(state.chats || []).length})`);
    if (!state.chats || !state.chats.length) {
      const e = document.createElement("div");
      e.className = "admin-empty";
      e.textContent = "No conversations.";
      sec.appendChild(e);
    } else {
      for (const chat of state.chats) {
        const row = document.createElement("button");
        row.className = "admin-conv";
        const title = document.createElement("div");
        title.className = "acv-title";
        title.textContent = chat.title || "(untitled)";
        row.appendChild(title);
        const explored = (chat.nodes || []).filter((n) => n.parentId).map((n) => n.title).filter(Boolean);
        if (explored.length) {
          const ex = document.createElement("div");
          ex.className = "acv-explored";
          ex.textContent = "Explored: " + explored.join(" · ");
          row.appendChild(ex);
        }
        const open = document.createElement("div");
        open.className = "acv-open";
        open.textContent = "Open as they saw it →";
        row.appendChild(open);
        row.addEventListener("click", () => showReplay(v, state, chat));
        sec.appendChild(row);
      }
    }
    panel.appendChild(sec);
    scroll.appendChild(panel);
    bodyEl.appendChild(scroll);
  }

  // ---- read-only replay: the real widget (side nav + columns) ----
  function showReplay(v, state, chat) {
    setBar(crumb("Visitors", gate), crumb(v.location || v.id, () => showSummary(v, state)), crumb(chat.title || "conversation"));
    bodyEl.replaceChildren();
    const wrap = document.createElement("div");
    wrap.className = "admin-replay";

    // side nav: the visitor's roles (read-only) + their conversation list
    const side = document.createElement("aside");
    side.className = "sidebar";
    if (state.jobs && state.jobs.length) {
      const roles = document.createElement("div");
      roles.className = "roles";
      const rh = document.createElement("div");
      rh.className = "roles-head";
      rh.textContent = state.jobs.length > 1 ? "Roles" : "Role";
      roles.appendChild(rh);
      for (const j of state.jobs) {
        const pill = document.createElement("div");
        pill.className = "role-pill" + (j.id === state.focusedJobId ? " focused" : "");
        const dot = document.createElement("span");
        dot.className = "role-dot";
        const label = document.createElement("span");
        label.className = "role-label";
        label.textContent = j.title || "role";
        pill.append(dot, label);
        roles.appendChild(pill);
      }
      side.appendChild(roles);
    }
    const list = document.createElement("div");
    list.className = "sidebar-list";
    for (const c of state.chats || []) {
      const item = document.createElement("div");
      item.className = "sidebar-item" + (c === chat ? " active" : "");
      const title = document.createElement("span");
      title.className = "sidebar-title";
      title.textContent = c.title || "(untitled)";
      item.appendChild(title);
      item.addEventListener("click", () => showReplay(v, state, c));
      list.appendChild(item);
    }
    side.appendChild(list);
    wrap.appendChild(side);

    const cols = document.createElement("div");
    cols.className = "columns";
    const nodes = chat.nodes && chat.nodes.length ? chat.nodes : [{ messages: [] }];
    nodes.forEach((node, i) => {
      const col = document.createElement("div");
      col.className = i === 0 ? "column" : "column thread-col";
      if (i > 0) {
        const h = document.createElement("div");
        h.className = "thread-col-head";
        const t = document.createElement("span");
        t.className = "thread-col-title";
        t.textContent = node.title || "Thread";
        h.appendChild(t);
        col.appendChild(h);
      }
      const sc = document.createElement("div");
      sc.className = "col-scroll";
      const fscol = document.createElement("div");
      fscol.className = "fs-col";
      const msgs = document.createElement("div");
      msgs.className = "messages";
      const children = nodes.filter((n) => n.parentId === node.id);
      (node.messages || []).filter((m) => !m.hidden).forEach((m) => {
        const b = bubble(m);
        if (m.role === "assistant") markReplayVisited(b, children);
        msgs.appendChild(b);
      });
      fscol.appendChild(msgs);
      sc.appendChild(fscol);
      col.appendChild(sc);
      cols.appendChild(col);
    });
    cols.classList.toggle("multi", nodes.length > 1);
    wrap.appendChild(cols);
    bodyEl.appendChild(wrap);
  }

  gate();
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

  const path = window.location.pathname.replace(/\/+$/, "");
  if (path === "/admin") mountAdmin(container);
  else if (path === "" || path === "/index.html") mountFullscreen(container);
  else mountFloating(container);
}

mount();
