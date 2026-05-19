module Experimental.Data exposing
    ( Data
    , ExperienceColumns
    , Institution
    , IntroSection
    , OpenSourceProject
    , Position
    , Project
    , Skill
    , SkillGroup
    , Variant(..)
    , education
    , experience
    , experienceColumnsFor
    , experiencePositionsFor
    , introduction
    , introductionParagraphsFor
    , name
    , openSourceProjects
    , pdfFileFor
    , positionTitle
    , sidePanelLabels
    , skillGroupsFor
    , tagline
    , taglineFor
    , variantFromPath
    , variantPath
    )

import Data.Skills


type Variant
    = Leadership
    | Engineer
    | Elixir


variantFromPath : String -> Variant
variantFromPath path =
    case String.toLower (String.trim path) of
        "/engineer" ->
            Engineer

        "/engineer/" ->
            Engineer

        "/elixir" ->
            Elixir

        "/elixir/" ->
            Elixir

        _ ->
            Leadership


variantPath : Variant -> String
variantPath variant =
    case variant of
        Leadership ->
            "/"

        Engineer ->
            "/engineer"

        Elixir ->
            "/elixir"


pdfFileFor : Variant -> String
pdfFileFor variant =
    case variant of
        Leadership ->
            "Oliver-Searle-Barnes-CTO-2026.pdf"

        Engineer ->
            "Oliver-Searle-Barnes-Engineer-2026.pdf"

        Elixir ->
            "Oliver-Searle-Barnes-Senior-Elixir-Engineer-2026.pdf"


type alias Data =
    { name : String
    , tagline : String
    , introduction : List IntroSection
    , experience : List Position
    , education : List Institution
    , skills : List Skill
    , openSource : List OpenSourceProject
    }


type alias IntroSection =
    { name : String
    , body : String
    }


type alias Position =
    { title : String
    , engineerTitle : String
    , elixirTitle : String
    , location : String
    , company : String
    , companyStack : List String
    , projects : List Project
    , dates : String
    }


positionTitle : Variant -> Position -> String
positionTitle variant position =
    case variant of
        Leadership ->
            position.title

        Engineer ->
            position.engineerTitle

        Elixir ->
            position.elixirTitle


taglineFor : Variant -> String
taglineFor variant =
    case variant of
        Leadership ->
            "Passionate full-stack tech leader"

        Engineer ->
            "Hands-on full-stack engineer"

        Elixir ->
            "Senior Elixir / Phoenix engineer · 10+ years production OTP"


sidePanelLabels : Variant -> List String
sidePanelLabels variant =
    case variant of
        Leadership ->
            [ "Passionate full stack leader"
            , "Founder, CTO, VP Engineering, Architect"
            , "22 Years experience"
            ]

        Engineer ->
            [ "Hands-on full-stack engineer"
            , "Staff Engineer, Tech Lead, Architect"
            , "22 years experience"
            ]

        Elixir ->
            [ "Senior Elixir engineer · Tech Lead · Architect"
            , "Phoenix, Ecto, distributed BEAM, Postgres, AWS"
            , "22 years across SaaS, fintech, AI"
            ]


introductionParagraphsFor : Variant -> List String
introductionParagraphsFor variant =
    case variant of
        Leadership ->
            sharedIntroductionParagraphs

        Engineer ->
            sharedIntroductionParagraphs

        Elixir ->
            [ "Barcelona-based · UK citizen, full UK RTW · operating via Thoughtclay Ltd (UK) · EU-TZ, London-hours overlap."
            , "Senior Elixir / Phoenix engineer with 10+ years shipping production OTP at scale. Built Open Banking integration across UK high street banks at CompareTheMarket (Bean), API authorization and rate-limiting at Boulevard (US salon-SaaS unicorn), IoT cloud services on Phoenix at Vorwerk, and an event-sourced real-time community platform at Zapnito."
            , "Comfortable owning supervision-tree design, telemetry / observability, and Ecto-heavy data layers. Most recently co-founder and tech lead at XP Flow, building production AI agents on Next.js."
            , "All client engagements delivered through Thoughtclay Ltd, my UK Ltd Co. Available for senior Elixir IC, tech-lead, or fractional CTO engagements."
            ]


