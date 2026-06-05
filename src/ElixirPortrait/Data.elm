module ElixirPortrait.Data exposing (Variant(..), portrait)

{-| Elixir portrait CV content, rendered through the shared two-page
`Cv.PortraitView` (the same layout as the Engineering Manager and Node cuts).
Served as two re-weighted variations on the hands-on axis:

  - `/elixir-staff` → `Staff`: Staff / Principal Elixir IC framing. The default
    cut for an Elixir / Phoenix shop hiring a senior individual contributor who
    goes deep on OTP architecture and stays in the code.
  - `/elixir-lead` → `Leader`: hands-on Elixir lead / Staff engineer framing,
    for the tech-lead / player-coach / hands-on-CTO reader on an Elixir stack.

Only the tagline and the profile copy flex by variant; the role history,
highlights, and education are shared. The skill-group ordering flexes too: the
`Staff` cut leads with Elixir / OTP and trails Leadership; the `Leader` cut
promotes Leadership to the front.

The leading XP Flow seat carries the recent agentic-AI work, Tastermonial
re-establishes Elixir immediately after, and the consulting-era Elixir
engagements (Boulevard, Vorwerk, CompareTheMarket) each stand as their own full
engagement in reverse-chronological order, rather than nesting under a single
Thoughtclay umbrella. Every Elixir role leads with explicit `Scope:` and
`Stack:` lines.

Honesty guardrails carried through both variants: XP Flow was a Next.js / Node
founding-engineer seat (no Elixir claimed there), with the Elixir depth coming
from Boulevard, CompareTheMarket, Vorwerk, Liqid, and Zapnito; the Boulevard
authorization / GraphQL rate-limiter / HIPAA / App Store work is genuinely
claimable; the M&S sale is a real win with no fabricated DD or handover.

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
    , technicalSkills = "Elixir, Phoenix, OTP, LiveView, Phoenix Channels, Ecto, Absinthe (GraphQL), RabbitMQ, PostgreSQL, Elm, TypeScript, React, Next.js, Python, Ruby / Rails, AWS / Terraform"
    , leadingPosition = xpflow
    , secondPosition = Just tastermonial
    , thoughtclay = boulevard
    , otherPositions = [ vorwerk, ctm, twentyBn, liqid, zapnito, lytbulb, myschooldirect, informa, nutshell ]
    , education = education
    }


pdfFileName : Variant -> String
pdfFileName variant =
    case variant of
        Staff ->
            "Oliver-Searle-Barnes-Staff-Elixir-Engineer.pdf"

        Leader ->
            "Oliver-Searle-Barnes-Elixir-Lead.pdf"


tagline : Variant -> String
tagline variant =
    case variant of
        Staff ->
            "Staff Elixir Engineer · Phoenix / OTP"

        Leader ->
            "Elixir Team Lead · Phoenix / OTP"


{-| Short placement statement; the showing-off lives in the `highlights` strip
below it. Only the intro flexes by variant: hands-on IC depth for `Staff`,
sets-direction-and-stays-in-the-code for `Leader`.
-}
executiveProfile : Variant -> List String
executiveProfile variant =
    case variant of
        Staff ->
            [ "Staff Elixir engineer with two decades shipping production software, including a decade of Elixir / Phoenix at scale-ups like Boulevard, CompareTheMarket, and Zapnito. Most recently founding engineer on an agentic AI product, owning the architecture and the implementation." ]

        Leader ->
            [ "Hands-on Elixir team lead with two decades shipping production software, including a decade of Elixir / Phoenix at scale-ups like Boulevard, CompareTheMarket, and Zapnito. Most recently founding engineer on an agentic AI product, setting technical direction while staying in the code." ]


{-| Marquee, mostly-quantified wins surfaced as a Selected Highlights strip
under the summary. Outcomes (not skills), so they complement rather than
duplicate the Core Capabilities groups. Range: scale at a unicorn, fintech /
Open Banking, realtime, IoT, and the recent agentic-AI seat.
-}
highlights : List String
highlights =
    [ "Took Alfie from zero to one as XP Flow's founding engineer, growing the agentic-AI product to 200 companies."
    , "Rebuilt CompareTheMarket's Bean.com as a high-performance Elixir / Phoenix Open Banking service, integrating 15 UK high-street banks and launching to tens of thousands of early users."
    , "Shipped API-platform infrastructure in Elixir / Phoenix at Boulevard, a health-and-beauty unicorn: the authorization model, a GraphQL rate limiter, HIPAA, and the App Store."
    , "Built Zapnito's real-time community platform on Phoenix Channels, from prototype to a stable multi-tenant SaaS serving multiple enterprise publishers."
    , "Led the Elixir backend build at Vorwerk, delivering the Phoenix IoT cloud services for a new commercial robot-vacuum line and shipping on schedule for launch."
    ]


