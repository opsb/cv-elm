module Data exposing (Data, Institution, IntroSection, OpenSourceProject, Position, Project, Skill, SkillGroup, education, experience, introduction, name, openSourceProjects, skillGroups, tagline)


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
    , location : String
    , company : String
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
    { name : String
    , years : Float
    }


type alias SkillGroup =
    { name : String
    , skills : List Skill
    }


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
        { title = "Co-founder & CPO"
        , location = "Dallas / Remote"
        , company = "xpflow"
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
        , location = "Dallas / Remote"
        , company = "Tree3"
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
        , location = "Cupertino / Remote"
        , company = "Tastermonial"
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
        , location = "Los Angeles / Remote"
        , company = "Boulevard"
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
        , location = "Wuppertal / Remote"
        , company = "Vorwerk"
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
        , location = "London / Remote"
        , company = "CompareThe\nMarket.com"
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
        , location = "Berlin / Remote"
        , company = "TwentyBN"
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
        , location = "Berlin / Remote"
        , company = "Liqid"
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
        , location = "London / Remote"
        , company = "Zapnito"
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
        , location = "London / Remote"
        , company = "Lytbulb"
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
        , location = "London / Remote"
        , company = "Myschooldirect"
        , dates = "2010–2014"
        , projects =
            [ { name = "Give4Sure"
              , start = 2012
              , end = 2014
              , overview = "A browser plugin helping shoppers raise money for their chosen charities."
              , stack = [ "Browser extensions", "Ruby on Rails", "Postgres", "Ember.js", "Kanban", "BDD" ]
              , talkingPoints =
                    [ "Built browser extension to handle high volume but with low infrastructure costs."
                    , "Developed a monitoring system to identify broken/incorrect links received from our 3rd party affiliate networks."
                    , "Devised a compression based algorithm for identifying when web pages matched within a given tolerance."
                    , "Browser extension designed to receive updates in near realtime so that broken affiliate links were removed before causing any user issues."
                    ]
              }
            , { name = "Marks and Spencer School Uniforms"
              , start = 2011
              , end = 2012
              , overview = "An online store for schools to create their own Marks and Spencer uniforms; M&S later bought out the project and took it in-house."
              , stack = [ "Ruby on Rails", "Postgres", "Kanban", "BDD" ]
              , talkingPoints =
                    [ "Built online catalogue that allowed schools to sign up and create their own bespoke uniform online."
                    ]
              }
            , { name = "myschooldirect.com"
              , start = 2010
              , end = 2011
              , overview = "A Quidco style site helpers shoppers raise money for their children's school."
              , stack = [ "Ruby on rails", "Postgres", "Kanban", "BDD" ]
              , talkingPoints =
                    [ "Built shopping catalogue."
                    , "Integrated several affiliate networks."
                    , "Automated tracking of purchases and payment to schools."
                    ]
              }
            ]
        }
    , informa =
        { title = "Tech lead/Architect"
        , location = "London"
        , company = "Informa"
        , dates = "2005-2010"
        , projects =
            [ { name = "World Cellular Information Service"
              , start = 2007
              , end = 2006
              , stack = [ "Java", "Spring", "MS Analytics services", "Oracle DB", "Scrum", "TDD" ]
              , overview = "Led team to replace Informa Telecom's flagship product (WCIS), a mobile markets intelligence platform covering 226 countries."
              , talkingPoints =
                    [ "Used incremental approach with frequent releases to gradually shift product over to new architecture without disrupting the live service or requiring parallel development."
                    , "Introduced clover to track test coverage and promote a TDD approach"
                    ]
              }
            , { name = "World Broadband Information Service"
              , start = 2005
              , end = 2006
              , stack = [ "Java", "Spring", "OLAP", "Mondrian", "Oracle DB", "Scrum", "TDD" ]
              , overview = "Developed a BI portal based on the Mondrian OLAP engine."
              , talkingPoints =
                    [ "Developed algorithms to integrate noisy/conflicting data provided by hundreds of different businesses"
                    , "Introduced Scrum for more effective project management"
                    , "Introduced maven to standardise build process"
                    ]
              }
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
      , result = "2/1"
      , startYear = 2001
      , endYear = 2004
      }
    ]


skillGroups : List SkillGroup
skillGroups =
    [ { name = "Leadership"
      , skills =
            [ { name = "Team leadership & hiring", years = 15 }
            , { name = "Technical strategy & architecture", years = 20 }
            , { name = "Product discovery & delivery", years = 10 }
            , { name = "Zero-to-one shipping", years = 15 }
            ]
      }
    , { name = "Backend"
      , skills =
            [ { name = "Elixir / Phoenix", years = 8 }
            , { name = "Ruby on Rails", years = 8 }
            , { name = "NextJS", years = 3 }
            , { name = "SQL", years = 22 }
            , { name = "Java", years = 8 }
            ]
      }
    , { name = "Datastores"
      , skills =
            [ { name = "Postgres", years = 20 }
            , { name = "Redis", years = 15 }
            , { name = "Snowflake", years = 2 }
            , { name = "Firebase", years = 4 }
            ]
      }
    , { name = "AI"
      , skills =
            [ { name = "OpenAI API", years = 1 }
            , { name = "AI agents", years = 1 }
            , { name = "LangChain / LangSmith", years = 1 }
            , { name = "Agentic coding", years = 1 }
            ]
      }
    , { name = "Frontend"
      , skills =
            [ { name = "React", years = 10 }
            , { name = "Typescript/Javascript", years = 17 }
            , { name = "Elm", years = 5 }
            , { name = "HTML / CSS / SASS", years = 22 }
            ]
      }
    , { name = "Infrastructure"
      , skills =
            [ { name = "AWS", years = 14 }
            , { name = "Terraform", years = 4 }
            ]
      }
    , { name = "Methodology"
      , skills =
            [ { name = "Scrum / Kanban", years = 20 }
            , { name = "BDD / TDD", years = 18 }
            ]
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
