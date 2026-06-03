module Em.Data exposing (cv)

{-| Engineering Manager (player-coach) variant at `/em`. Renders through
the shared two-page executive layout `Cv.View` (same as /cto and /cpo), so
it appears as A4 pages like the other versions and paginates to two sheets.

The factual role history is the same as /cto; the EM cut reframes the copy
toward people-leadership: 1:1s, mentoring and coaching, hiring and
interviewing, career development, and player-coach technical leadership.

Framing guardrails baked in (per the job-hunt operating notes):

  - XP Flow was cross-functional leadership + engineering tech-lead, NOT
    engineering line-management-of-record. The XP Flow bullets say "ran 1:1s
    with the product designer and go-to-market staff", "directed the CTO",
    and "interviewed and partnered on engineering hires", never
    "line-managed an engineering team of N".
  - No team-size number above ~5 anywhere (the honest cap).
  - M&S bought out the uniform-store product (a genuine win); no fabricated
    DD / handover involvement.

The consulting engagements (Boulevard, Vorwerk, CompareTheMarket, etc.) sit
under the Thoughtclay "Principal Consultant" umbrella and carry the hands-on
technical lift, the player half of player-coach. The owned-function roles
(Zapnito VP Eng, Lytbulb CTO, Myschooldirect CTO & Co-founder) carry the
team-building, hiring, and mentoring narrative.

-}

import Cv.Types exposing (CvData, Institution, Position, Project)


cv : CvData
cv =
    { pdfFileName = "Oliver-Searle-Barnes-Engineering-Manager-2026.pdf"
    , name = "Oliver Searle-Barnes"
    , tagline = "Engineering Manager · Player-Coach"
    , email = "oliver@opsb.co.uk  ·  linkedin.com/in/oliversearlebarnes  ·  github.com/opsb"
    , profileTitle = "Profile"
    , executiveProfile = executiveProfile
    , coreCapabilities = coreCapabilities
    , technicalSkills = "TypeScript, JavaScript, Node.js, React, Next.js, Elixir, Phoenix, Elm, Python, Java, Ruby / Rails, PostgreSQL, DynamoDB, RabbitMQ, GraphQL, AWS / Terraform"
    , leadingPosition = xpflow
    , secondPosition = Just tastermonial
    , thoughtclay = thoughtclay
    , otherPositions = [ zapnito, lytbulb, myschooldirect, informa, nutshell ]
    , education = education
    }



---- EXECUTIVE PROFILE ----


executiveProfile : List String
executiveProfile =
    [ "Hands-on Engineering Manager and player-coach who leads teams of up to five engineers, with over two decades shipping production software across AI, fintech, SaaS, and more, including 10+ years in senior engineering roles at scale-ups such as CompareTheMarket, Boulevard, and Zapnito. Most recently founding CPO and engineer at XP Flow, where I owned the company roadmap and quarterly OKRs and led a cross-functional team while building Alfie, an agentic AI product that grew to 200 companies."
    , "I lead the people side: regular 1:1s, coaching and mentoring, hiring and running interview loops, and the harder performance-management calls. I stay close to the code, with architecture, review, and hands-on delivery when needed."
    , "AI-native by default: Claude Code is my daily driver, and I built Alfie's multi-LLM agent pipeline on LangChain / LangGraph, with tool-based agents and a prompt regression harness. Colleagues have chosen to work with me again across companies, and I stay active in the Elixir and Elm communities."
    ]



---- CORE CAPABILITIES ----


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



---- EXPERIENCE ----


xpflow : Position
xpflow =
    { title = "CPO & Founding Engineer (Player-Coach)"
    , location = "Dallas / Remote"
    , company = "XP Flow (alfie.io)"
    , dates = "Jan 2024 – Apr 2026"
    , overview = Nothing
    , scope = ""
    , stack = []
    , projects =
        [ { name = "Alfie.io"
          , dates = "Jan 2024 – Apr 2026"
          , overview = ""
          , talkingPoints =
                [ "Led the engineering build of the xpaffiliate.com affiliate platform; when it stalled, ran the customer discovery (continuous interviews) that surfaced the AI opportunity, proposed it, and spun out XP Flow, taking the founding seat."
                , "Led a cross-functional team (CTO, CMO, Sales, Chief of Staff, Chief Strategy Officer, automation expert): owned the roadmap and quarterly OKRs, ran Shape Up and continuous Kanban with regular 1:1s, hired the designer, and ran interview loops for engineering and sales hires."
                , "Engineering tech lead and founding engineer: set the architecture, scoped work and wrote tickets, and reviewed PRs across Next.js / React / TypeScript / Node / Postgres."
                , "Built Alfie, an agentic AI affiliate recruiter on LangChain / LangGraph: tool-based agents acting on real systems behind a brand-voice chat interface, with a prompt regression harness and LangSmith observability. MVP in three weeks; grew to 200 companies."
                ]
          }
        ]
    }


tastermonial : Position
tastermonial =
    { title = "Interim CTO"
    , location = "Remote"
    , company = "Tastermonial"
    , dates = "Jun 2023 – Dec 2023"
    , overview = Nothing
    , scope = ""
    , stack = []
    , projects =
        [ { name = "Tastermonial"
          , dates = "Jun 2023 – Dec 2023"
          , overview = ""
          , talkingPoints =
                [ "Owned the engineering function: rebuilt a failing iOS MVP into a production Flutter app (iOS and Android) on a new Elixir / Phoenix backend, set technical strategy with the founder, scoped work and wrote tickets, and established AWS infrastructure and CI/CD via Terraform."
                ]
          }
        ]
    }


