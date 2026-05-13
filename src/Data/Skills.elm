module Data.Skills exposing
    ( Skill
    , SkillGroup
    , leadershipFirst
    , leadershipLast
    , master
    )

{-| Single source of truth for the skills shown on every CV variant.

The `master` list reflects the Elixir variant's view of the skills — the
canonical numbers and groupings. Other variants reorder it but never
diverge on the underlying data.

-}


type alias Skill =
    { name : String
    , years : Float
    }


type alias SkillGroup =
    { name : String
    , skills : List Skill
    }


master : List SkillGroup
master =
    [ { name = "Leadership"
      , skills =
            [ { name = "Team leadership", years = 10 }
            , { name = "Hiring", years = 10 }
            , { name = "Architecture", years = 20 }
            , { name = "Strategy", years = 20 }
            , { name = "Zero-to-one", years = 10 }
            ]
      }
    , { name = "Backend"
      , skills =
            [ { name = "Elixir / Phoenix", years = 10 }
            , { name = "Ruby on Rails", years = 8 }
            , { name = "NextJS", years = 3 }
            , { name = "SQL", years = 22 }
            , { name = "Java", years = 8 }
            ]
      }
    , { name = "Frontend"
      , skills =
            [ { name = "React", years = 10 }
            , { name = "Typescript", years = 17 }
            , { name = "Elm", years = 5 }
            , { name = "HTML / CSS / SASS", years = 22 }
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
            [ { name = "OpenAI API", years = 2 }
            , { name = "AI agents", years = 2 }
            , { name = "LangChain", years = 2 }
            , { name = "LangSmith", years = 2 }
            , { name = "Agentic coding", years = 2 }
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


leadershipFirst : List SkillGroup
leadershipFirst =
    master


leadershipLast : List SkillGroup
leadershipLast =
    let
        ( leadership, others ) =
            List.partition (\group -> group.name == "Leadership") master
    in
    others ++ leadership
