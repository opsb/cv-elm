module LeadershipData exposing
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

{-| Per-variant content module isolated to `/` and `/engineer`. Edits here
do not affect `/elixir`, `/elixir-ats`, or `/experimental`, which carry
their own content. Content originates from the pre-/elixir-customisation
state of `Data.elm` (commit 319030a^) plus the modern `companyStack` and
`introductionParagraphsFor` additions needed by the shared view code.

Skills are sourced from `Data.Skills.master` so every CV variant shares a
single source of truth for skill names and years.
-}

import Data.Skills


type Variant
    = Leadership
    | Engineer


variantFromPath : String -> Variant
variantFromPath path =
    case String.toLower (String.trim path) of
        "/engineer" ->
            Engineer

        "/engineer/" ->
            Engineer

        _ ->
            Leadership


variantPath : Variant -> String
variantPath variant =
    case variant of
        Leadership ->
            "/"

        Engineer ->
            "/engineer"


pdfFileFor : Variant -> String
pdfFileFor variant =
    case variant of
        Leadership ->
            "Oliver-Searle-Barnes-CTO-2026.pdf"

        Engineer ->
            "Oliver-Searle-Barnes-Engineer-2026.pdf"


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


taglineFor : Variant -> String
taglineFor variant =
    case variant of
        Leadership ->
            "Passionate full-stack tech leader"

        Engineer ->
            "Hands-on full-stack engineer"


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


introductionParagraphsFor : Variant -> List String
introductionParagraphsFor _ =
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
    , location = "Dallas / Remote"
    , company = "Tree3 / xpflow"
    , companyStack = []
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


name : String
name =
    "Oliver Searle-Barnes"


tagline : String
tagline =
    "Full stack web developer"


introduction : List IntroSection
introduction =
    [ { name = "Business focused"
      , body = "Building software that people actually like to use is what gets me going. With over 22 years experience I've delivered successful products for the Telecoms, Retail, Publishing, Energy and Charity sectors."
      }
    , { name = "Agile"
      , body = "From day one I've been an agile practitioner, whether it's Scrum or Kanban, Lean, BDD, outside-in, pair-programming, you name it, I've been doing it for years."
      }
    ]


experience :
    { xpflow : Position
    , tree3 : Position
    , tastermonial : Position
    , boulevard : Position
    , vorwerk : Position
    , ctm : Position
    , twentyBn : Position
    , liqid : Position
    , zapnito : Position
    , lytbulb : Position
    , myschooldirect : Position
    , informa : Position
    }
