module Em.Data exposing (Variant(..), portrait)

{-| Engineering Manager CV content, served as two re-weighted variations that
flex the single biggest axis of divergence in the EM market, the hands-on
expectation (see the Hiring Personas doc):

  - `/team-lead` → `HandsOn`: player-coach framing. For the ~56% of EM /
    tech-lead roles that want hands-on coding and for the founder / first-EM
    reader.
  - `/em` → `Leader`: manager-first framing (lead through others, stay
    technically credible without grabbing the keyboard). The canonical EM cut,
    for the ~33% of roles that don't want significant hands-on coding.

Only the tagline and the profile copy flex by variant; the role history,
capabilities, and education are shared. Each role leads with explicit `Scope:`
and `Stack:` lines, with bullets trimmed of anything those lines already carry.

Honesty guardrails carried through every variant: never managed more than five
and not recently; XP Flow was cross-functional + eng tech-lead, not eng
line-manager-of-record; the M&S sale is a genuine win with no fabricated
DD/handover; the Boulevard authz / App Store / scaling claims are claimable.

-}

import Cv.PortraitView exposing (PortraitCv, SkillGroup)
import Cv.Types exposing (CvData, Institution, Position, Project)


type Variant
    = HandsOn
    | Leader


{-| Assemble the `PortraitCv` the shared `Cv.PortraitView` renders: the
shared `CvData` plus the highlights strip and grouped capabilities that
layout adds. Only `cv` flexes by variant; highlights and capabilities are
shared across both EM cuts.
-}
portrait : Variant -> PortraitCv
portrait variant =
    { cv = cv variant
    , highlights = highlights
    , skillGroups = skillGroups
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
    , technicalSkills = "TypeScript, JavaScript, Node.js, React, Next.js, Elixir, Phoenix, Elm, Python, Java, Ruby / Rails, PostgreSQL, DynamoDB, RabbitMQ, GraphQL, AWS / Terraform"
    , leadingPosition = xpflow
    , secondPosition = Just tastermonial
    , thoughtclay = thoughtclay
    , otherPositions = [ zapnito, lytbulb, myschooldirect, informa, nutshell ]
    , education = education
    }


pdfFileName : Variant -> String
pdfFileName variant =
    case variant of
        HandsOn ->
            "Oliver-Searle-Barnes-Team-Lead.pdf"

        Leader ->
            "Oliver-Searle-Barnes-Engineering-Manager.pdf"


tagline : Variant -> String
tagline variant =
    case variant of
        HandsOn ->
            "Team Lead · Player-Coach"

        Leader ->
            "Engineering Manager"


{-| The summary is a short placement statement; the showing-off lives in the
`highlights` strip below it (the pattern the strong EM example CVs use). Only
the intro flexes by variant: player-coach / hands-on for `HandsOn`, lead
through others for `Leader`.
-}
executiveProfile : Variant -> List String
executiveProfile variant =
    case variant of
        HandsOn ->
            [ "Player-coach Engineering Manager with two decades shipping production software, including 10+ years in senior engineering roles at scale-ups like CompareTheMarket, Boulevard, and Zapnito. I've led small teams of up to five while staying hands-on in the architecture and code, the balance I do best, and I am AI-native by default." ]

        Leader ->
            [ "Engineering Manager with two decades in software, including 10+ years in senior engineering roles at scale-ups like CompareTheMarket, Boulevard, and Zapnito. I build and grow high-performing teams and drive delivery through others, with the technical depth to make strong architecture calls, and I am AI-native by default." ]


{-| Marquee, mostly-quantified wins surfaced as a Selected Highlights strip
under the summary. Outcomes (not skills), so they complement rather than
duplicate the Core Capabilities groups. Range: AI/recency, a brand-name exit,
scale at a unicorn, and the strongest people-leadership signal.
-}
highlights : List String
highlights =
    [ "Took Alfie from zero to one as CPO at XP Flow, growing the agentic AI product to 200 companies."
    , "Co-founded the school-uniform store later acquired by Marks & Spencer."
    , "Scaled the API platform of Boulevard, a health-and-beauty unicorn (authorization, HIPAA, App Store)."
    , "Built CompareTheMarket's personal finance manager on Open Banking, integrating 15 UK high-street banks and launching to tens of thousands of early users."
    ]


coreCapabilities : List String
coreCapabilities =
    [ "People Management, 1:1s & Coaching"
    , "Hiring, Interview Loops & Performance Management"
    , "Technical Roadmap, OKRs & Cross-functional Delivery"
    , "Customer Discovery & Continuous Discovery"
    , "Player-Coach Technical Leadership"
    , "Architecture, Code Review & Standards"
    , "Agentic AI & LLM Delivery (LangChain / LangGraph, Claude Code)"
    , "Backlog Grooming, Work Breakdown & Ticket Writing"
    ]


