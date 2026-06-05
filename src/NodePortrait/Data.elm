module NodePortrait.Data exposing (Variant(..), portrait)

{-| Node / Next.js portrait CV content, rendered through the shared two-page
`Cv.PortraitView` (the same layout as the Engineering Manager cuts). Served as
two re-weighted variations on the hands-on axis:

  - `/node-staff` → `Staff`: Staff full-stack engineer framing. The default IC
    cut for a Next.js / TypeScript / Node shop hiring a senior individual
    contributor who goes deep on architecture and stays in the code.
  - `/node-lead` → `Leader`: hands-on CTO / Staff engineer framing, for the
    founding-engineer / fractional-CTO / hands-on-technical-leader reader.

Only the tagline and the profile copy flex by variant; the role history,
highlights, and education are shared. The skill-group ordering flexes too: the
`Staff` cut leads with the technical groups and trails Leadership; the `Leader`
cut promotes Leadership to the front.

The shape mirrors the EM cut: each role leads with explicit `Scope:` and
`Stack:` lines, with bullets trimmed of anything those lines already carry, and
the consulting-era engagements (Boulevard, Vorwerk, CompareTheMarket) nest
under a single Thoughtclay umbrella.

Honesty guardrails carried through both variants: never managed more than five
and not recently; XP Flow was a founding-engineer / tech-lead seat on a
cross-functional team; the Boulevard App Store / GraphQL rate limiter /
authorization / HIPAA work is genuinely claimable; the M&S sale is a real win
with no fabricated DD or handover involvement.

-}

import Cv.PortraitView exposing (PortraitCv, SkillGroup)
import Cv.Types exposing (CvData, Institution, Position, Project)


type Variant
    = Staff
    | Leader


{-| Assemble the `PortraitCv` the shared `Cv.PortraitView` renders. Tagline and
profile flex by variant via `cv`; the skill-group ordering flexes via
`skillGroups`; highlights are shared.
-}
portrait : Variant -> PortraitCv
portrait variant =
    { cv = cv variant
    , highlights = highlights
    , skillGroups = skillGroups variant
    }


cv : Variant -> CvData
cv variant =
    { pdfFileName = pdfFileName variant
    , name = "Oliver Searle-Barnes"
    , tagline = tagline variant
    , email = "oliver@opsb.co.uk  ·  linkedin.com/in/oliversearlebarnes  ·  github.com/opsb"
    , profileTitle = "Profile"
    , executiveProfile = executiveProfile variant
    , coreCapabilities = coreCapabilities
    , technicalSkills = "TypeScript, JavaScript, Node.js, React, Next.js, GraphQL, Elixir, Phoenix, Elm, Python, Ruby / Rails, PostgreSQL, Redis, DynamoDB, RabbitMQ, AWS / Terraform"
    , leadingPosition = xpflow
    , secondPosition = Just tree3
    , thoughtclay = thoughtclay
    , otherPositions = [ zapnito, lytbulb, myschooldirect, informa, nutshell ]
    , education = education
    }


pdfFileName : Variant -> String
pdfFileName variant =
    case variant of
        Staff ->
            "Oliver-Searle-Barnes-Staff-Engineer.pdf"

        Leader ->
            "Oliver-Searle-Barnes-Hands-On-CTO.pdf"


tagline : Variant -> String
tagline variant =
    case variant of
        Staff ->
            "Staff Engineer · AI / Next.js / TypeScript / Node"

        Leader ->
            "Team Lead · AI / Next.js / TypeScript / Node"


{-| Short placement statement; the showing-off lives in the `highlights` strip
below it. Only the intro flexes by variant: hands-on IC depth for `Staff`,
sets-direction-and-stays-in-the-code for `Leader`.
-}
executiveProfile : Variant -> List String
executiveProfile variant =
    case variant of
        Staff ->
            [ "Staff full-stack engineer with two decades shipping production software, including 10+ years senior at scale-ups like CompareTheMarket, Boulevard, and Zapnito. Most recently building agentic AI products on Next.js / TypeScript / Node, going deep on architecture while staying in the code, and AI-native by default." ]

        Leader ->
            [ "Hands-on team lead with two decades shipping production software, including 10+ years senior at scale-ups like CompareTheMarket, Boulevard, and Zapnito. I set technical direction and stay in the code, most recently building agentic AI products on Next.js / TypeScript / Node, and AI-native by default." ]