sharedIntroductionParagraphs : List String
sharedIntroductionParagraphs =
    [ "Building software that people actually love to use is what gets me going. With 22 years experience I've delivered successful products for the AI, Fintech, SaaS, Telecoms, Retail, Publishing, Energy, Charity, Health and Beauty, and Domestic appliance sectors."
    , "I've led teams building computer vision training pipelines at TwentyBN, Open Banking integration across UK high street banks at CompareTheMarket, IoT cloud services for commercial robot vacuums at Vorwerk, an event-sourced real-time community platform at Zapnito, and a WebDAV-based CMS that let Informa's journalists edit articles directly in Microsoft Word."
    , "Most recently founding engineer at XP Flow; previously co-founded a school e-commerce business later taken in-house by Marks & Spencer."
    , "Agile from day one; comfortable owning the engineering function or contributing within an established team."
    ]


skillGroupsFor : Variant -> List SkillGroup
skillGroupsFor variant =
    case variant of
        Leadership ->
            Data.Skills.leadershipFirst

        Engineer ->
            Data.Skills.leadershipLast

        Elixir ->
            Data.Skills.leadershipFirst


type alias ExperienceColumns =
    { left : List Position
    , right : List Position
    }


experienceColumnsFor : Variant -> ExperienceColumns
experienceColumnsFor variant =
    case variant of
        Leadership ->
            { left =
                [ experience.xpflow
                , experience.tree3
                , experience.tastermonial
                , experience.boulevard
                , experience.vorwerk
                , experience.ctm
                , experience.twentyBn
                ]
            , right =
                [ experience.liqid
                , experience.zapnito
                , experience.lytbulb
                , experience.myschooldirect
                , experience.informa
                ]
            }

        Engineer ->
            { left =
                [ engineerXpflow
                , experience.tastermonial
                , experience.boulevard
                , experience.vorwerk
                , experience.ctm
                , experience.twentyBn
                ]
            , right =
                [ experience.liqid
                , experience.zapnito
                , experience.lytbulb
                , experience.myschooldirect
                , experience.informa
                ]
            }

        Elixir ->
            { left =
                [ engineerXpflow
                , experience.tastermonial
                , experience.boulevard
                , experience.vorwerk
                , experience.ctm
                ]
            , right =
                [ experience.liqid
                , experience.zapnito
                , experience.twentyBn
                , experience.myschooldirect
                , experience.informa
                ]
            }


experiencePositionsFor : Variant -> List Position
experiencePositionsFor variant =
    let
        columns =
            experienceColumnsFor variant
    in
    columns.left ++ columns.right


