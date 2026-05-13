module Data exposing
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
            sharedIntroductionParagraphs


sharedIntroductionParagraphs : List String
sharedIntroductionParagraphs =
    [ "Building software that people actually love to use is what gets me going. With 22 years experience I've delivered successful products for the AI, Fintech, SaaS, Telecoms, Retail, Publishing, Energy, Charity, Health and Beauty, and Domestic appliance sectors."
    , "I've led teams building computer vision training pipelines at TwentyBN, Open Banking integration across UK high street banks at CompareTheMarket, IoT cloud services for commercial robot vacuums at Vorwerk, an event-sourced real-time community platform at Zapnito, and a WebDAV-based CMS that let Informa's journalists edit articles directly in Microsoft Word."
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
                [ experience.twentyBn
                , experience.liqid
                , experience.zapnito
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
    { title = "Founding Engineer"
    , engineerTitle = "Founding Engineer"
    , elixirTitle = "Founding Engineer"
    , location = "Dallas / Remote"
    , company = "xpflow & Tree3"
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
        { title = "Founding Engineer & CPO"
        , engineerTitle = "Founding Engineer"
        , elixirTitle = "Co-founder, Tech Lead"
        , location = "Dallas / Remote"
        , company = "xpflow"
        , companyStack = [ "Next.js", "AI agents" ]
        , dates = "Feb 2025-Apr 2026"
        , projects =
            [ { name = "Alfie (AI affiliate-recruitment agent)"
              , start = 2025
              , end = 2026
              , overview = "Built and shipped a fleet of LLM agents that discover, evaluate, and contact affiliate partners on behalf of growth teams."
              , stack = [ "AI/LLMs", "NextJS", "Postgres" ]
              , talkingPoints =
                    [ "Per-tenant agent pipeline: discovery, evaluation, outreach."
                    , "Designed agentic learning loop on LangGraph."
                    , "Created harness for regression testing LLM prompts."
                    , "Built custom chat stack supporting in-chat widgets."
                    , "Integrated Stripe payments."
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
              , overview = "Led engineering on a high-performance affiliate platform."
              , stack = [ "NextJS", "Postgres", "Redis" ]
              , talkingPoints =
                    [ "Owned the platform architecture across click capture, attribution, and reliable postback delivery to partner endpoints."
                    , "Built dashboards for both Brands and Affiliates."
                    , "Ran the customer-discovery sprint that surfaced the underlying gap and proposed AI-powered affiliate recruitment as the response."
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
              , overview = "Rebuilt the platform end-to-end: an unstable iOS MVP became a production-grade Phoenix/Flutter app on iOS + Android."
              , stack = [ "Elixir", "Flutter", "Sqlite", "Postgres", "AWS/Terraform" ]
              , talkingPoints =
                    [ "Inherited customers with active reliability complaints."
                    , "Rebuilt the backend on Phoenix/Elixir for production-grade reliability."
                    , "Rebuilt the mobile app on Flutter, iOS + Android."
                    , "Established development practices Kanban, BDD, CI, Terraform infra, etc."
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
              , overview = "Joined the API team at this health & beauty unicorn, shipping core platform infrastructure."
              , stack = [ "Elixir", "Postgres", "React", "Typescript", "AWS/Terraform" ]
              , talkingPoints =
                    [ "Led HIPAA compliance across entire platform."
                    , "Designed the API authorization model governing permission evaluation across services."
                    , "Built the third-party App Store enabling external developer integrations."
                    , "Built the GraphQL rate limiter with per-application quotas and per-pipeline policies."
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
              , overview = "Bootstrapped an Elixir team at this consumer appliance giant, building cloud services for a new line of commercial robot vacuum cleaners."
              , stack = [ "Elixir", "Python", "Postgres", "AWS/Terraform" ]
              , talkingPoints =
                    [ "Established the Elixir backend and Python client library from scratch."
                    , "Set up the development workflow and shipped to production on schedule for the commercial launch."
                    ]
              }
            ]
        }
    , ctm =
        { title = "Consultant"
        , engineerTitle = "Senior Engineer"
        , elixirTitle = "Tech Lead"
        , location = "London / Remote"
        , company = "CompareThe\nMarket.com"
        , companyStack = [ "Elixir", "Phoenix" ]
        , dates = "Feb 2019-Apr 2021"
        , projects =
            [ { name = "MoneyHub"
              , start = 2019
              , end = 2021
              , overview = "Rebuilt Bean.com as a high-performance Elixir service for this leading UK price-comparison site."
              , stack = [ "Elixir", "GraphQL", "Elm", "Javascript", "Ruby", "Postgres", "AWS" ]
              , talkingPoints =
                    [ "Integrated the majority of UK high street banks via the Open Banking specification."
                    , "Navigated the regulatory and technical complexity of FCA-authorised account information services."
                    , "Replacement platform enabled scale to support the substantial CompareTheMarket.com customer base."
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
              , overview = "Designed and built two Elm apps to collect video gesture training data from Mechanical Turk workers for this computer vision AI company."
              , stack = [ "Elm", "Javascript" ]
              , talkingPoints =
                    [ "Annotation workflows fed directly into TwentyBN's model training pipelines."
                    , "Worked at the intersection of frontend engineering and AI data infrastructure."
                    ]
              }
            ]
        }
    , liqid =
        { title = "Consultant"
        , engineerTitle = "Senior Backend Engineer"
        , elixirTitle = "Senior Engineer"
        , location = "Berlin / Remote"
        , company = "Liqid"
        , companyStack = [ "Elixir", "RabbitMQ", "Rails", "Salesforce" ]
        , dates = "Jan–Aug 2018"
        , projects =
            [ { name = "Salesforce Integration"
              , start = 2018
              , end = 2018
              , overview = "Integrated this wealth management fintech's Rails platform with Salesforce using an elixir microservice."
              , stack = [ "Elixir", "Ruby on Rails", "RabbitMQ", "Salesforce", "Docker", "GraphQL" ]
              , talkingPoints =
                    [ "Designed and shipped the microservice supporting CRM and operational workflows."
                    , "Used RabbitMQ for asynchronous, reliable message delivery across the integration boundary."
                    ]
              }
            ]
        }
    , zapnito =
        { title = "VP Engineering"
        , engineerTitle = "Engineering Lead"
        , elixirTitle = "VP Engineering"
        , location = "London / Remote"
        , company = "Zapnito"
        , companyStack = [ "Elixir", "Phoenix Channels", "Elm" ]
        , dates = "Jan 2015–Jan 2018"
        , projects =
            [ { name = "Feeds"
              , start = 2016
              , end = 2017
              , overview = "Hands-on VP Engineering at Zapnito, leading delivery of Feeds, a white-labelled realtime community platform serving multiple B2B publishers."
              , stack = [ "Phoenix", "Phoenix-Channels", "Elixir", "Elm", "Javascript", "JWT", "Auth0", "Postgres", "Kanban", "BDD" ]
              , talkingPoints =
                    [ "Built slack like experience built on Phoenix Channels."
                    , "Created multi widget kit for embedding within client apps."
                    , "Built end-to-end testing infrastructure allowing multiple instances of the app to run in parallel in a single BEAM VM."
                    , "Hired and grew the engineering team across the period."
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
        , companyStack = [ "Rails", "Browser extensions", "Ember" ]
        , dates = "2010–2014"
        , projects =
            [ { name = "Myschooldirect & Give4Sure (M&S acquisition, 2014)"
              , start = 2010
              , end = 2014
              , overview = "Co-founded a Quidco-style school-shopping affiliate platform with a browser-extension companion (Give4Sure) and a bespoke Marks & Spencer school-uniform store line."
              , stack = [ "Browser extensions", "Ruby on Rails", "Postgres", "Ember.js" ]
              , talkingPoints =
                    [ "M&S uniform line acquired by Marks & Spencer in 2014 and taken in-house."
                    , "Built browser extension to handle high volume with low infrastructure costs."
                    , "Developed a monitoring system to detect broken/incorrect affiliate links from third-party networks."
                    , "Devised a compression-based algorithm for identifying when web pages matched within a given tolerance."
                    , "Integrated multiple affiliate networks and automated tracking of purchases and payments to schools."
                    ]
              }
            ]
        }
    , informa =
        { title = "Tech lead/Architect"
        , engineerTitle = "Tech Lead & Architect"
        , elixirTitle = "Tech Lead & Architect"
        , location = "London"
        , company = "Informa"
        , companyStack = [ "Java", "Spring", "Oracle" ]
        , dates = "2005-2010"
        , projects =
            [ { name = "World Cellular Information Service"
              , start = 2007
              , end = 2008
              , stack = [ "Java", "Spring", "MS Analytics services", "Oracle DB", "Scrum", "TDD" ]
              , overview = "Led the team replacing Informa Telecom's flagship product (WCIS) — a mobile markets intelligence platform covering 226 countries."
              , talkingPoints =
                    [ "Used incremental releases to migrate the live service to a new architecture without disrupting customers or requiring parallel development."
                    , "Introduced Clover for test coverage and drove the adoption of TDD across the team."
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
              , overview = "Devised a WebDAV-based CMS allowing journalists to edit articles directly in Microsoft Word."
              , talkingPoints =
                    [ "Journalists could hit Save in Word and instantly see a preview on the live site, eliminating editorial workflow friction for time-sensitive publication."
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
      , result = "2/1"
      , startYear = 2001
      , endYear = 2004
      }
    ]


openSourceProjects =
    [ { name = "fncasts / fnchess"
      , repo = "https://github.com/fncasts/fnchess"
      , language = "Elm/Elixir"
      , overview = "The chess game built on the FnCasts channel"
      , shortInvolvement = "owner"
      , involvement = ""
      }
    , { name = "orbitjs / orbit"
      , repo = "https://github.com/orbitjs/orbit"
      , language = "javascript"
      , overview = "Data syncing framework"
      , shortInvolvement = "core"
      , involvement = "For 2 years I was a core contributor working with Dan Gebhard (co-author of the jsonapi spec), contributing code and discussing architectural direction"
      }
    , { name = "saschatimme / elm-phoenix"
      , repo = "https://github.com/saschatimme/elm-phoenix"
      , language = "Elm"
      , overview = "Integration between Phoenix channels and Elm"
      , shortInvolvement = "core"
      , involvement = "Having used elm-phoenix in production I've contributed several features, bug fixes, documentation and example code"
      }
    , { name = "opsb / cv-elm"
      , repo = "https://github.com/opsb/cv-elm"
      , language = "Elm"
      , overview = "The CV you're reading"
      , shortInvolvement = "owner"
      , involvement = "I wanted a CV that made it convenient to update the content or design so I built this one in Elm."
      }
    ]
