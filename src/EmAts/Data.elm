module EmAts.Data exposing
    ( Institution
    , OpenSourceProject
    , Position
    , SkillGroup
    , education
    , name
    , openSource
    , pdfFileName
    , positions
    , skillGroups
    , summaryParagraphs
    , tagline
    )

{-| Content for the ATS-clean Engineering Manager CV at `/em-ats`. This is the
default for blind / ATS apply-flows (16 of 18 EM prospects arrive this way);
the designed two-page sibling at `/em` is for warm / founder / VC-forwarded
routes. The two carry the same facts; keep them in sync.

ATS rules (see reference_ats_cv_guidelines): single column, white background,
plain-text contact line, standard section names, `•` bullets, comma-separated
skills, no tables / images / columns. Each role opens with a `Scope:` line
(team size + area owned), the signature EM-CV convention.

Framing guardrails (per the job-hunt operating notes):

  - XP Flow = cross-functional lead (designer, automation specialist) + eng
    tech-lead who directed the CTO, NOT engineering line-manager-of-record.
  - No team-size number above 5 (the honest cap); largest real team was ~5 at
    Myschooldirect.
  - Never promoted anyone, so no promotion claims. The one true
    performance-management story (Myschooldirect PIP-and-exit) is stated plainly.
  - M&S bought the uniform-store product (a genuine win); no fabricated
    DD / handover involvement.
  - Boulevard authz / HIPAA / App Store / GraphQL rate limiter are claimable.

Verified numbers: XP Flow grew to 200 companies; CompareTheMarket integrated
12 high-street banks + thousands of early users; Zapnito team of 3 over 3 years;
Lytbulb hired 2 engineers; Myschooldirect hired 5 (PM, designer, 3 engineers).

-}


type alias Position =
    { company : String
    , title : String
    , dates : String
    , location : String
    , scope : Maybe String
    , stack : List String
    , overview : String
    , highlights : List String
    }


type alias SkillGroup =
    { name : String
    , skills : List String
    }


type alias Institution =
    { course : String
    , result : String
    , name : String
    }


type alias OpenSourceProject =
    { name : String
    , shortInvolvement : String
    , language : String
    }


name : String
name =
    "Oliver Searle-Barnes"


tagline : String
tagline =
    "Engineering Manager · Player-Coach"


pdfFileName : String
pdfFileName =
    "Oliver-Searle-Barnes-Engineering-Manager-ATS-2026.pdf"


summaryParagraphs : List String
summaryParagraphs =
    [ "Hands-on Engineering Manager and player-coach who leads teams of up to five engineers, with over two decades shipping production software across AI, fintech, SaaS, e-commerce, telecoms, and publishing, including 10+ years in senior engineering roles at scale-ups (CompareTheMarket, Boulevard, Zapnito). Most recently founding CPO and engineer at XP Flow, where I owned the company roadmap and quarterly OKRs and built Alfie, an agentic AI product (LangChain / LangGraph) that grew to 200 companies."
    , "I lead the people side: regular 1:1s, coaching and mentoring, hiring and running interview loops, and the harder performance-management calls. I stay close to the code, with architecture, review, and hands-on delivery when the team needs it, and Claude Code is my daily driver. Colleagues have chosen to work with me again across companies."
    ]