experience =
    { xpflow =
        { title = "Founding Engineer & CPO"
        , engineerTitle = "Founding Engineer"
        , location = "Dallas / Remote"
        , company = "xpflow"
        , companyStack = []
        , dates = "Feb 2025-Apr 2026"
        , projects =
            [ { name = "Alfie (AI affiliate recruitment)"
              , start = 2025
              , end = 2026
              , overview = "Built Alfie, AI agent scouts that autonomously discover, evaluate, and reach out to affiliate partners, learning user preferences. Shipped MVP in three weeks and validated strong demand. On-demand scale limits informed the company's next phase: building the world's largest affiliate database."
              , stack = [ "AI/LLMs", "NextJS", "Postgres" ]
              , talkingPoints = []
              }
            ]
        }
    , tree3 =
        { title = "Consultant"
        , engineerTitle = "Tech Lead"
        , location = "Dallas / Remote"
        , company = "Tree3"
        , companyStack = []
        , dates = "Jan 2024-Feb 2025"
        , projects =
            [ { name = "XP Affiliate Platform"
              , start = 2023
              , end = 2025
              , overview = "Led engineering on a high-performance affiliate platform. When the product stalled, ran customer discovery and proposed an AI-powered affiliate recruitment product, spun out as xpflow with me on the founding team."
              , stack = [ "NextJS", "Postgres", "Redis" ]
              , talkingPoints = []
              }
            ]
        }
    , tastermonial =
        { title = "Interim CTO"
        , engineerTitle = "Interim CTO"
        , location = "Cupertino / Remote"
        , company = "Tastermonial"
        , companyStack = []
        , dates = "Jul 2023-Dec 2023"
        , projects =
            [ { name = "Tastermonial App"
              , start = 2023
              , end = 2023
              , overview = "Replaced MVP with a high-performance Flutter/Phoenix mobile app, running on AWS with supporting build pipelines."
              , stack = [ "Elixir", "Flutter", "Sqlite", "Postgres", "AWS/Terraform" ]
              , talkingPoints = []
              }
            ]
        }
    , boulevard =
        { title = "Consultant"
        , engineerTitle = "Senior Engineer"
        , location = "Los Angeles / Remote"
        , company = "Boulevard"
        , companyStack = []
        , dates = "Oct 2021-Jun 2023"
        , projects =
            [ { name = "API and Platform Services"
              , start = 2023
              , end = 2021
              , overview = "Joined the API team at this health and beauty unicorn to scale platform services and integrations with 3rd party services."
              , stack = [ "Elixir", "Postgres", "React", "Typescript", "AWS/Terraform" ]
              , talkingPoints = []
              }
            ]
        }
    , vorwerk =
        { title = "Consultant"
        , engineerTitle = "Tech Lead"
        , location = "Wuppertal / Remote"
        , company = "Vorwerk"
        , companyStack = []
        , dates = "Apr 2021-Sep 2021"
        , projects =
            [ { name = "Kobold"
              , start = 2021
              , end = 2021
              , overview = "Bootstrapped an Elixir/Phoenix team at this global consumer appliance giant to provide cloud services and a Python client for a new line of commercial robot vacuum cleaners."
              , stack = [ "Elixir", "Python", "Postgres", "AWS/Terraform" ]
              , talkingPoints = []
              }
            ]
        }
    , ctm =
        { title = "Consultant"
        , engineerTitle = "Senior Engineer"
        , location = "London / Remote"
        , company = "CompareThe\nMarket.com"
        , companyStack = []
        , dates = "Feb 2019-Apr 2021"
        , projects =
            [ { name = "MoneyHub"
              , start = 2019
              , end = 2021
              , overview = "Rebuilt Bean.com as a high-performance Elixir service for this leading UK price-comparison site, integrating the majority of high street banks via Open Banking."
              , stack = [ "Elixir", "GraphQL", "Elm", "Javascript", "Ruby", "Postgres", "AWS" ]
              , talkingPoints = []
              }
            ]
        }
    , twentyBn =
        { title = "Consultant"
        , engineerTitle = "Senior Engineer"
        , location = "Berlin / Remote"
        , company = "TwentyBN"
        , companyStack = []
        , dates = "Aug–Dec 2018"
        , projects =
            [ { name = "Video Annotation Editor"
              , start = 2018
              , end = 2018
              , overview = "Designed and built two Elm apps to collect video gesture training data from Amazon Mechanical Turk workers for this computer vision AI company."
              , stack = [ "Elm", "Javascript" ]
              , talkingPoints = []
              }
            ]
        }
    , liqid =
        { title = "Consultant"
        , engineerTitle = "Senior Backend Engineer"
        , location = "Berlin / Remote"
        , company = "Liqid"
        , companyStack = []
        , dates = "Jan–Aug 2018"
        , projects =
            [ { name = "Salesforce Integration"
              , start = 2018
              , end = 2018
              , overview = "Built an Elixir/RabbitMQ microservice to integrate this wealth management fintech's Rails app with Salesforce."
              , stack = [ "Elixir", "Ruby on Rails", "RabbitMQ", "Salesforce", "Docker", "GraphQL" ]
              , talkingPoints = []
              }
            ]
        }
    , zapnito =
        { title = "VP Engineering"
        , engineerTitle = "Engineering Lead"
        , location = "London / Remote"
        , company = "Zapnito"
        , companyStack = []
        , dates = "Jan 2015–Jan 2018"
        , projects =
            [ { name = "Feeds"
              , start = 2016
              , end = 2017
              , overview = "Led the development of a white-labelled realtime community platform."
              , stack = [ "Phoenix", "Phoenix-Channels", "Elixir", "Elm", "Javascript", "JWT", "Auth0", "Postgres", "Kanban", "BDD" ]
              , talkingPoints =
                    [ "Implemented an Event Sourcing architecture to power the realtime front end built on top of Phoenix's websocket based channels."
                    , "Designed API for embedding product within 3rd party platforms including a variety of widgets and seamless integration with Single Sign On."
                    , "Built testing infrastructure that allowed full stack testing in multiple concurrent browser instances."
                    ]
              }
            ]
        }
    , lytbulb =
        { title = "CTO"
        , engineerTitle = "CTO"
        , location = "London / Remote"
        , company = "Lytbulb"
        , companyStack = []
        , dates = "2014–2015"
        , projects =
            [ { name = "lytbulb.com"
              , start = 2014
              , end = 2015
              , overview = "Led development of a trello-like product aimed at the energy sector, focusing on oil and gas."
              , stack = [ "Ruby on Rails", "Ember.js", "Firebase", "Postgres", "Kanban", "BDD" ]
              , talkingPoints = []
              }
            ]
        }
    , myschooldirect =
        { title = "CTO & Co-founder"
        , engineerTitle = "CTO & Co-founder"
        , location = "London / Remote"
        , company = "Myschooldirect"
        , companyStack = []
        , dates = "2010–2014"
        , projects =
            [ { name = "Give4Sure"
              , start = 2012
              , end = 2014
              , overview = "A browser plugin helping shoppers raise money for their chosen charities."
              , stack = [ "Browser extensions", "Ruby on Rails", "Postgres", "Ember.js", "Kanban", "BDD" ]
              , talkingPoints = []
              }
            , { name = "Marks and Spencer School Uniforms"
              , start = 2011
              , end = 2012
              , overview = "An online store for schools to create their own Marks and Spencer uniforms; M&S later bought out the project and took it in-house."
              , stack = [ "Ruby on Rails", "Postgres", "Kanban", "BDD" ]
              , talkingPoints = []
              }
            , { name = "myschooldirect.com"
              , start = 2010
              , end = 2011
              , overview = "A Quidco style site helpers shoppers raise money for their children's school."
              , stack = [ "Ruby on rails", "Postgres", "Kanban", "BDD" ]
              , talkingPoints = []
              }
            ]
        }
    , informa =
        { title = "Tech lead/Architect"
        , engineerTitle = "Tech Lead / Architect"
        , location = "London"
        , company = "Informa"
        , companyStack = []
        , dates = "2005-2010"
        , projects =
            [ { name = "World Cellular Information Service"
              , start = 2007
              , end = 2006
              , stack = [ "Java", "Spring", "MS Analytics services", "Oracle DB", "Scrum", "TDD" ]
              , overview = "Led team to replace Informa Telecom's flagship product (WCIS), a mobile markets intelligence platform covering 226 countries."
              , talkingPoints = []
              }
            , { name = "World Broadband Information Service"
              , start = 2005
              , end = 2006
              , stack = [ "Java", "Spring", "OLAP", "Mondrian", "Oracle DB", "Scrum", "TDD" ]
              , overview = "Developed a BI portal based on the Mondrian OLAP engine."
              , talkingPoints = []
              }
            , { name = "Intelligence Centre 2"
              , start = 2008
              , end = 2010
              , stack = [ "Java/Spring", "Oracle DB", "Scrum", "BDD" ]
              , overview = "Devised a webdav based CMS allowing Journalists to edit articles in MS Word."
              , talkingPoints = []
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


openSourceProjects : List OpenSourceProject
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
