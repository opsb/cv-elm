module Node.Data exposing
    ( Institution
    , OpenSourceProject
    , Position
    , Project
    , Skill
    , SkillGroup
    , education
    , experiencePositions
    , introductionParagraphs
    , name
    , openSourceProjects
    , pdfFileName
    , positionTitle
    , sidePanelLabels
    , skillGroups
    , tagline
    )

{-| Node / Next.js Staff Engineer variant. Self-contained: own Position
type, own copy, own ordering. Lives at /node.

The aim is to lead with the most-recent JS/TS work (xpflow + Tree3, both
Next.js) and reframe the older Elixir-track engagements in stack-agnostic
platform / API / observability language so a Next.js shop reads them as
transferable Staff-level work rather than as off-target backend specifics.

-}

import Data.Skills



---- TYPES ----


type alias Position =
    { title : String
    , location : String
    , company : String
    , companyStack : List String
    , projects : List Project
    , dates : String
    }


type alias Project =
    { name : String
    , start : Int
    , end : Int
    , stack : List String
    , overview : String
    , talkingPoints : List String
    }


type alias Institution =
    { name : String
    , course : String
    , result : String
    , startYear : Int
    , endYear : Int
    , link : String
    }


type alias Skill =
    Data.Skills.Skill


type alias SkillGroup =
    Data.Skills.SkillGroup


type alias OpenSourceProject =
    { repo : String
    , name : String
    , overview : String
    , involvement : String
    , shortInvolvement : String
    , language : String
    }



---- IDENTITY ----


name : String
name =
    "Oliver Searle-Barnes"


tagline : String
tagline =
    "Staff full-stack engineer · Next.js / TypeScript / Node"


sidePanelLabels : List String
sidePanelLabels =
    [ "Staff full-stack engineer · Tech Lead · Architect"
    , "Next.js, React, TypeScript, Node, Postgres, AWS"
    , "22 years across SaaS, fintech, AI"
    ]


introductionParagraphs : List String
introductionParagraphs =
    [ "Building software that people actually love to use is what gets me going. With 22 years experience I've delivered successful products for the AI, Fintech, SaaS, Telecoms, Retail, Publishing, Energy, Charity, Health and Beauty, and Domestic appliance sectors."
    , "Most recently shipping production Next.js / TypeScript: AI agents at xpflow, a high-performance affiliate platform at Tree3, React + TypeScript against the GraphQL API at Boulevard (US salon-SaaS unicorn), and a realtime SPA at Zapnito. Ex-core contributor on Orbit.js, the JS data-sync library co-authored with the JSON:API spec author."
    , originalAgileSignoff
    ]


{-| Same signoff paragraph used by /elixir, the original from the
pre-reshape main CV (last present on 2026-04-23, commit fffe811). Kept
inline rather than imported from Data so Node.Data stays self-contained.
-}
originalAgileSignoff : String
originalAgileSignoff =
    "Agile practitioner from day one: Scrum, Kanban, Lean, BDD, you name it. Comfortable leading from the front or slotting into an established team, valuing project consistency over personal preferences."


pdfFileName : String
pdfFileName =
    "Oliver-Searle-Barnes-Staff-NodeJS-Engineer-2026.pdf"


positionTitle : Position -> String
positionTitle position =
    position.title



---- SKILLS ----


{-| Reorder the master skill list so the JS/TS surface leads. NextJS is
bumped to the top of the Backend group; Leadership goes last because the
target is a Staff IC role rather than a VP-Eng one.
-}
skillGroups : List SkillGroup
skillGroups =
    let
        promoted =
            List.map promoteNextJs Data.Skills.master

        byName target =
            promoted
                |> List.filter (\group -> group.name == target)
                |> List.head
    in
    [ "Frontend"
    , "Backend"
    , "AI"
    , "Datastores"
    , "Infrastructure"
    , "Methodology"
    , "Leadership"
    ]
        |> List.filterMap byName


promoteNextJs : SkillGroup -> SkillGroup
promoteNextJs group =
    if group.name == "Backend" then
        let
            ( nextjs, rest ) =
                List.partition (\skill -> skill.name == "NextJS") group.skills
        in
        { group | skills = nextjs ++ rest }

    else
        group



---- EXPERIENCE ----


{-| Chronological newest-first. xpflow and Tree3 are kept as separate
entries here even though they ran back-to-back, so the Next.js story has
two visible chapters rather than one merged block.
-}
experiencePositions : List Position
experiencePositions =
    [ xpflow
    , tree3
    , tastermonial
    , boulevard
    , vorwerk
    , ctm
    , twentyBn
    , liqid
    , zapnito
    , lytbulb
    , myschooldirect
    , informa
    ]