skillGroups : List SkillGroup
skillGroups =
    [ { name = "Leadership"
      , skills =
            [ "People management"
            , "1:1s, coaching & mentoring"
            , "Hiring & interview loops"
            , "Performance management (PIPs)"
            , "Career development"
            , "Technical roadmap, OKRs & planning"
            , "Cross-functional leadership (Product / Design / GTM)"
            , "Agile (Scrum / Kanban / BDD)"
            ]
      }
    , { name = "Product & Discovery"
      , skills =
            [ "Customer discovery & interviews"
            , "Continuous discovery methodology"
            , "Product judgement & roadmap"
            ]
      }
    , { name = "Engineering Leadership"
      , skills =
            [ "Architecture & system design"
            , "Code & PR review"
            , "Work breakdown, backlog grooming & ticket writing"
            , "Player-coach hands-on delivery"
            , "On-call & incident response"
            , "CI/CD, testing & observability"
            , "Engineering standards"
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


positions : List Position
positions =
    [ { company = "XP Flow (alfie.io)"
      , title = "CPO & Founding Engineer (Player-Coach)"
      , dates = "Jan 2024 – Apr 2026"
      , location = "Dallas / Remote"
      , scope = Just "Founding CPO; owned company roadmap and quarterly OKRs; ran the operating cadence across a cross-functional team (CTO, CMO, Sales, Chief of Staff, Chief Strategy Officer, automation expert)."
      , stack = [ "AI / LLMs", "Next.js", "React", "TypeScript", "Node.js", "Postgres" ]
      , overview = ""
      , highlights =
            [ "Led the engineering build of the xpaffiliate.com affiliate platform; when it stalled, ran the customer discovery (continuous interviews) that surfaced the AI opportunity, proposed it, and spun out XP Flow, taking the founding seat."
            , "Owned the roadmap and quarterly OKRs, running Shape Up (2 cycles/quarter) and continuous Kanban with regular 1:1s; directed the CTO, hired the designer, and ran interview loops for an engineering and a sales hire."
            , "As engineering tech lead and founding engineer, set the architecture, scoped work and wrote tickets, and reviewed pull requests across the Next.js / React / TypeScript / Node / Postgres stack."
            , "Built Alfie, an agentic AI affiliate recruiter on LangChain / LangGraph: a multi-LLM pipeline of tool-based agents that discover, evaluate and reach out to partners and act on real systems, behind a chat interface that learns each brand's voice, with a prompt regression harness and LangSmith observability. Shipped the MVP in three weeks; the platform grew to 200 companies."
            ]
      }
    , { company = "Tastermonial"
      , title = "Interim CTO"
      , dates = "Jun 2023 – Dec 2023"
      , location = "Remote"
      , scope = Just "Interim CTO; owned the engineering function for a consumer-health startup."
      , stack = [ "Elixir", "Phoenix", "Flutter", "Postgres", "AWS / Terraform" ]
      , overview = ""
      , highlights =
            [ "Set technical strategy with the founder, scoped the work and wrote tickets, and rebuilt a failing iOS MVP into a production Flutter app (iOS and Android) on a new Elixir / Phoenix backend."
            , "Established AWS infrastructure and CI/CD via Terraform, and left the team a stable codebase to build on."
            ]
      }
    , { company = "Thoughtclay (Principal Consultant)"
      , title = "Principal Engineer / Tech Lead (selected engagements)"
      , dates = "2018 – 2023"
      , location = "Barcelona / Remote"
      , scope = Nothing
      , stack = [ "TypeScript", "React", "Node.js", "Elixir", "Python", "Postgres", "AWS / Terraform" ]
      , overview = "Senior hands-on engagements across scale-ups and startups, the player half of player-coach:"
      , highlights =
            [ "Boulevard (Oct 2021 – Jun 2023): senior engineer at this health-and-beauty unicorn; shipped the authorization model, HIPAA implementation, the third-party App Store (home to its most popular integration, QuickBooks), a GraphQL rate limiter, and performance optimisations to scale the platform."
            , "Vorwerk (Apr – Sep 2021): Tech Lead bootstrapping a backend team, mentoring engineers onto Elixir while delivering Elixir / Python IoT cloud services on AWS for a commercial robot-vacuum line."
            , "CompareTheMarket (Feb 2019 – Mar 2021): rebuilt Bean.com on Elixir / GraphQL as an Open Banking service, integrating 12 UK high-street banks under FCA-authorised account information and launching to thousands of early users."
            ]
      }
    , { company = "Zapnito"
      , title = "VP Engineering"
      , dates = "Jan 2015 – Jan 2018"
      , location = "London / Remote"
      , scope = Just "Built and led a team of 3 engineers over 3 years; owned hiring, 1:1s, mentoring, and the technical roadmap."
      , stack = [ "Elixir", "Phoenix", "Phoenix Channels", "Elm", "Postgres" ]
      , overview = ""
      , highlights =
            [ "Set the technical roadmap for the Feeds product, scoping work and writing tickets for the team."
            , "Delivered a white-labelled real-time community platform for B2B publishers, from early prototype to a stable multi-tenant SaaS serving multiple enterprise publishers."
            , "Introduced an event-sourcing architecture over WebSockets and an embedding API with SSO across third-party host platforms, the realtime features the product was sold on."
            ]
      }
    , { company = "Lytbulb"
      , title = "CTO"
      , dates = "2014 – 2015"
      , location = "London / Remote"
      , scope = Just "Founding CTO; hired and led 2 engineers."
      , stack = [ "Ruby on Rails", "Ember.js", "Firebase", "Postgres" ]
      , overview = ""
      , highlights =
            [ "Set the technical roadmap and architecture, scoped work and wrote tickets, and led the build of a Trello-style project-management product for the energy sector (oil and gas), from concept to live deployment."
            , "Built a real-time Kanban-style workflow engine on Ember.js / Firebase enabling field teams to coordinate complex operational projects."
            ]
      }
    , { company = "Myschooldirect"
      , title = "CTO & Co-founder"
      , dates = "2010 – 2014"
      , location = "London"
      , scope = Just "Co-founder & CTO; built and led a team of 4 (designer, 3 engineers)."
      , stack = [ "Ruby on Rails", "Ember.js", "Postgres" ]
      , overview = ""
      , highlights =
            [ "Delivered three products including the M&S school-uniform store, subsequently sold to Marks & Spencer and brought in-house."
            , "Co-founded and led technology, hiring and running the interview loops for a designer and three engineers, and mentoring the team; set the technical roadmap, scoping work and writing tickets."
            , "Made the hard people calls: managed an underperformer through a six-month PIP and, when performance still fell short of the bar, made the decision to let them go."
            ]
      }
    , { company = "Informa Telecoms & Media"
      , title = "Tech Lead / Architect"
      , dates = "2005 – 2010"
      , location = "London"
      , scope = Just "Led an engineering team across multiple flagship products."
      , stack = [ "Java", "Spring", "Oracle DB", "Scrum", "BDD" ]
      , overview = ""
      , highlights =
            [ "Led the team that architected the replacement for the flagship World Cellular Information Service, an intelligence platform covering mobile markets across 226 countries, plus a WebDAV-based CMS that let journalists author reports directly in Microsoft Word."
            ]
      }
    , { company = "Nutshell Development"
      , title = "Technical Co-founder"
      , dates = "Oct 2004 – Jun 2005"
      , location = "Brighton"
      , scope = Nothing
      , stack = []
      , overview = "Co-founded a Brighton web agency straight out of a Sussex BSc in Artificial Intelligence, delivering booking systems, CMSs, and bespoke sites for local businesses."
      , highlights = []
      }
    ]


education : List Institution
education =
    [ { course = "BSc Artificial Intelligence"
      , result = "2:1"
      , name = "University of Sussex (2001 – 2004)"
      }
    ]


openSource : List OpenSourceProject
openSource =
    [ { name = "fncasts / fnchess", shortInvolvement = "owner", language = "Elm / Elixir" }
    , { name = "orbitjs / orbit", shortInvolvement = "core", language = "JavaScript" }
    , { name = "saschatimme / elm-phoenix", shortInvolvement = "core", language = "Elm" }
    , { name = "opsb / cv-elm", shortInvolvement = "owner", language = "Elm" }
    ]