engineerXpflow : Position
engineerXpflow =
    { title = "Tech Lead"
    , engineerTitle = "Tech Lead"
    , elixirTitle = "Tech Lead"
    , location = "Dallas / Remote"
    , company = "Tree3 / XP Flow"
    , companyStack = [ "Next.js", "AI agents" ]
    , dates = "Jan 2024-Apr 2026"
    , projects = experience.xpflow.projects ++ experience.tree3.projects
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


name =
    "Oliver Searle-Barnes"


tagline =
    "Full stack web developer"


introduction =
    [ { name = "Business focused"
      , body = "Building software that people actually like to use is what gets me going. With over 22 years experience I've delivered successful products for the Telecoms, Retail, Publishing, Energy and Charity sectors. I've led teams to build a wide variety of projects including realtime social platforms and project management tools, business Intelligence, custom content management systems, online stores and browser extensions. "
      }
    , { name = "Agile", body = "From day one I've been an agile practitioner, whether it's Scrum or Kanban, Lean, BDD, outside-in, pair-programming, you name it, I've been doing it for years. I've usually led from the front but I’m comfortable working in many different styles and value project consistency over personal preferences so am equally comfortable working alone or slotting into an existing team." }
    ]


experience =
    { xpflow =
        { title = "Founding AI Engineer & CPO"
        , engineerTitle = "Founding AI Engineer"
        , elixirTitle = "Co-founder, Tech Lead"
        , location = "Dallas / Remote"
        , company = "XP Flow"
        , companyStack = [ "Next.js", "AI agents" ]
        , dates = "Feb 2025-Apr 2026"
        , projects =
            [ { name = "Alfie (AI affiliate recruitment)"
              , start = 2025
              , end = 2026
              , overview = "Built Alfie, AI agent scouts that autonomously discover, evaluate, and reach out to affiliate partners, learning user preferences. Shipped MVP in three weeks and validated strong demand. On-demand scale limits informed the company's next phase: building the world's largest affiliate database."
              , stack = [ "AI/LLMs", "NextJS", "Postgres" ]
              , talkingPoints =
                    [ "Specified LLM-driven evaluation and personalised outreach pipelines, replacing multi-day manual research with a fully autonomous agent workflow."
                    , "Drove integrations with affiliate networks (Everflow) and built the plan-based subscription model on Stripe."
                    , "Ran the customer discovery that identified the opportunity and proposed the AI-powered direction the company spun out around."
                    ]
              }
            ]
        }
    , tree3 =
        { title = "Consultant"
        , engineerTitle = "Tech Lead"
        , elixirTitle = "Tech Lead"
        , location = "Dallas / Remote"
        , company = "Tree3"
        , companyStack = [ "Next.js", "Postgres", "Redis" ]
        , dates = "Jan 2024-Feb 2025"
        , projects =
            [ { name = "XP Affiliate Platform"
              , start = 2024
              , end = 2025
              , overview = "Led engineering on a high-performance affiliate platform. When the product stalled, ran customer discovery and proposed an AI-powered affiliate recruitment product, spun out as XP Flow with me on the founding team."
              , stack = [ "NextJS", "Postgres", "Redis" ]
              , talkingPoints =
                    [ "Led the engineering team delivering the affiliate platform on NextJS / Postgres / Redis."
                    , "Ran the customer discovery process that identified the product-market gap behind the commercial stall."
                    , "Proposed and architected the AI-powered recruitment direction that became Alfie and spun out as XP Flow."
                    ]
              }
            ]
        }
    , tastermonial =
        { title = "Interim CTO"
        , engineerTitle = "Interim CTO"
        , elixirTitle = "Interim CTO"
        , location = "Cupertino / Remote"
        , company = "Tastermonial"
        , companyStack = [ "Elixir", "Phoenix", "Flutter" ]
        , dates = "Jul 2023-Dec 2023"
        , projects =
            [ { name = "Tastermonial App"
              , start = 2023
              , end = 2023
              , overview = "Replaced the previous MVP with a high-performance Flutter/Phoenix mobile app on AWS. Inherited unstable code, slow performance, and no deployment infrastructure; rebuilt the engineering function with CI/CD pipelines from scratch and left the team set up to continue independently."
              , stack = [ "Elixir", "Flutter", "Sqlite", "Postgres", "AWS/Terraform" ]
              , talkingPoints =
                    [ "Inherited unstable code, slow performance and no deployment infrastructure; left the engineering function stable and scalable."
                    , "Established CI/CD pipelines from scratch on AWS, managed via Terraform."
                    , "Closed the engagement cleanly with the team set up to continue independently."
                    ]
              }
            ]
        }
    , boulevard =
        { title = "Consultant"
        , engineerTitle = "Senior Engineer"
        , elixirTitle = "Senior 2 Engineer"
        , location = "Los Angeles / Remote"
        , company = "Boulevard"
        , companyStack = [ "Elixir", "Phoenix", "React" ]
        , dates = "Oct 2021-Jun 2023"
        , projects =
            [ { name = "API and Platform Services"
              , start = 2021
              , end = 2023
              , overview = "Joined the API team at this health and beauty unicorn. Designed the API authorization model, built the third-party App Store, introduced rate limiting under high-volume load, and resolved performance bottlenecks across the API surface."
              , stack = [ "Elixir", "Absinthe", "Postgres", "React", "Typescript", "AWS/Terraform" ]
              , talkingPoints =
                    [ "Designed and shipped the API authorization model governing how permissions are evaluated across services."
                    , "Built out the third-party App Store, enabling external developers to integrate with the platform."
                    , "Introduced rate limiting across the API to protect platform stability under high-volume load."
                    , "Identified and resolved performance bottlenecks across the API surface."
                    , "HIPAA logging & compliance: biggest body of work. Introduced Blvd.Hipaa.Logger, log events, user enrichment, ctx graphs; tracked create/find/update/delete on Client, custom-form ops, and shadowing-aware field masking (Absinthe middleware). Tickets: API-635, API-742, API-630."
                    , "Encrypted appointment notes, multi-PR migration (API-781): introduced encrypted column, migrated clear-text notes/private_notes, updated CalendarEvents view (v2→v3→v4), dropped legacy columns. Also migrated client medications/allergies to Notes."
                    , "Rate limiting: built the leaky-bucket rate limiter for GraphQL pipelines (API-369), per-API-application quotas, per-pipeline custom policies, throttling feature flag, telemetry attributes, property tests, and corrupt-bucket recovery."
                    , "Webhooks: migrated webhooks from Exq → Oban (twice, second time stuck), added retries (API-287), appointment.updated event (API-1566)."
                    , "App platform / developer portal: app suspensions & reinstatement (API-1466), default app quotas (API-1408), sandbox createClient (API-1433), app uninstall cleanup (API-1370), app enrichment for Datadog (API-1415), icons + install counts, dev-portal devn envs."
                    , "Observability: OpenTelemetry APM (API-288), Absinthe query logging (API-831), login observability (API-1590), flaky-test author notifications, ExtCache.cached_all."
                    , "GraphQL infra: custom Absinthe response mapping so the rate limiter can return 429s (API-941), TestApi graph, appointment-reschedule mutations in PlatformAdmin (API-284 / API-974), appointmentRescheduleSeries."
                    , "Auth: passwordless email/SMS cart checkout, Zapier OAuth for multi-business staff (API-676), better multi-client auth errors (API-827), an in-progress security-settings feature (API-1591)."
                    , "Dev tooling: introduced and grew the justfile, auto AWS SSO login, psql instance routing, replica-DB read paths, dialyzer :contracts enforcement, a credo check to ban :meck in async tests."
                    ]
              }
            ]
        }
    , vorwerk =
        { title = "Consultant"
        , engineerTitle = "Tech Lead"
        , elixirTitle = "Tech Lead"
        , location = "Wuppertal / Remote"
        , company = "Vorwerk"
        , companyStack = [ "Elixir", "Python" ]
        , dates = "Apr 2021-Sep 2021"
        , projects =
            [ { name = "Kobold"
              , start = 2021
              , end = 2021
              , overview = "Bootstrapped an Elixir team at this global consumer appliance giant to provide cloud services and a Python client library for a new line of commercial robot vacuum cleaners."
              , stack = [ "Elixir", "Python", "Postgres", "AWS/Terraform" ]
              , talkingPoints =
                    [ "Established the Elixir/Phoenix backend from scratch and built the Python client library for the device-side integration."
                    , "Led the team through the technical foundation work and set up the development workflow."
                    , "Shipped to production on schedule for the commercial launch."
                    ]
              }
            ]
        }
    , ctm =
        { title = "Consultant"
        , engineerTitle = "Senior Engineer"
        , elixirTitle = "Senior Elixir Engineer"
        , location = "London / Remote"
        , company = "CompareThe\nMarket.com"
        , companyStack = [ "Elixir", "Phoenix" ]
        , dates = "Feb 2019-Apr 2021"
        , projects =
            [ { name = "MoneyHub"
              , start = 2019
              , end = 2021
              , overview = "Rebuilt Bean.com as a high-performance Elixir service for this leading UK price-comparison site, integrating the majority of UK high street banks via Open Banking. Navigated the regulatory complexity of FCA-authorised account information services."
              , stack = [ "Elixir", "GraphQL", "Elm", "Javascript", "Ruby", "Postgres", "AWS" ]
              , talkingPoints =
                    [ "Navigated the regulatory and technical complexity of FCA-authorised account information services."
                    , "Took the product from its earlier implementation to a substantially faster, more reliable platform able to support the customer base at scale."
                    , "Bean lets users manage subscriptions across all their accounts in one place; long-running engagement spanned the rebuild and subsequent feature work."
                    ]
              }
            ]
        }
    , twentyBn =
        { title = "Consultant"
        , engineerTitle = "Senior Engineer"
        , elixirTitle = "Senior Engineer"
        , location = "Berlin / Remote"
        , company = "TwentyBN"
        , companyStack = [ "Elm", "JavaScript" ]
        , dates = "Aug–Dec 2018"
        , projects =
            [ { name = "Video Annotation Editor"
              , start = 2018
              , end = 2018
              , overview = "Designed and built two Elm apps to collect video gesture training data from Amazon Mechanical Turk workers for this computer vision AI company. Annotation workflows fed directly into the model training pipelines; frontend engineering at the intersection of AI data infrastructure."
              , stack = [ "Elm", "Javascript" ]
              , talkingPoints =
                    [ "Designed the annotation workflows and built the interfaces that fed directly into TwentyBN's model training pipelines."
                    , "Worked at the intersection of front-end engineering and AI data infrastructure, ensuring captured data was structured to support downstream training."
                    ]
              }
            ]
        }
    , liqid =
        { title = "Consultant"
        , engineerTitle = "Senior Backend Engineer"
        , elixirTitle = "Senior Elixir Engineer"
        , location = "Berlin / Remote"
        , company = "Liqid"
        , companyStack = [ "Elixir", "RabbitMQ", "Rails" ]
        , dates = "Jan–Aug 2018"
        , projects =
            [ { name = "Salesforce Integration"
              , start = 2018
              , end = 2018
              , overview = "Built an Elixir/RabbitMQ microservice connecting this wealth management fintech's Rails platform to Salesforce, supporting CRM and operational workflows. Used RabbitMQ for asynchronous, reliable message delivery across the integration boundary."
              , stack = [ "Elixir", "Ruby on Rails", "RabbitMQ", "Salesforce", "Docker", "GraphQL" ]
              , talkingPoints =
                    [ "Designed and shipped the microservice connecting the Rails platform to Salesforce, supporting CRM and operational workflows."
                    , "Used RabbitMQ for asynchronous, reliable message delivery across the integration boundary."
                    ]
              }
            ]
        }
    , zapnito =
        { title = "VP Engineering"
        , engineerTitle = "Engineering Lead"
        , elixirTitle = "Engineering Lead"
        , location = "London / Remote"
        , company = "Zapnito"
        , companyStack = [ "Elixir", "Phoenix", "Elm" ]
        , dates = "Jan 2015–Jan 2018"
        , projects =
            [ { name = "Feeds"
              , start = 2016
              , end = 2017
              , overview = "Led the development of a white-labelled realtime community platform. Implemented an event-sourcing architecture on top of Phoenix Channels for the realtime front end, designed an embedding API with widgets and SSO integration for 3rd-party platforms, and built full-stack testing infrastructure running multiple concurrent browser instances."
              , stack = [ "Phoenix", "Phoenix-Channels", "Elixir", "Elm", "Javascript", "JWT", "Auth0", "Postgres", "Kanban", "BDD" ]
              , talkingPoints =
                    [ "Implemented an Event Sourcing architecture to power the realtime front end built on top of Phoenix's websocket based channels."
                    , "Designed API for embedding product within 3rd party platforms including a variety of widgets and seamless integration with Single Sign On."
                    , "Built testing infrastructure that allowed full stack testing in multiple concurrent browser instances."
                    ]
              }

            -- , { name = "Knowledge Networks"
            --   , start = 2014
            --   , end = 2017
            --   , overview = "Tech lead and architect for an expert focused content management system and online training platform."
            --   , stack = [ "Ruby on Rails", "ember.js", "Javascript", "Postgres", "Redis", "Memcached", "Solr", "Kanban", "BDD" ]
            --   , talkingPoints =
            --         [ "Built video discussion feature including recording facilities."
            --         , "Built theming system that included a ruby command line tool allowing designers to build and release themes independently of the main app release process."
            --         , "Refined core architecture to focus on consistent content management."
            --         , "Performance work to optimise load time of site"
            --         , "Introduced and rolled out ember.js across the app to modernise user experience."
            --         ]
            --   }
            ]
        }
    , lytbulb =
        { title = "CTO"
        , engineerTitle = "CTO"
        , elixirTitle = "CTO"
        , location = "London / Remote"
        , company = "Lytbulb"
        , companyStack = [ "Rails", "Ember", "Firebase" ]
        , dates = "2014–2015"
        , projects =
            [ { name = "lytbulb.com"
              , start = 2014
              , end = 2015
              , overview = "Led development of a trello-like product aimed at the energy sector, focusing on oil and gas."
              , stack = [ "Ruby on Rails", "Ember.js", "Firebase", "Postgres", "Kanban", "BDD" ]
              , talkingPoints =
                    [ "Built realtime kanban board using firebase backend"
                    , "Developed workflow system based around typical oil and gas projects"
                    ]
              }
            ]
        }
    , myschooldirect =
        { title = "CTO & Co-founder"
        , engineerTitle = "CTO & Co-founder"
        , elixirTitle = "CTO & Co-founder"
        , location = "London / Remote"
        , company = "Myschooldirect"
        , companyStack = [ "Rails", "Postgres", "Ember" ]
        , dates = "2010–2014"
        , projects =
            [ { name = "Myschooldirect & Give4Sure (M&S acquisition, 2014)"
              , start = 2010
              , end = 2014
              , overview = "Quidco-style school-shopping platform with a browser-extension companion (Give4Sure) and a bespoke Marks & Spencer school-uniform store line. The M&S uniform line was acquired by Marks & Spencer in 2014 and taken in-house."
              , stack = [ "Browser extensions", "Ruby on Rails", "Postgres", "Ember.js" ]
              , talkingPoints = []
              }
            ]
        }
    , informa =
        { title = "Tech lead/Architect"
        , engineerTitle = "Tech Lead / Architect"
        , elixirTitle = "Tech Lead / Architect"
        , location = "London"
        , company = "Informa"
        , companyStack = [ "Java", "Spring", "Oracle" ]
        , dates = "2005-2010"
        , projects =
            [ { name = "World Cellular Information Service"
              , start = 2007
              , end = 2008
              , stack = [ "Java", "Spring", "MS Analytics services", "Oracle DB", "Scrum", "TDD" ]
              , overview = "Led team to replace Informa Telecom's flagship product (WCIS), a mobile markets intelligence platform covering 226 countries."
              , talkingPoints =
                    [ "Used incremental approach with frequent releases to gradually shift product over to new architecture without disrupting the live service or requiring parallel development."
                    , "Introduced clover to track test coverage and promote a TDD approach"
                    ]
              }
            -- , { name = "World Broadband Information Service"
            --   , start = 2005
            --   , end = 2006
            --   , stack = [ "Java", "Spring", "OLAP", "Mondrian", "Oracle DB", "Scrum", "TDD" ]
            --   , overview = "Developed a BI portal based on the Mondrian OLAP engine."
            --   , talkingPoints =
            --         [ "Developed algorithms to integrate noisy/conflicting data provided by hundreds of different businesses"
            --         , "Introduced Scrum for more effective project management"
            --         , "Introduced maven to standardise build process"
            --         ]
            --   }
            , { name = "Intelligence Centre 2"
              , start = 2008
              , end = 2010
              , stack = [ "Java/Spring", "Oracle DB", "Scrum", "BDD" ]
              , overview = "Devised a webdav based CMS allowing Journalists to edit articles in MS Word."
              , talkingPoints =
                    [ "Devised a webdav based system that allowed journalists to edit articles directly in MS Word. The system allowed journalists to hit save in Word and instantly see a preview on the live site."
                    ]
              }
            ]
        }
    }


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


openSourceProjects =
    [ { name = "fncasts / fnchess"
      , repo = "https://github.com/fncasts/fnchess"
      , language = "Elm/Elixir"
      , overview = "Paired with a friend on youtube to build a chess game in Elm backend by Phoenix-Channels for realtime. See https://fncasts.io for the episodes."
      , shortInvolvement = "owner"
      , involvement = ""
      }
    , { name = "orbitjs / orbit"
      , repo = "https://github.com/orbitjs/orbit"
      , language = "javascript"
      , overview = "A javascript library for orchestrating data synchronization. See http://orbitjs.com for more information."
      , shortInvolvement = "core"
      , involvement = "For 2 years I was a core contributor working with Dan Gebhard (co-author of the jsonapi spec), contributing code and discussing architectural direction"
      }
    , { name = "saschatimme / elm-phoenix"
      , repo = "https://github.com/saschatimme/elm-phoenix"
      , language = "Elm"
      , overview = "Integration between Elm and Phoenix channels"
      , shortInvolvement = "core"
      , involvement = "Having used elm-phoenix in production I've contributed several features, bug fixes, documentation and example code"
      }
    , { name = "opsb / cv-elm"
      , repo = "https://github.com/opsb/cv-elm"
      , language = "Elm"
      , overview = "The code used to generate the CV you're reading right now"
      , shortInvolvement = "owner"
      , involvement = "I wanted a CV that made it convenient to update the content or design so I built this one in Elm."
      }
    ]