{-| Unused by the portrait layout (which renders `skillGroups`) but required by
`CvData`. Kept meaningful in case a future ATS / linear-list view consumes it.
-}
coreCapabilities : List String
coreCapabilities =
    [ "Elixir / OTP architecture & system design"
    , "Phoenix, LiveView & Phoenix Channels"
    , "GraphQL (Absinthe) & API platforms"
    , "Realtime systems"
    , "Postgres / Ecto performance & scaling"
    , "AWS / Terraform & CI/CD"
    , "Agentic AI & LLM delivery (LangChain / LangGraph)"
    , "Technical leadership & mentoring"
    ]


{-| Grouped Core Capabilities rendered as labelled, comma-separated lines. The
ordering flexes by variant: `Staff` leads with Backend (Elixir / OTP first) and
trails Leadership; `Leader` promotes Leadership to the front. `Platform` stays
last in both orderings and carries the infrastructure stack, so there is no
standalone Technical Skills line.
-}
skillGroups : Variant -> List SkillGroup
skillGroups variant =
    case variant of
        Staff ->
            [ backend, frontend, ai, methodology, leadership, platform ]

        Leader ->
            [ leadership, backend, frontend, ai, methodology, platform ]


backend : SkillGroup
backend =
    { name = "Backend"
    , skills =
        [ "Elixir"
        , "Phoenix"
        , "OTP"
        , "Phoenix LiveView"
        , "Ecto"
        , "Absinthe (GraphQL) & REST"
        , "Realtime systems"
        , "RabbitMQ & async messaging"
        , "Ruby / Rails"
        , "Python"
        , "Node.js"
        ]
    }


frontend : SkillGroup
frontend =
    { name = "Frontend"
    , skills =
        [ "TypeScript / React"
        , "Next.js"
        , "Elm"
        ]
    }