{-| Grouped Core Capabilities rendered as labelled, comma-separated lines.
"Languages & Platform" carries the technical stack, so there is no standalone
Technical Skills line on this layout.
-}
skillGroups : List SkillGroup
skillGroups =
    [ { name = "Leadership"
      , skills =
            [ "People management"
            , "1:1s, coaching & mentoring"
            , "Hiring & interview loops"
            , "Performance management"
            , "Career development"
            , "Technical roadmap, OKRs & planning"
            , "Cross-functional leadership (Product / Design / GTM)"
            , "Agile (Shape Up / Scrum / Kanban)"
            ]
      }
    , { name = "Engineering Leadership"
      , skills =
            [ "Architecture & system design"
            , "Code & PR review"
            , "Work breakdown, backlog grooming & ticket writing"
            , "Delivery ownership & execution"
            , "On-call & incident response"
            , "CI/CD, testing & observability"
            , "Engineering standards"
            ]
      }
    , { name = "Product & Discovery"
      , skills =
            [ "Customer discovery & interviews"
            , "Continuous discovery methodology"
            , "Product judgement & roadmap"
            ]
      }
    , { name = "AI"
      , skills =
            [ "Agentic LLM pipelines (LangChain / LangGraph)"
            , "Tool-based agent experiences"
            , "Evals & prompt regression harnesses"
            , "AI observability (LangSmith)"
            , "Claude Code & Cursor (daily)"
            , "AI-tooling adoption across teams"
            ]
      }
    , { name = "Languages & Platform"
      , skills =
            [ "TypeScript"
            , "JavaScript"
            , "Node.js"
            , "React"
            , "Next.js"
            , "Elixir"
            , "Phoenix"
            , "Elm"
            , "Python"
            , "Java"
            , "Ruby / Rails"
            , "PostgreSQL"
            , "DynamoDB"
            , "RabbitMQ"
            , "GraphQL"
            , "AWS / Terraform"
            ]
      }
    ]


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
        { title = "CPO & Founding Engineer (Player-Coach)"
        , company = "XP Flow (alfie.io)"
        , dates = "Jan 2024 – Apr 2026"
        , scope = "Founding CPO; cross-functional team (CTO, CMO, Sales, Chief of Staff, Chief Strategy Officer, automation expert); owned company roadmap and quarterly OKRs."
        , stack = [ "AI / LLMs", "Next.js", "React", "TypeScript", "Node.js", "Postgres" ]
        , bullets =
            [ "Ran the customer discovery (continuous interviews) behind the pivot to Alfie, then took the founding seat."
            , "Ran the operating cadence (Shape Up, 2 cycles/quarter, and continuous Kanban) with regular 1:1s; hired the designer and ran interview loops for engineering and sales hires."
            , "Engineering tech lead and founding engineer: set the architecture and reviewed PRs."
            , "Built Alfie, an agentic AI affiliate recruiter on LangChain / LangGraph: tool-based agents acting on real systems behind a brand-voice chat interface, with a prompt regression harness and LangSmith observability. MVP in three weeks; grew to 200 companies."
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
            [ "Rebuilt a failing iOS MVP into a production Flutter app (iOS and Android); set technical strategy with the founder, scoped work and wrote tickets, and established the engineering foundations and developer tooling from scratch."
            ]
        }


thoughtclay : Position
thoughtclay =
    { title = "Principal Consultant"
    , location = "Barcelona / Remote"
    , company = "Thoughtclay"
    , dates = "2018 – 2023"
    , scope = ""
    , stack = [ "TypeScript", "React", "Node.js", "Elixir", "Python", "Postgres", "AWS / Terraform" ]
    , overview = Nothing
    , projects =
        [ { name = "Boulevard (LA) · Unicorn"
          , dates = "Oct 2021 – Jun 2023"
          , overview = "Senior API-platform engineer at this health-and-beauty unicorn: shipped the authorization model, HIPAA implementation, the App Store, a GraphQL rate limiter, and performance optimisations to scale the platform."
          , talkingPoints = []
          }
        , { name = "Vorwerk"
          , dates = "Apr – Sep 2021"
          , overview = "Tech lead on a 6-engineer team, bootstrapping the backend and mentoring engineers onto Elixir while delivering the IoT cloud services for a new commercial robot-vacuum line. Shipped on schedule for commercial launch."
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
        , scope = "Built and led a team of 3 engineers over 3 years; owned hiring, 1:1s, mentoring, and the technical roadmap."
        , stack = [ "Elixir", "Phoenix", "Phoenix Channels", "Elm", "Postgres" ]
        , bullets =
            [ "Delivered a white-labelled real-time community platform for B2B publishers, from early prototype to a stable multi-tenant SaaS serving multiple enterprise publishers."
            , "Introduced a realtime pub-sub architecture over WebSockets and an embedding API with SSO across third-party host platforms, the realtime features the product was sold on."
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
        , scope = "Co-founder & CTO; built and led a team of 4 (designer, 3 engineers); set the technical roadmap."
        , stack = [ "Ruby on Rails", "Ember.js", "Postgres" ]
        , bullets =
            [ "Delivered three products including the M&S school-uniform store, subsequently sold to Marks & Spencer and brought in-house."
            , "Shipped Give4Sure, a charitable shopping browser extension that used affiliate links to raise funds for schools and charities when users shopped with major UK retailers."
            , "Made the hard people calls: managed an underperformer through a six-month PIP and, when performance still fell short of the bar, made the decision to let them go."
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
            [ "Architected the replacement for the flagship World Cellular Information Service (WCIS), an intelligence platform covering mobile markets across 226 countries."
            , "Delivered a Business Intelligence portal on the Mondrian OLAP engine and a WebDAV-based CMS, letting analysts and journalists author reports directly in Microsoft Word."
            , "Led a multi-year platform migration off the legacy systems, coordinating across editorial, product, and infrastructure teams to deliver without disrupting paying subscribers."
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
