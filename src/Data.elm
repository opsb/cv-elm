module Data exposing (Data, Institution, IntroSection, OpenSourceProject, Position, Project, Skill, education, experience, introduction, name, openSourceProjects, skills, tagline)


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
      , body = "Building software that people actually like to use is what gets me going. With over 12 years experience I've delivered successful products for the Telecoms, Retail, Publishing, Energy and Charity sectors. I've led teams to build a wide variety of projects including realtime social platforms and project management tools, business Intelligence, custom content management systems, online stores and browser extensions. "
      }
    , { name = "Agile", body = "From day one I've been an agile practitioner, whether it's Scrum or Kanban, Lean, BDD, outside-in, pair-programming, you name it, I've been doing it for years. I've usually led from the front but I’m comfortable working in many different styles and value project consistency over personal preferences so am equally comfortable working alone or slotting into an existing team." }
    ]


experience =
    { tree3 =
        { title = "Consultant"
        , location = "Dallas / Remote"
        , company = "Tree3"
        , dates = "Dec 2024-Present"
        , projects =
            [ { name = "XP Affiliate Platform"
              , start = 2024
              , end = 2025
              , overview = "Led a development team to launch a new high performance affiliate platform. Was involved in product discovery/strategy and dev team management."
              , stack = [ "NextJS", "Postgres", "Redis" ]
              , talkingPoints = []
              }
            ]
        }
    , tastermonial =
        { title = "Consultant"
        , location = "Cupertino / Remote"
        , company = "Tastermonial"
        , dates = "Jun 2023-Nov 2023"
        , projects =
            [ { name = "Tastermonial App"
              , start = 2023
              , end = 2023
              , overview = "Replaced MVP with a high performance and reliable mobile App using Flutter and Phoenix. Built out AWS infrastructure and supporting build pipelines."
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
              , overview = "Joined the API team to scale platform services and integrations with 3rd party services."
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
              , overview = "Bootstrapped an Elixir/Phoenix team to provide cloud services and python client for a new line of commercial Robot Vacuum Cleaners."
              , stack = [ "Elixir", "Python", "Postgres", "AWS/Terraform" ]
              , talkingPoints = []
              }
            ]
        }
    , ctm =
        { title = "Consultant"
        , location = "London / Remote"
        , company = "CompareThe\nMarket.com"
        , dates = "Feb 2019-Present"
        , projects =
            [ { name = "MoneyHub"
              , start = 2019
              , end = 2021
              , overview = "Rebuilt Bean.com as a high performance elixir service to integrate the majority of UK high street banks using the Open Banking specification."
              , stack = [ "Elixir", "GraphQL", "Elm", "Javascript", "Ruby", "Postgres", "AWS" ]
              , talkingPoints = []
              }
            ]
        }
    , twentyBn =
        { title = "Consultant"
        , location = "Berlin / Remote"
        , company = "TwentyBN"
        , dates = "Sep–Nov 2018"
        , projects =
            [ { name = "Video Annotation Editor"
              , start = 2018
              , end = 2018
              , overview = "Designed and built two Elm apps for collecting video gesture metadata from Amazon Mechanical Turk workers. "
              , stack = [ "Elm", "Javascript" ]
              , talkingPoints = []
              }
            ]
        }
    , liqid =
        { title = "Consultant"
        , location = "Berlin / Remote"
        , company = "Liqid"
        , dates = "Feb–Aug 2018"
        , projects =
            [ { name = "Salesforce Integration"
              , start = 2018
              , end = 2018
              , overview = "Integrated a Ruby on Rails app with Salesforce through an Elixir/RabbitMQ microservice."
              , stack = [ "Elixir", "Ruby on Rails", "RabbitMQ", "Salesforce", "Docker", "GraphQL" ]
              , talkingPoints = []
              }
            ]
        }
    , zapnito =
        { title = "VP Engineering"
        , location = "London / Remote"
        , company = "Zapnito"
        , dates = "2014–2017"
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
        { title = "CTO"
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
              , overview = "An online store for schools to create their own Marks and Spencer uniforms."
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
              , overview = "Led team to develop a replacement for Informa Telecom's flagship product."
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
    , nutshellDevelopment =
        { title = "Head of dev."
        , location = "Brighton"
        , company = "Nutshell Dev."
        , dates = "2004-2005"
        , projects =
            [ { name = "Various local business websites"
              , start = 2004
              , end = 2005
              , stack = [ "Java", "Spring", "JPA", "JSF", "Mysql" ]
              , overview = "Built custom CMSs for local shops and restaurants. This was when I discovered Extreme Programming and started down the Agile road."
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


skills : List Skill
skills =
    [ { name = "Elixir / Phoenix", years = 7 }
    , { name = "Ruby on Rails", years = 8 }
    , { name = "NextJS", years = 2 }
    , { name = "Elm", years = 5 }
    , { name = "React", years = 5 }
    , { name = "Typescript/Javascript", years = 15 }
    , { name = "Java", years = 6 }
    , { name = "SQL", years = 20 }
    , { name = "Firebase", years = 2 }
    , { name = "OLAP / MDX", years = 4 }
    , { name = "Event-sourcing/CQRS", years = 2 }
    , { name = "Scrum / Kanban", years = 18 }
    , { name = "BDD / TDD", years = 18 }
    , { name = "Git", years = 15 }
    , { name = "Realtime systems", years = 7 }
    , { name = "HTML", years = 21 }
    , { name = "CSS / SASS", years = 18 }
    , { name = "OO", years = 20 }
    , { name = "Functional", years = 10 }
    , { name = "AWS", years = 12 }
    , { name = "Terraform", years = 4 }
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
    , { name = "opsb / elm-debouncer-fx"
      , repo = "https://github.com/opsb/elm-debouncer-fx"
      , language = "Elm"
      , overview = "An Elm effect manager for debouncing events"
      , shortInvolvement = "owner"
      , involvement = "I created this while working on the Feeds project - it's original use was to debounce scroll input from the mouse"
      }
    , { name = "opsb / patchstream"
      , repo = "https://github.com/opsb/patchstream"
      , language = "Ruby"
      , overview = "Emits json patches as rails active records are updated"
      , shortInvolvement = "owner"
      , involvement = "I created this while working on the Lytbulb project - it was used while transitioning the project from a pure rails backend to firebase"
      }
    , { name = "opsb / cv-elm"
      , repo = "https://github.com/opsb/cv-elm"
      , language = "Elm"
      , overview = "The code used to generate the CV you're reading right now"
      , shortInvolvement = "owner"
      , involvement = "I wanted a CV that made it convenient to update the content or design so I built this one in Elm."
      }
    ]