xpflow : Position
xpflow =
    { title = "Founding Engineer / Tech Lead"
    , location = "Dallas / Remote"
    , company = "xpflow"
    , companyStack = [ "Next.js", "TypeScript", "Postgres", "AI agents" ]
    , dates = "Feb 2025-Apr 2026"
    , projects =
        [ { name = "Alfie (AI affiliate-recruitment agent)"
          , start = 2025
          , end = 2026
          , overview = "Built and shipped a fleet of LLM agents that discover, evaluate, and contact affiliate partners on behalf of growth teams. MVP live in three weeks; validated strong demand."
          , stack = [ "Next.js", "TypeScript", "Postgres", "LangGraph", "OpenAI", "Stripe" ]
          , talkingPoints =
                [ "Architected the full-stack Next.js application."
                , "Designed the discovery engine matching brands to affiliates: scraping pipeline feeding multi-stage LLM evaluation."
                , "Built a custom chat stack supporting in-chat widgets and tool-calling UI."
                , "Designed an agentic learning loop on LangGraph / LangChain with regression-test harness for prompts."
                , "Integrated Stripe subscriptions and the Everflow affiliate-network API."
                ]
          }
        ]
    }


tree3 : Position
tree3 =
    { title = "Tech Lead"
    , location = "Dallas / Remote"
    , company = "Tree3"
    , companyStack = [ "Next.js", "TypeScript", "Postgres", "Redis" ]
    , dates = "Jan 2024-Feb 2025"
    , projects =
        [ { name = "XP Affiliate Platform"
          , start = 2024
          , end = 2025
          , overview = "Led engineering on a high-performance affiliate platform built on Next.js, Postgres and Redis."
          , stack = [ "Next.js", "TypeScript", "Postgres", "Redis" ]
          , talkingPoints =
                [ "Owned the platform architecture across click capture, attribution, and reliable postback delivery to partner endpoints."
                , "Built dashboards on Next.js / React for both Brands and Affiliates."
                , "Tuned Postgres + Redis for the high-volume click-stream workload."
                , "Ran the customer-discovery sprint that surfaced the underlying gap and proposed AI-powered affiliate recruitment as the response, spun out as xpflow."
                ]
          }
        ]
    }


tastermonial : Position
tastermonial =
    { title = "Interim CTO"
    , location = "Cupertino / Remote"
    , company = "Tastermonial"
    , companyStack = [ "Flutter", "Phoenix", "AWS" ]
    , dates = "Jul 2023-Dec 2023"
    , projects =
        [ { name = "Tastermonial App"
          , start = 2023
          , end = 2023
          , overview = "Rebuilt an unstable iOS MVP into a production-grade mobile app on iOS + Android."
          , stack = [ "Flutter", "Phoenix", "Postgres", "AWS/Terraform" ]
          , talkingPoints =
                [ "Inherited customers with active reliability complaints and left the engineering function stable and scalable."
                , "Rebuilt the mobile app on Flutter for iOS + Android."
                , "Established CI/CD on AWS, managed via Terraform; introduced Kanban + BDD."
                ]
          }
        ]
    }


boulevard : Position
boulevard =
    { title = "Senior 2 Engineer"
    , location = "Los Angeles / Remote"
    , company = "Boulevard"
    , companyStack = [ "GraphQL", "React", "TypeScript", "AWS" ]
    , dates = "Oct 2021-Jun 2023"
    , projects =
        [ { name = "API and Platform Services"
          , start = 2021
          , end = 2023
          , overview = "Joined the API team at this health & beauty unicorn, shipping cross-cutting platform infrastructure consumed by both the React/TypeScript web app and external developers."
          , stack = [ "GraphQL", "React", "TypeScript", "Postgres", "AWS/Terraform" ]
          , talkingPoints =
                [ "Built the third-party App Store and developer portal."
                , "Shipped the platform-wide GraphQL rate limiter (leaky-bucket, per-app quotas)."
                , "Designed the cross-service API authorization model."
                , "Led platform-wide HIPAA compliance (audit logging, encryption, field masking)."
                , "Rebuilt webhook delivery with reliable retries and idempotency."
                , "Introduced OpenTelemetry APM across the platform."
                ]
          }
        ]
    }