{-| Marquee, mostly-quantified wins surfaced as a Selected Highlights strip
under the summary. Outcomes (not skills), so they complement rather than
duplicate the Core Capabilities groups. Range: recent Next.js/AI, scale at a
unicorn, a high-throughput platform, and the strongest open-source signal for a
JS audience.
-}
highlights : List String
highlights =
    [ "Took Alfie from zero to one as XP Flow's founding engineer, growing the LLM-agent product to 200 companies."
    , "Built a high-performance affiliate platform at Tree3 on Next.js, Postgres and Redis."
    , "Shipped API-platform infrastructure at Boulevard, a health-and-beauty unicorn: the App Store, a GraphQL rate limiter, HIPAA compliance, and the authorization model."
    , "Built CompareTheMarket's personal finance manager on Open Banking, integrating 15 UK high-street banks and launching to tens of thousands of early users."
    , "Ex-core contributor on Orbit.js, the JS data-sync library, alongside the JSON:API spec author."
    ]


{-| Unused by the portrait layout (which renders `skillGroups`) but required by
`CvData`. Kept meaningful in case a future ATS / linear-list view consumes it.
-}
coreCapabilities : List String
coreCapabilities =
    [ "Full-stack Next.js / React / TypeScript"
    , "Node.js & GraphQL API platforms"
    , "Agentic AI & LLM delivery (LangChain / LangGraph)"
    , "Architecture, system design & code review"
    , "Postgres / Redis performance & scaling"
    , "AWS / Terraform & CI/CD"
    , "Technical leadership & mentoring"
    , "Customer discovery & continuous delivery"
    ]


{-| Grouped Core Capabilities rendered as labelled, comma-separated lines. The
ordering flexes by variant: `Staff` leads with the technical surface and trails
Leadership; `Leader` promotes Leadership to the front. The final group carries
the platform stack, so there is no standalone Technical Skills line.
-}
skillGroups : Variant -> List SkillGroup
skillGroups variant =
    case variant of
        Staff ->
            [ frontend, backend, ai, methodology, leadership, dataAndInfra ]

        Leader ->
            [ leadership, frontend, backend, ai, methodology, dataAndInfra ]


frontend : SkillGroup
frontend =
    { name = "Frontend"
    , skills =
        [ "React"
        , "Next.js"
        , "TypeScript"
        , "JavaScript"
        , "Elm"
        , "Realtime / WebSockets"
        ]
    }


backend : SkillGroup
backend =
    { name = "Backend"
    , skills =
        [ "Node.js / NestJS"
        , "Next.js (API routes / server actions)"
        , "GraphQL & REST"
        , "Elixir / Phoenix"
        , "Python"
        , "Ruby / Rails"
        ]
    }


ai : SkillGroup
ai =
    { name = "AI"
    , skills =
        [ "Agentic LLM pipelines (LangChain / LangGraph)"
        , "Tool-calling agent experiences"
        , "Evals & prompt regression harnesses"
        , "AI observability (LangSmith)"
        , "Claude Code & Cursor (daily)"
        ]
    }


methodology : SkillGroup
methodology =
    { name = "Engineering Practice"
    , skills =
        [ "Architecture & system design"
        , "Code & PR review"
        , "Testing & BDD"
        , "CI/CD, observability & continuous delivery"
        , "Agile (Shape Up / Scrum / Kanban)"
        ]
    }


leadership : SkillGroup
leadership =
    { name = "Leadership"
    , skills =
        [ "Technical leadership & mentoring"
        , "Hiring & interview loops"
        , "Cross-functional delivery (Product / Design / GTM)"
        , "Customer discovery, roadmap & OKRs"
        ]
    }