thoughtclay : Position
thoughtclay =
    { title = "Principal Consultant"
    , location = "Barcelona / Remote"
    , company = "Thoughtclay"
    , dates = "2018 – 2023"
    , overview = Nothing
    , scope = ""
    , stack = []
    , projects =
        [ { name = "Boulevard (LA) · Unicorn"
          , dates = "Oct 2021 – Jun 2023"
          , overview = "Senior API-platform engineer at this health-and-beauty unicorn: shipped the authorization model, HIPAA implementation, the App Store, a GraphQL rate limiter, and performance optimisations to scale the platform."
          , talkingPoints = []
          }
        , { name = "Vorwerk"
          , dates = "Apr – Sep 2021"
          , overview = "Tech Lead bootstrapping a backend team at this German consumer-appliance giant, mentoring engineers onto Elixir while delivering Elixir / Python cloud services on AWS that power IoT connectivity for a new commercial robot vacuum line. Shipped on schedule for commercial launch."
          , talkingPoints = []
          }
        , { name = "CompareTheMarket / Bean"
          , dates = "Feb 2019 – Mar 2021"
          , overview = "Rebuilt Bean.com on Elixir / GraphQL as a high-performance Open Banking service for this leading UK price-comparison site, integrating 12 UK high-street banks under FCA-authorised account information and launching the new product to thousands of early users."
          , talkingPoints = []
          }
        ]
    }


zapnito : Position
zapnito =
    { title = "VP Engineering"
    , location = "London / Remote"
    , company = "Zapnito"
    , dates = "2014 – 2017"
    , overview = Nothing
    , scope = ""
    , stack = []
    , projects =
        [ { name = "Feeds"
          , dates = "2014 – 2017"
          , overview = ""
          , talkingPoints =
                [ "As VP Engineering, built and led a team of three over three years behind a white-labelled real-time community platform for B2B publishers, owning hiring, regular 1:1s, mentoring, and the technical roadmap (scoping work and writing tickets for the team)."
                , "Delivered a Phoenix / Elixir platform with real-time collaboration over WebSockets, taking it from early-stage prototype to a stable multi-tenant SaaS serving multiple enterprise publishers."
                , "Introduced an event-driven architecture and embedding API with SSO across third-party host platforms, enabling the realtime features that became a key product differentiator."
                ]
          }
        ]
    }


lytbulb : Position
lytbulb =
    { title = "CTO"
    , location = "London / Remote"
    , company = "Lytbulb"
    , dates = "2014 – 2015"
    , overview = Nothing
    , scope = ""
    , stack = []
    , projects =
        [ { name = "lytbulb.com"
          , dates = "2014 – 2015"
          , overview = ""
          , talkingPoints =
                [ "As CTO, hired and led two engineers to build a Trello-style project-management product aimed at the energy sector, with a focus on oil and gas operations."
                , "Set the technical roadmap and architecture, scoped work and wrote tickets, mentored the founding engineers, and took the product from concept to live deployment."
                , "Built a real-time Kanban-style workflow engine on an Ember.js front-end with a Firebase backend, enabling field teams to coordinate complex operational projects."
                ]
          }
        ]
    }


myschooldirect : Position
myschooldirect =
    { title = "CTO & Co-founder"
    , location = "London"
    , company = "Myschooldirect"
    , dates = "2010 – 2014"
    , overview = Nothing
    , scope = ""
    , stack = []
    , projects =
        [ { name = "Myschooldirect & Give4Sure"
          , dates = "2010 – 2014"
          , overview = ""
          , talkingPoints =
                [ "Delivered three products: a school fundraising platform, the Give4Sure charitable browser extension, and the M&S school uniform store, the last subsequently sold to Marks & Spencer and brought in-house."
                , "Co-founded and led technology, hiring and running the interview loops for a designer and three engineers, and mentoring the team; set the technical roadmap, scoping work and writing tickets."
                , "Made the hard people calls: managed an underperformer through a six-month PIP and, when performance still fell short of the bar, made the decision to let them go."
                ]
          }
        ]
    }


nutshell : Position
nutshell =
    { title = "Technical Co-founder"
    , location = "Brighton"
    , company = "Nutshell Development"
    , dates = "Oct 2004 – Jun 2005"
    , overview = Nothing
    , scope = ""
    , stack = []
    , projects =
        [ { name = "Nutshell Development"
          , dates = "Oct 2004 – Jun 2005"
          , overview = ""
          , talkingPoints =
                [ "Co-founded Nutshell Development straight out of university, a Brighton-based web agency delivering Java-based digital products for local businesses."
                , "Built booking systems, content management systems for retail clients, and bespoke websites across a range of small business engagements."
                ]
          }
        ]
    }


informa : Position
informa =
    { title = "Tech Lead / Architect"
    , location = "London"
    , company = "Informa Telecoms & Media"
    , dates = "2005 – 2010"
    , overview = Nothing
    , scope = ""
    , stack = []
    , projects =
        [ { name = "World Cellular Information Service"
          , dates = "2005 – 2010"
          , overview = ""
          , talkingPoints =
                [ "Led the team that architected the replacement for Informa's flagship World Cellular Information Service (WCIS), a mission-critical intelligence platform covering mobile markets across 226 countries, used by global telecoms operators, analysts, and regulators."
                , "Delivered a Business Intelligence portal on the Mondrian OLAP engine and a WebDAV-based CMS, enabling analysts and journalists to query complex datasets and author reports directly in Microsoft Word."
                , "Led a multi-year platform migration from legacy systems, coordinating across editorial, product, and infrastructure teams to deliver without disrupting paying subscribers."
                ]
          }
        ]
    }



---- EDUCATION ----


education : List Institution
education =
    [ { name = "University of Sussex"
      , course = "BSc Artificial Intelligence"
      , result = "2:1"
      , dates = "2001 – 2004"
      }
    ]