vorwerk : Position
vorwerk =
    { title = "Tech Lead"
    , location = "Wuppertal / Remote"
    , company = "Vorwerk"
    , companyStack = [ "Elixir", "Python", "AWS" ]
    , dates = "Apr 2021-Sep 2021"
    , projects =
        [ { name = "Kobold"
          , start = 2021
          , end = 2021
          , overview = "Bootstrapped a backend team at this consumer-appliance giant, building IoT cloud services for a new line of commercial robot vacuum cleaners."
          , stack = [ "Elixir", "Python", "Postgres", "AWS/Terraform" ]
          , talkingPoints =
                [ "Established the backend service and the Python client library on the device side."
                , "Set up the development workflow and shipped to production on schedule for the commercial launch."
                ]
          }
        ]
    }


ctm : Position
ctm =
    { title = "Senior Engineer"
    , location = "London / Remote"
    , company = "CompareThe\nMarket.com"
    , companyStack = [ "Elixir", "GraphQL", "Elm" ]
    , dates = "Feb 2019-Apr 2021"
    , projects =
        [ { name = "MoneyHub (Bean.com)"
          , start = 2019
          , end = 2021
          , overview = "Rebuilt Bean.com as a high-performance backend service for this leading UK price-comparison site."
          , stack = [ "Elixir", "GraphQL", "Elm", "JavaScript", "Ruby", "Postgres", "AWS" ]
          , talkingPoints =
                [ "Integrated the majority of UK high street banks via the Open Banking specification."
                , "Navigated the regulatory and technical complexity of FCA-authorised account information services."
                , "Replacement platform delivered the headroom to support the CompareTheMarket.com customer base at scale."
                ]
          }
        ]
    }


twentyBn : Position
twentyBn =
    { title = "Senior Frontend Engineer"
    , location = "Berlin / Remote"
    , company = "TwentyBN"
    , companyStack = [ "Elm", "JavaScript" ]
    , dates = "Aug-Dec 2018"
    , projects =
        [ { name = "Video Annotation Editor"
          , start = 2018
          , end = 2018
          , overview = "Designed and built two functional-frontend apps to collect video gesture training data from Mechanical Turk workers for this computer-vision AI company."
          , stack = [ "Elm", "JavaScript" ]
          , talkingPoints =
                [ "Annotation workflows fed directly into TwentyBN's model training pipelines."
                , "Worked at the intersection of frontend engineering and AI data infrastructure."
                ]
          }
        ]
    }


liqid : Position
liqid =
    { title = "Senior Backend Engineer"
    , location = "Berlin / Remote"
    , company = "Liqid"
    , companyStack = [ "Elixir", "Ruby on Rails", "RabbitMQ", "Salesforce" ]
    , dates = "Jan-Aug 2018"
    , projects =
        [ { name = "Salesforce Integration"
          , start = 2018
          , end = 2018
          , overview = "Integrated this wealth-management fintech's Rails platform with Salesforce via a backend microservice."
          , stack = [ "Elixir", "Ruby on Rails", "RabbitMQ", "Salesforce", "Docker", "GraphQL" ]
          , talkingPoints =
                [ "Designed and shipped the microservice supporting CRM and operational workflows."
                , "Used RabbitMQ for asynchronous, reliable message delivery across the integration boundary."
                ]
          }
        ]
    }


zapnito : Position
zapnito =
    { title = "VP Engineering"
    , location = "London / Remote"
    , company = "Zapnito"
    , companyStack = [ "WebSockets", "JavaScript", "Elm", "Phoenix" ]
    , dates = "Jan 2015–Jan 2018"
    , projects =
        [ { name = "Feeds"
          , start = 2016
          , end = 2017
          , overview = "Hands-on VP Engineering, leading delivery of Feeds, a white-labelled realtime community platform serving multiple B2B publishers."
          , stack = [ "WebSockets", "Elm", "JavaScript", "JWT", "Auth0", "Postgres", "Phoenix Channels" ]
          , talkingPoints =
                [ "Built a single-page realtime web app with a Slack-like UX over WebSockets."
                , "Designed an embedding API with a multi-widget kit and seamless SSO for 3rd-party host platforms."
                , "Hired and grew the engineering team across the period."
                ]
          }
        ]
    }