ai : SkillGroup
ai =
    { name = "AI"
    , skills =
        [ "Agentic LLM pipelines (LangChain / LangGraph)"
        , "Tool-calling agent experiences"
        , "Evals & prompt regression harnesses"
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


platform : SkillGroup
platform =
    { name = "Platform"
    , skills =
        [ "PostgreSQL"
        , "Redis"
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
        , dates = "Jan 2024 – Apr 2026"
        , scope = "Founding engineer and tech lead on an agentic AI product; set the architecture, owned the stack end to end, and reviewed PRs across a cross-functional team."
        , stack = [ "TypeScript", "Node.js", "Next.js", "LangChain / LangGraph", "Postgres", "Redis" ]
        , bullets =
            [ "Built Alfie, an agentic AI affiliate recruiter on LangChain / LangGraph: tool-calling agents acting on real systems behind a brand-voice chat interface, with a prompt regression harness. MVP in three weeks; grew to 200 companies."
            , "Earlier in the same seat, built an affiliate platform on Next.js (on top of TUNE's white-label tracking), before the pivot to Alfie."
            ]
        }


tastermonial : Position
tastermonial =
    role
        { title = "Interim CTO"
        , company = "Tastermonial"
        , dates = "Jun 2023 – Dec 2023"
        , scope = "Interim CTO; owned the engineering function for a consumer-health startup."
        , stack = [ "Elixir", "Phoenix", "Flutter", "Postgres" ]
        , bullets =
            [ "Rebuilt a failing iOS MVP into a production system: a Phoenix / Elixir backend for production-grade reliability and a Flutter app on iOS and Android, with Kanban, BDD, and the engineering foundations and developer tooling established from scratch."
            ]
        }


{-| The consulting-era Elixir engagements (Boulevard, Vorwerk, CompareTheMarket)
render as standalone full engagements rather than nesting under a single
Thoughtclay umbrella. `boulevard`, the most recent, occupies the shared view's
page-break slot (the `thoughtclay` field on `CvData`); `vorwerk` and `ctm` lead
`otherPositions` on page 2.
-}
boulevard : Position
boulevard =
    role
        { title = "Staff Engineer (Senior Engineer 2)"
        , company = "Boulevard"
        , dates = "Oct 2021 – Jun 2023"
        , scope = "Senior Elixir / Phoenix engineer on the API platform of this health-and-beauty unicorn, shipping cross-cutting infrastructure for the web app and external developers."
        , stack = [ "Elixir", "Phoenix", "Absinthe (GraphQL)", "Postgres", "React", "AWS / Terraform" ]
        , bullets =
            [ "Designed and built a declarative Absinthe authorization layer."
            , "Shipped a platform-wide GraphQL rate limiter with per-application quotas, and led HIPAA compliance with audit logging, encryption, and field masking."
            , "Optimised database performance, scaling the platform to handle growing load."
            , "Extended the App Store and developer portal, and introduced QuickBooks and Zapier integrations."
            ]
        }


vorwerk : Position
vorwerk =
    role
        { title = "Tech Lead"
        , company = "Vorwerk"
        , dates = "Apr – Sep 2021"
        , scope = "Tech lead on a 6-engineer team, bootstrapping the Elixir backend at this German consumer-appliance giant, delivering the Phoenix IoT cloud services for a new commercial robot-vacuum line."
        , stack = [ "Elixir", "Phoenix", "Python", "Postgres", "AWS / Terraform" ]
        , bullets =
            [ "Established the Phoenix backend services and the Python device-side client library from scratch."
            , "Set up the development workflow and shipped to production on schedule for the commercial launch."
            ]
        }


ctm : Position
ctm =
    role
        { title = "Senior Engineer"
        , company = "CompareTheMarket / Bean"
        , dates = "Feb 2019 – Mar 2021"
        , scope = "Senior Elixir / Phoenix engineer rebuilding Bean.com as a high-performance Open Banking service for this leading UK price-comparison site."
        , stack = [ "Elixir", "Phoenix", "Absinthe (GraphQL)", "Elm", "Ruby", "Postgres", "AWS" ]
        , bullets =
            [ "Integrated 15 UK high-street banks under Open Banking and the regulatory complexity of FCA-authorised account information services."
            , "Delivered the headroom to support the CompareTheMarket.com customer base at scale, launching to tens of thousands of early users."
            ]
        }


zapnito : Position
zapnito =
    role
        { title = "VP Engineering"
        , company = "Zapnito"
        , dates = "2014 – 2017"
        , scope = "Hands-on VP Engineering; built and led a team of 3 over 3 years while staying in the code."
        , stack = [ "Elixir", "Phoenix", "Phoenix Channels", "Elm", "Postgres" ]
        , bullets =
            [ "Led delivery of Feeds, a white-labelled real-time community platform for B2B publishers, from early prototype to a stable multi-tenant SaaS serving multiple enterprise publishers."
            , "Built a Slack-like realtime experience on Phoenix Channels with a realtime pub-sub architecture and a multi-widget embedding kit with SSO."
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
        , scope = "Senior backend engineer integrating a wealth-management fintech's Rails platform with Salesforce."
        , stack = [ "Elixir", "RabbitMQ", "Ruby / Rails", "Salesforce", "Docker", "GraphQL" ]
        , bullets =
            [ "Shipped an Elixir / RabbitMQ microservice for CRM and operational workflows across the integration boundary."
            ]
        }


lytbulb : Position
lytbulb =
    role
        { title = "CTO"
        , company = "Lytbulb"
        , dates = "2014 – 2015"
        , scope = "Founding CTO; hired and led 2 engineers; set the technical roadmap and architecture."
        , stack = [ "Ruby on Rails", "Ember.js", "Firebase", "Postgres" ]
        , bullets =
            [ "Took a Trello-style project-management product for the energy sector (oil and gas) from concept to live deployment."
            , "Built a real-time Kanban-style workflow engine enabling field teams to coordinate complex operational projects."
            ]
        }


myschooldirect : Position
myschooldirect =
    role
        { title = "CTO & Co-founder"
        , company = "Myschooldirect"
        , dates = "2010 – 2014"
        , scope = "Co-founder and CTO; built and led a team of 4 (designer, 3 engineers); set the technical roadmap."
        , stack = [ "Ruby on Rails", "Ember.js", "Postgres" ]
        , bullets =
            [ "Delivered three products including the M&S school-uniform store, subsequently sold to Marks & Spencer and brought in-house."
            , "Shipped Give4Sure, a browser extension that used affiliate links to raise funds for schools and charities when users shopped with major UK retailers."
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
