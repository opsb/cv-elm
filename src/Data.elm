module Data exposing (..)


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


init : Data
init =
    { name = "Oliver Searle-Barnes"
    , tagline = "Full stack web developer"
    , introduction =
        [ { name = "Business focused"
          , body = "Building software that people actually like to use is what gets me going. With over 12 years experience I've delivered successful products for the Telecoms, Retail, Publishing, Energy and Charity sectors. I've led teams to build a wide variety of projects including realtime social platforms and project management tools, business Intelligence, custom content management systems, online stores and browser extensions. "
          }
        , { name = "Agile", body = "From day one I've been an agile practitioner, whether it's Scrum or Kanban, Lean, BDD, outside-in, pair-programming, you name it, I've been doing it for years. I've usually led from the front but I’m comfortable working in many different styles and value project consistency over personal preferences so am equally comfortable working alone or slotting into an existing team." }
        ]
    , experience =
        [ { title = "VP Engineering"
          , location = "London"
          , company = "Zapnito"
          , projects =
                [ { name = "Feeds"
                  , start = 2016
                  , end = 2017
                  , overview = "Led the development of a realtime, embeddable social webapp. "
                  , stack = [ "Phoenix", "Elixir", "Elm", "realtime" ]
                  , talkingPoints =
                        [ "Implemented an Event Sourcing architecture to power the realtime front end built on top of Phoenix's websocket based channels."
                        , "Designed API for embedding product within 3rd party platforms including a variety of widgets and seamless integration with Single Sign On."
                        , "Built testing infrastructure that allowed full stack testing in multiple concurrent browser instances."
                        ]
                  }
                , { name = "Knowledge Networks"
                  , start = 2014
                  , end = 2017
                  , overview = "Tech lead and architect for an expert focused content management system and online training platform."
                  , stack = [ "Ruby on Rails", "ember.js", "Postgres", "Redis", "Memcached" ]
                  , talkingPoints =
                        [ "Built video discussion feature including recording facilities."
                        , "Built theming system that included a ruby command line tool allowing designers to build and release themes independently of the main app release process."
                        , "Refined core architecture to focus on consistent content management."
                        , "Performance work to optimise load time of site"
                        , "Introduced and rolled out ember.js across the app to modernise user experience."
                        ]
                  }
                ]
          }
        , { title = "CTO"
          , location = "London"
          , company = "Lytbulb"
          , projects =
                [ { name = "lytbulb.com"
                  , start = 2014
                  , end = 2015
                  , overview = "Led development of a trello-like product aimed at the energy sector, focusing on oil and gas."
                  , stack = [ "Ruby on Rails", "ember.js", "firebase", "postgres", "realtime" ]
                  , talkingPoints =
                        [ "Built realtime kanban board using firebase backend"
                        , "Developed workflow system based around typical oil and gas projects"
                        ]
                  }
                ]
          }
        , { title = "CTO"
          , location = "London"
          , company = "Myschooldirect"
          , projects =
                [ { name = "Give4Sure"
                  , start = 2012
                  , end = 2014
                  , overview = "Led development of a cross-browser plugin and webapp that helped charities raise money while their supporters shopped online."
                  , stack = [ "browser extension", "Ruby on Rails", "Postgres", "Ember.js" ]
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
                  , overview = "Led a collaboration with Marks and Spencer to provide bespoke school uniforms to UK schools."
                  , stack = [ "Ruby on Rails", "Postgres" ]
                  , talkingPoints =
                        [ "Built online catalogue that allowed schools to sign up and create their own bespoke uniform online."
                        ]
                  }
                , { name = "myschooldirect.com"
                  , start = 2010
                  , end = 2011
                  , overview = "Led development of a Quidco style shopping site where parent's could find deals that would raise money for their children's schools"
                  , stack = [ "Ruby on rails", "Postgres" ]
                  , talkingPoints =
                        [ "Built shopping catalogue."
                        , "Integrated several affiliate networks."
                        , "Automated tracking of purchases and payment to schools."
                        ]
                  }
                ]
          }
        , { title = "Tech lead"
          , location = "London"
          , company = "Informa"
          , projects =
                [ { name = "Intelligence Centre 2"
                  , start = 2008
                  , end = 2010
                  , stack = [ "Java/Spring", "Oracle DB" ]
                  , overview = "Custom CMS for analysis of the telecoms sector."
                  , talkingPoints =
                        [ "Devised a webdav based system that allowed journalists to edit articles directly in MS Word. The system allowed journalists to hit save in Word and instantly see a preview on the live site."
                        ]
                  }
                , { name = "World Cellular Information Service"
                  , start = 2007
                  , end = 2006
                  , stack = [ "Java", "Spring", "MS Analytics services", "Oracle DB" ]
                  , overview = "BI portal for worldwide cellular market data"
                  , talkingPoints =
                        [ "Used incremental approach with frequent releases to gradually shift product over to new architecture without disrupting the live service or requiring parallel development."
                        , "Introduced clover to track test coverage and promote a TDD approach"
                        ]
                  }
                , { name = "World Broadband Information Service"
                  , start = 2004
                  , end = 2006
                  , stack = [ "Java", "Spring", "OLAP", "Oracle DB" ]
                  , overview = "BI portal for worldwide broadband market data"
                  , talkingPoints =
                        [ "Developed algorithms to integrate noisy/conflicting data provided by hundreds of different businesses"
                        , "Introduced Scrum for more effective project management"
                        , "Introduced maven to standardise build process"
                        ]
                  }
                ]
          }
        ]
    , education =
        [ { name = "Sussex University", course = "Artificial Intelligence", result = "2/1", startYear = 2001, endYear = 2004 }
        ]
    , skills =
        [ { name = "Ruby on Rails", years = 7 }
        , { name = "Elixir / Phoenix", years = 1.5 }
        , { name = "Elm", years = 1.5 }
        , { name = "React/Redux", years = 0.5 }
        , { name = "RxJS", years = 1.5 }
        , { name = "Ember.js", years = 5 }
        , { name = "Javascript - ES2017", years = 7 }
        , { name = "Java", years = 5 }
        , { name = "SQL", years = 12 }
        , { name = "Firebase", years = 2 }
        , { name = "OLAP / MDX", years = 4 }
        , { name = "Event-sourcing/CQRS", years = 2 }
        , { name = "Scrum / Kanban", years = 11 }
        , { name = "BDD / TDD", years = 10 }
        , { name = "Git", years = 8 }
        , { name = "Realtime systems", years = 5 }
        , { name = "HTML", years = 12 }
        , { name = "CSS / SASS", years = 12 }
        , { name = "OO", years = 12 }
        , { name = "Functional", years = 2 }
        , { name = "Heroku", years = 8 }
        , { name = "AWS", years = 8 }
        ]
    , openSource =
        [ { name = "orbitjs/orbit"
          , repo = "https://github.com/orbitjs/orbit"
          , language = "javascript"
          , overview = "A javascript library for orchestrating data synchronization"
          , shortInvolvement = "Core"
          , involvement = "For 2 years I was a core contributor working with Dan Gebhard, contributing code and discussing architectural direction"
          }
        , { name = "saschatimme/elm-phoenix"
          , repo = "https://github.com/saschatimme/elm-phoenix"
          , language = "Elm"
          , overview = "Integration between Elm and Phoenix channels"
          , shortInvolvement = "Core"
          , involvement = "Having used elm-phoenix in production I've contributed several features, bug fixes, documentation and example code"
          }
        , { name = "opsb/elm-debouncer-fx"
          , repo = "https://github.com/opsb/elm-debouncer-fx"
          , language = "Elm"
          , overview = "An Elm effect manager for debouncing events"
          , shortInvolvement = "Owner"
          , involvement = "I created this while working on the Feeds project - it's original use was to debounce scroll input from the mouse"
          }
        , { name = "opsb/patchstream"
          , repo = "https://github.com/opsb/patchstream"
          , language = "Ruby"
          , overview = "Emits json patches as rails active records are updated"
          , shortInvolvement = "Owner"
          , involvement = "I created this while working on the Lytbulb project - it was used while transitioning the project from a pure rails backend to firebase"
          }
        ]
    }