lytbulb : Position
lytbulb =
    { title = "CTO"
    , location = "London / Remote"
    , company = "Lytbulb"
    , companyStack = [ "Ember.js", "Firebase", "Rails" ]
    , dates = "2014–2015"
    , projects =
        [ { name = "lytbulb.com"
          , start = 2014
          , end = 2015
          , overview = "Led development of a Trello-like product aimed at the energy sector, focusing on oil and gas."
          , stack = [ "Ember.js", "Firebase", "Ruby on Rails", "Postgres" ]
          , talkingPoints =
                [ "Built a realtime kanban board with a Firebase backend and an Ember.js single-page front end."
                , "Developed a workflow system tailored to typical oil-and-gas project shapes."
                ]
          }
        ]
    }


myschooldirect : Position
myschooldirect =
    { title = "CTO & Co-founder"
    , location = "London / Remote"
    , company = "Myschooldirect"
    , companyStack = [ "Browser extensions", "Ember.js", "Rails" ]
    , dates = "2010–2014"
    , projects =
        [ { name = "Myschooldirect & Give4Sure (M&S acquisition, 2014)"
          , start = 2010
          , end = 2014
          , overview = "Co-founded a Quidco-style school-shopping affiliate platform with a browser-extension companion (Give4Sure) and a bespoke Marks & Spencer school-uniform store line."
          , stack = [ "Browser extensions", "Ember.js", "Ruby on Rails", "Postgres" ]
          , talkingPoints =
                [ "Built browser extensions to handle high volume with low infrastructure costs."
                , "Developed a monitoring system to detect broken / incorrect affiliate links from third-party networks."
                , "Devised a compression-based algorithm for identifying when web pages matched within a given tolerance."
                ]
          }
        ]
    }


informa : Position
informa =
    { title = "Tech Lead & Architect"
    , location = "London"
    , company = "Informa"
    , companyStack = [ "Java", "Spring", "Oracle" ]
    , dates = "2005-2010"
    , projects =
        [ { name = "World Cellular Information Service"
          , start = 2007
          , end = 2008
          , stack = [ "Java", "Spring", "MS Analytics services", "Oracle DB", "Scrum", "TDD" ]
          , overview = "Led the team replacing Informa Telecom's flagship product (WCIS), a mobile-markets intelligence platform covering 226 countries."
          , talkingPoints =
                [ "Used incremental releases to migrate the live service to a new architecture without disrupting customers or requiring parallel development."
                ]
          }
        , { name = "Intelligence Centre 2"
          , start = 2008
          , end = 2010
          , stack = [ "Java/Spring", "Oracle DB", "Scrum", "BDD" ]
          , overview = "Devised a WebDAV-based CMS allowing journalists to edit articles directly in Microsoft Word."
          , talkingPoints =
                [ "Journalists could hit Save in Word and instantly see a preview on the live site, eliminating editorial workflow friction for time-sensitive publication."
                ]
          }
        ]
    }



---- EDUCATION ----


education : List Institution
education =
    [ { name = "Sussex University"
      , link = "https://www.sussex.ac.uk/"
      , course = "Artificial Intelligence"
      , result = "2:1"
      , startYear = 2001
      , endYear = 2004
      }
    ]



---- OPEN SOURCE ----


{-| Orbit.js leads for the JS audience: ex-core contributor on a JS data-sync
library co-authored with the JSON:API spec author is the strongest single
piece of OSS evidence for this market. cv-elm is dropped: it's an Elm
self-reference that adds little for a Next.js shop.
-}
openSourceProjects : List OpenSourceProject
openSourceProjects =
    [ { name = "orbitjs / orbit"
      , repo = "https://github.com/orbitjs/orbit"
      , language = "JavaScript / TypeScript"
      , overview = "JavaScript library for orchestrating data synchronization. Core contributor for two years alongside Dan Gebhard, co-author of the JSON:API spec."
      , shortInvolvement = "core"
      , involvement = "Core contributor for two years, working with Dan Gebhard (co-author of the JSON:API spec) on code and architectural direction."
      }
    , { name = "fncasts / fnchess"
      , repo = "https://github.com/fncasts/fnchess"
      , language = "Elm / Elixir"
      , overview = "Live-coded chess game built with a friend on YouTube; episodes at https://fncasts.io."
      , shortInvolvement = "owner"
      , involvement = ""
      }
    , { name = "saschatimme / elm-phoenix"
      , repo = "https://github.com/saschatimme/elm-phoenix"
      , language = "Elm"
      , overview = "Integration between Elm and Phoenix Channels; contributed features, fixes, docs, and example code from production use."
      , shortInvolvement = "core"
      , involvement = "Having used elm-phoenix in production I've contributed several features, bug fixes, documentation and example code."
      }
    ]