dataAndInfra : SkillGroup
dataAndInfra =
    { name = "Data & Platform"
    , skills =
        [ "PostgreSQL"
        , "Redis"
        , "DynamoDB"
        , "AWS / Terraform"
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
        { title = "Founding Engineer / Tech Lead"
        , company = "XP Flow (alfie.io)"
        , dates = "Feb 2025 – Apr 2026"
        , scope = "Founding engineer and tech lead on an agentic AI product; set the architecture, owned the Next.js stack end to end, and reviewed PRs across a cross-functional team."
        , stack = [ "Next.js", "React", "TypeScript", "Node.js", "LangChain / LangGraph", "Postgres" ]
        , bullets =
            [ "Architected the full-stack Next.js / TypeScript application end to end."
            , "Built Alfie, an agentic AI affiliate recruiter on LangChain / LangGraph: tool-calling agents acting on real systems behind a brand-voice chat interface. MVP in three weeks; grew to 200 companies."
            , "Designed the brand-to-affiliate discovery engine: a scraping pipeline feeding multi-stage LLM evaluation, with Stripe and Everflow integrations."
            ]
        }


tree3 : Position
tree3 =
    role
        { title = "Tech Lead"
        , company = "Tree3"
        , dates = "Jan 2024 – Feb 2025"
        , scope = "Engineering tech lead on a high-performance affiliate platform."
        , stack = [ "Next.js", "TypeScript", "Node.js", "Postgres", "Redis" ]
        , bullets =
            [ "Built the affiliate platform on top of TUNE's white-label tracking — the dashboards, auth, and the TUNE / Twilio / Tipalti integrations — plus a multi-tenant layer over TUNE's single-advertiser model."
            , "Built Brand and Affiliate dashboards on Next.js / React, then ran the customer-discovery sprint that surfaced AI-powered affiliate recruitment, spun out as XP Flow."
            ]
        }


thoughtclay : Position
thoughtclay =
    { title = "Principal Consultant"
    , location = "Barcelona / Remote"
    , company = "Thoughtclay"
    , dates = "2018 – 2023"
    , scope = ""
    , stack = [ "TypeScript", "React", "Node.js", "NestJS", "GraphQL", "Elixir", "Postgres", "AWS / Terraform" ]
    , overview = Nothing
    , projects =
        [ { name = "Boulevard (LA) · Unicorn"
          , dates = "Oct 2021 – Jun 2023"
          , overview = "Senior API-platform engineer at this health-and-beauty unicorn: shipped the App Store, a GraphQL rate limiter, the authorization model, HIPAA compliance, OpenTelemetry APM, and a NestJS QuickBooks integration, for the web app and external developers."
          , talkingPoints = []
          }
        , { name = "Vorwerk"
          , dates = "Apr – Sep 2021"
          , overview = "Tech lead on a 6-engineer team, bootstrapping the backend at this German consumer-appliance giant, delivering the IoT cloud services for a new commercial robot-vacuum line. Shipped on schedule for commercial launch."
          , talkingPoints = []
          }
        , { name = "CompareTheMarket / Bean"
          , dates = "Feb 2019 – Mar 2021"
          , overview = "Rebuilt Bean.com as a high-performance Open Banking service for this leading UK price-comparison site, integrating 15 UK high-street banks under FCA-authorised account information and launching to tens of thousands of early users."
          , talkingPoints = []
          }
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
            , "Shipped Give4Sure, a browser extension that used affiliate links to raise funds for schools and charities when users shopped with major UK retailers, built to handle high volume at low infrastructure cost."
            , "Made the hard people call once: managed an underperformer through a six-month PIP and, when performance still fell short of the bar, made the decision to let them go."
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
            [ "Architected the replacement for the flagship World Cellular Information Service (WCIS), an intelligence platform covering mobile markets across 226 countries, migrating the live service via incremental releases without disrupting paying subscribers."
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
            [ "Co-founded a Brighton web agency straight out of a Sussex BSc in Artificial Intelligence."
            , "Delivered booking systems, content management systems for retail clients, and bespoke websites across a range of small-business engagements."
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
