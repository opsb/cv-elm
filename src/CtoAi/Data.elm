module CtoAi.Data exposing (portrait)

{-| Founding-CTO, AI-focused portrait CV, rendered through the shared two-page
`Cv.PortraitView` (the same layout as the AI-platform, Engineering Manager,
Node, and Elixir cuts). Served at `/cto-ai` for a founding CTO / co-founder seat
on an AI / agentic product, the leader who sets technical direction, hires and
leads the team, and stays hands-on in the code.

It forks the `/ai-platform-lead` (`AiPortrait.Data`) cut and lifts it from
"hands-on Tech Lead" altitude to founding-CTO altitude: the underlying positions
are byte-for-byte identical and honesty-bound exactly as that cut (never managed
more than five and not recently; XP Flow was a founding-engineer / tech-lead
seat on a cross-functional team; the Boulevard App Store / GraphQL rate limiter
/ authorization / HIPAA work is genuinely claimable; the M&S sale is real with
no fabricated DD). Only the framing layer changes:

  - tagline: Founding CTO, AI & agentic engineering
  - profile leads with founding + leading the team + staying in the code,
    AI-native by default
  - highlights foreground founding / 0->1, then agentic AI, then the platform /
    compliance spine
  - skill groups lead with AI & Agentic Engineering, then Leadership & Founding
    (bumped up from the AI cut's trailing position), then Architecture &
    Platform, Production & Reliability, Security & Compliance, and a trailing
    Stack & Data line

-}

import Cv.PortraitView exposing (PortraitCv, SkillGroup)
import Cv.Types exposing (CvData, Institution, Position, Project)


{-| Assemble the `PortraitCv` the shared `Cv.PortraitView` renders. Single
variant: this cut exists to be aimed squarely at the founding-CTO AI reader.
-}
portrait : PortraitCv
portrait =
    { cv = cv
    , highlights = highlights
    , skillGroups = skillGroups
    }


cv : CvData
cv =
    { pdfFileName = "Oliver-Searle-Barnes-Founding-CTO-AI.pdf"
    , name = "Oliver Searle-Barnes"
    , tagline = "Founding CTO · AI & Agentic Engineering"
    , email = "oliver@opsb.co.uk  ·  linkedin.com/in/oliversearlebarnes  ·  github.com/opsb"
    , profileTitle = "Profile"
    , executiveProfile = executiveProfile
    , coreCapabilities = coreCapabilities
    , technicalSkills = "TypeScript, JavaScript, Node.js, NestJS, React, Next.js, GraphQL, Python, Elixir, Phoenix, PostgreSQL, Redis, DynamoDB, RabbitMQ, AWS / Terraform, LangChain / LangGraph"
    , leadingPosition = xpflow
    , secondPosition = Just tastermonial
    , thoughtclay = boulevard
    , otherPositions = [ vorwerk, ctm, twentyBn, liqid, zapnito, lytbulb, myschooldirect, informa, nutshell ]
    , education = education
    }


{-| Short placement statement; the showing-off lives in the `highlights` strip.
Leads with the founding-CTO shape this reader rewards: starting things, leading
the team, and staying in the code, AI-native by default.
-}
executiveProfile : List String
executiveProfile =
    [ "Founding CTO and hands-on engineer with two decades shipping production software, from zero-to-one through scale-ups like Boulevard and Zapnito. I set the direction, lead the team, and stay in the code." ]


{-| Marquee, mostly-quantified wins surfaced as a Selected Highlights strip
under the summary. Re-weighted for the founding-CTO AI reader: founding / 0->1
first, then agentic AI shipped fast, then the platform / compliance spine, then
the hands-on, AI-native way of working.
-}
highlights : List String
highlights =
    [ "Took Alfie from zero to one as XP Flow's founding engineer: an agentic LLM product for partner recruiting, grown to 200 brands and 30k affiliates."
    , "Multi-time CTO and co-founder, including a school-commerce platform acquired by Marks & Spencer, leading engineering from the first hire upward."
    , "At Boulevard, a health-and-beauty unicorn, built reusable platform capabilities: an App Store, a GraphQL rate limiter, and the authorization model."
    , "Rebuilt CompareTheMarket's Bean as a personal finance manager, integrating 15 UK high-street banks via Open Banking under FCA authorisation, launched to tens of thousands."
    ]


{-| Unused by the portrait layout (which renders `skillGroups`) but required by
`CvData`. Kept meaningful in case a future ATS / linear-list view consumes it.
-}
coreCapabilities : List String
coreCapabilities =
    [ "Founding engineer / CTO, 0->1 delivery"
    , "Agentic AI & LLM delivery (LangChain / LangGraph)"
    , "Agentic coding (Claude Code / Codex) as everyday leverage"
    , "Hiring, mentoring & technical direction"
    , "Platform primitives over per-client forks"
    , "Production reliability, observability & safe releases"
    , "Security, authorization & compliance (HIPAA / FCA)"
    , "Hands-on technical leadership, close to the code"
    ]


{-| Grouped Core Capabilities rendered as labelled, comma-separated lines. Leads
with AI & Agentic Engineering, then Leadership & Founding (lifted from the AI
cut's trailing slot), then the platform / reliability / compliance spine, then a
trailing stack line so there is no standalone Technical Skills line.
-}
skillGroups : List SkillGroup
skillGroups =
    [ ai, leadership, architecture, reliability, security, stack ]


ai : SkillGroup
ai =
    { name = "AI & Agentic Engineering"
    , skills =
        [ "Agentic LLM pipelines (LangChain / LangGraph)"
        , "Tool-calling agents on real systems"
        , "Evals & prompt-regression harnesses"
        , "Claude Code & Codex (daily)"
        ]
    }


leadership : SkillGroup
leadership =
    { name = "Leadership & Founding"
    , skills =
        [ "Founding engineer / CTO, 0->1 delivery"
        , "Hiring, mentoring & hands-on player-coach"
        ]
    }


architecture : SkillGroup
architecture =
    { name = "Architecture & Platform"
    , skills =
        [ "System design & API platforms"
        , "Primitives over per-client forks"
        , "Code review, Testing & BDD"
        , "CI/CD & continuous delivery"
        ]
    }


reliability : SkillGroup
reliability =
    { name = "Production & Reliability"
    , skills =
        [ "Observability (OpenTelemetry / APM)"
        , "Performance & scaling under load"
        , "Safe releases & fast prod-to-fix loops"
        ]
    }


security : SkillGroup
security =
    { name = "Security & Compliance"
    , skills =
        [ "Authorization & access control"
        , "HIPAA (audit, encryption, masking)"
        , "FCA / Open Banking delivery"
        ]
    }


stack : SkillGroup
stack =
    { name = "Stack & Data"
    , skills =
        [ "TypeScript / Node.js / NestJS"
        , "React / Next.js"
        , "GraphQL & REST"
        , "Python"
        , "Elixir / Phoenix"
        , "Postgres / Redis / DynamoDB"
        , "ElectricSQL / PowerSync"
        , "AWS / Terraform / Vercel"
        ]
    }


role : { title : String, company : String, dates : String, scope : String, stack : List String, bullets : List String } -> Position
role r =
    { title = r.title
    , location = ""
    , company = r.company
    , dates = r.dates
    , scope = r.scope
    , stack = r.stack
    , overview = Nothing
    , projects =
        [ { name = r.company, dates = r.dates, overview = "", talkingPoints = r.bullets } ]
    }


xpflow : Position
xpflow =
    role
        { title = "CPO / Founding Engineer"
        , company = "XP Flow (alfie.io)"
        , dates = "Jan 2024 – Apr 2026"
        , scope = "CPO and founding engineer on an agentic AI product; set the product direction and architecture, and owned the TypeScript / Node stack end to end."
        , stack = [ "Next.js", "React", "TypeScript", "Node.js", "LangChain / LangGraph", "Postgres", "Redis" ]
        , bullets =
            [ "Hired and led a cross-functional team of designer, engineers, and sales, running 1:1s and the hiring loop."
            , "Built Alfie, a fleet of LLM agents that discover, evaluate, and reach out to affiliate partners on behalf of growth teams: an agentic learning loop on LangChain / LangGraph with a regression-test harness for prompts."
            , "Built a custom chat stack with in-chat widgets and tool-calling UI, surfacing agent state in real time."
            , "Designed the brand-to-affiliate discovery engine: a scraping pipeline feeding multi-stage LLM evaluation, with Stripe and Everflow integrations."
            , "Built the full-stack Next.js / TypeScript application end to end."
            ]
        }


tastermonial : Position
tastermonial =
    role
        { title = "Interim CTO"
        , company = "Tastermonial"
        , dates = "Jun 2023 – Dec 2023"
        , scope = "Interim CTO; owned the engineering function for a consumer-health startup."
        , stack = [ "Flutter", "ElectricSQL", "PowerSync", "Postgres" ]
        , bullets =
            [ "Rebuilt a failing iOS MVP into a cross-platform Flutter app on iOS and Android with offline-first sync, migrating from ElectricSQL's CRDT engine to PowerSync."
            ]
        }


{-| Boulevard, the most recent consulting engagement, occupies the shared view's
page-break slot (the `thoughtclay` field on `CvData`); the rest of the
engagements lead `otherPositions` on page 2. Its scope leads with the
client-needs-into-platform-capabilities framing.
-}
boulevard : Position
boulevard =
    role
        { title = "Staff Engineer (Senior Engineer 2)"
        , company = "Boulevard"
        , dates = "Oct 2021 – Jun 2023"
        , scope = "Senior API-platform engineer at this health-and-beauty unicorn, turning client and developer needs into reusable, cross-cutting platform capabilities."
        , stack = [ "GraphQL", "React", "NestJS / Node.js", "Elixir / Phoenix", "Postgres", "AWS / Terraform" ]
        , bullets =
            [ "Shipped a platform-wide GraphQL rate limiter with per-application quotas, and led HIPAA compliance with audit logging, encryption, and field masking."
            , "Designed and built the platform authorization model."
            , "Extended the App Store and developer portal, and introduced a NestJS QuickBooks integration and Zapier integration."
            , "Added OpenTelemetry APM and optimised database performance, scaling the platform under growing load."
            ]
        }


vorwerk : Position
vorwerk =
    role
        { title = "Tech Lead"
        , company = "Vorwerk"
        , dates = "Apr – Sep 2021"
        , scope = "Tech lead on a 6-engineer team, bootstrapping the backend at this German consumer-appliance giant, delivering the IoT cloud services for a new commercial robot-vacuum line."
        , stack = [ "Python", "Postgres", "AWS / Terraform" ]
        , bullets =
            [ "Established the backend services and the Python device-side client library from scratch."
            , "Set up the development workflow and shipped to production on schedule for the commercial launch."
            ]
        }


ctm : Position
ctm =
    role
        { title = "Senior Engineer"
        , company = "CompareTheMarket / Bean"
        , dates = "Feb 2019 – Mar 2021"
        , scope = "Senior engineer rebuilding Bean.com as a high-performance Open Banking service for this leading UK price-comparison site."
        , stack = [ "GraphQL", "Elm", "Elixir / Phoenix", "Ruby", "Postgres", "AWS" ]
        , bullets =
            [ "Integrated 15 UK high-street banks under Open Banking and the regulatory complexity of FCA-authorised account information services."
            , "Delivered the headroom to support the CompareTheMarket.com customer base at scale, launching to tens of thousands of early users."
            ]
        }


twentyBn : Position
twentyBn =
    role
        { title = "Senior Frontend Engineer"
        , company = "TwentyBN"
        , dates = "Aug – Dec 2018"
        , scope = "Senior frontend engineer building functional-frontend tooling for this computer-vision AI company."
        , stack = [ "Elm", "JavaScript" ]
        , bullets =
            [ "Built two Elm apps collecting video-gesture training data from Mechanical Turk workers for TwentyBN's models."
            ]
        }


liqid : Position
liqid =
    role
        { title = "Senior Engineer"
        , company = "Liqid"
        , dates = "Jan – Aug 2018"
        , scope = "Senior backend engineer integrating a wealth-management fintech's platform with Salesforce."
        , stack = [ "RabbitMQ", "GraphQL", "Ruby / Rails", "Salesforce", "Docker" ]
        , bullets =
            [ "Shipped a RabbitMQ microservice for CRM and operational workflows across the integration boundary."
            ]
        }


zapnito : Position
zapnito =
    role
        { title = "VP Engineering"
        , company = "Zapnito"
        , dates = "2014 – 2017"
        , scope = "Hands-on VP Engineering; built and led a team of 3 over 3 years while staying in the code."
        , stack = [ "JavaScript", "Elm", "WebSockets", "Phoenix Channels", "JWT", "Postgres" ]
        , bullets =
            [ "Led delivery of a white-labelled realtime community platform for B2B publishers, from early prototype to a stable multi-tenant SaaS serving multiple enterprise publishers."
            , "Built a single-page realtime web app with a Slack-like UX over WebSockets, and an embedding API with a multi-widget kit and seamless SSO across third-party host platforms, the realtime features the product was sold on."
            ]
        }


lytbulb : Position
lytbulb =
    role
        { title = "CTO"
        , company = "Lytbulb"
        , dates = "2014 – 2015"
        , scope = "Founding CTO; hired and led 2 engineers; set the technical roadmap and architecture."
        , stack = [ "Ember.js", "JavaScript", "Firebase", "Ruby on Rails", "Postgres" ]
        , bullets =
            [ "Took a Trello-style project-management product for the energy sector (oil and gas) from concept to live deployment."
            , "Built a real-time Kanban-style workflow engine on a Firebase backend with an Ember.js single-page front end."
            ]
        }


myschooldirect : Position
myschooldirect =
    role
        { title = "CTO & Co-founder"
        , company = "Myschooldirect"
        , dates = "2010 – 2014"
        , scope = "Co-founder and CTO; built and led a team of 4 (designer, 3 engineers); set the technical roadmap."
        , stack = [ "Ember.js", "JavaScript", "Browser extensions", "Ruby on Rails", "Postgres" ]
        , bullets =
            [ "Delivered three products including the M&S school-uniform store, subsequently sold to Marks & Spencer and brought in-house."
            , "Shipped Give4Sure, a browser extension raising funds for schools and charities via affiliate links when users shopped with major UK retailers."
            ]
        }


informa : Position
informa =
    role
        { title = "Tech Lead / Architect"
        , company = "Informa Telecoms & Media"
        , dates = "2005 – 2010"
        , scope = "Led the engineering team across multiple flagship products."
        , stack = [ "Java", "Spring", "Oracle DB", "Scrum", "BDD" ]
        , bullets =
            [ "Architected the replacement for the flagship World Cellular Information Service (WCIS), an intelligence platform covering mobile markets across 226 countries, migrated live without disrupting paying subscribers."
            , "Delivered a Business Intelligence portal on the Mondrian OLAP engine and a WebDAV-based CMS, letting analysts and journalists author reports directly in Microsoft Word."
            ]
        }


nutshell : Position
nutshell =
    role
        { title = "Technical Co-founder"
        , company = "Nutshell Development"
        , dates = "Oct 2004 – Jun 2005"
        , scope = ""
        , stack = []
        , bullets =
            [ "Co-founded a Brighton web agency straight out of a Sussex BSc in Artificial Intelligence, delivering booking systems, content management systems, and bespoke websites for small-business and retail clients."
            ]
        }


education : List Institution
education =
    [ { name = "University of Sussex"
      , course = "BSc Artificial Intelligence"
      , result = "2:1"
      , dates = "2001 – 2004"
      }
    ]
