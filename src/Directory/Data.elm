module Directory.Data exposing (Entry, Group, groups)

{-| The canonical, human-readable index of every CV variant the app serves and
when to reach for each. Rendered by `Directory.View` at `/directory`.

This is the in-app mirror of the vault's CV decision guide
(`01 Projects/Next opportunity/CV/Home.md`). It is hand-maintained: when a new
variant route is added, add it here too (alongside the `src/Main.elm` dispatch
branch and the `scripts/generate-pdf.js` entry). See the project `CLAUDE.md`.

`when` copy stays short and in Olly's voice: lead with the role / channel the
cut is for, not a feature list. `design` names the layout family the route
renders through, so it is clear which cuts share a look:

  - "Portrait (modern)" → `Cv.PortraitView` (em, team-lead, node-staff, node-lead, elixir-staff, elixir-lead)
  - "Portrait (executive)" → `Cv.View` (cto)
  - "Landscape (sidebar)" → the dark-sidebar layout (the full CV, /elixir, /node)
  - "Editorial" → the warm-paper editorial design (/experimental)

-}


type alias Entry =
    { route : String
    , title : String
    , tagline : String
    , design : String
    , when : String
    , pdf : Maybe String
    , legacy : Bool
    }


type alias Group =
    { name : String
    , blurb : String
    , entries : List Entry
    }


groups : List Group
groups =
    [ aiPlatform
    , leadership
    , elixir
    , node
    , engineeringManager
    , general
    ]


aiPlatform : Group
aiPlatform =
    { name = "AI Platform (hands-on)"
    , blurb = "The AI-tilted, hands-on technical-owner cut: enterprise AI / agentic-product seats where they want a Tech Lead / Principal / Head of Eng who builds the system and works with AI agents as second nature, not a Jira manager."
    , entries =
        [ { route = "/ai-platform-lead"
          , title = "AI Platform Lead"
          , tagline = "Hands-on Tech Lead · AI Platform & Agentic Engineering"
          , design = "Portrait (modern)"
          , when = "Hands-on technical-owner roles on an AI / agentic platform: foregrounds agentic AI, platform-primitives-over-per-client-forks, production reliability, security / compliance, integrations, and Claude Code / Codex as daily leverage. Forked from /node-lead and re-weighted for the AI-platform reader."
          , pdf = Just "Oliver-Searle-Barnes-AI-Platform-Lead.pdf"
          , legacy = False
          }
        , { route = "/cto-ai"
          , title = "Founding CTO (AI)"
          , tagline = "Founding CTO · AI & Agentic Engineering"
          , design = "Portrait (modern)"
          , when = "Founding CTO / co-founder seats on an AI / agentic product: same hands-on, AI-native content as /ai-platform-lead but lifted to founding-CTO altitude (founding / 0->1 and leadership foregrounded, still hands-on in the code). Reach for this over /cto when the role is AI-first and wants a builder-leader, and over /ai-platform-lead when the title is CTO / co-founder."
          , pdf = Just "Oliver-Searle-Barnes-Founding-CTO-AI.pdf"
          , legacy = False
          }
        ]
    }


leadership : Group
leadership =
    { name = "Leadership (stack-agnostic)"
    , blurb = "Head of Eng / VP Eng / CTO / founding-leader seats. The default for leadership outreach; put any AI tilt in the message body, not the stack."
    , entries =
        [ { route = "/cto"
          , title = "CTO"
          , tagline = "Engineering & Technology Executive"
          , design = "Portrait (executive)"
          , when = "Stack-agnostic Head of Eng / VP Eng / CTO / founding-leader roles. The tight two-page executive cut."
          , pdf = Just "Oliver-Searle-Barnes-CTO-2026.pdf"
          , legacy = False
          }
        ]
    }


elixir : Group
elixir =
    { name = "Elixir (primary track)"
    , blurb = "Only ever use an Elixir CV for genuinely Elixir roles. Prefer the portrait cuts and pick by the JD's hands-on expectation; the landscape /elixir is the older layout."
    , entries =
        [ { route = "/elixir-staff"
          , title = "Staff Elixir Engineer"
          , tagline = "Staff Elixir Engineer · Phoenix / OTP"
          , design = "Portrait (modern)"
          , when = "IC / staff Elixir roles: go-deep-on-OTP, stay-in-the-code submissions. The current portrait cut, two pages."
          , pdf = Just "Oliver-Searle-Barnes-Staff-Elixir-Engineer.pdf"
          , legacy = False
          }
        , { route = "/elixir-lead"
          , title = "Elixir Team Lead"
          , tagline = "Elixir Team Lead · Phoenix / OTP"
          , design = "Portrait (modern)"
          , when = "Hands-on leadership on an Elixir stack: Tech Lead, player-coach, hands-on CTO / founding engineer."
          , pdf = Just "Oliver-Searle-Barnes-Elixir-Lead.pdf"
          , legacy = False
          }
        , { route = "/elixir"
          , title = "Staff Elixir Engineer (landscape)"
          , tagline = "Staff / Principal Elixir"
          , design = "Landscape (sidebar)"
          , when = "Older landscape Elixir cut. Prefer /elixir-staff."
          , pdf = Just "Oliver-Searle-Barnes-Staff-Elixir-Engineer-2026.pdf"
          , legacy = True
          }
        , { route = "/experimental"
          , title = "Elixir Editorial"
          , tagline = "Longer-form Elixir"
          , design = "Editorial"
          , when = "Longer-form / portfolio-style Elixir submissions where presentation carries weight."
          , pdf = Just "Oliver-Searle-Barnes-Elixir-Editorial-2026.pdf"
          , legacy = False
          }
        ]
    }


node : Group
node =
    { name = "Next.js / Node"
    , blurb = "Recency hedge (weighting Elixir > Next.js > Node). Prefer the portrait cuts; the landscape ones are the older layout."
    , entries =
        [ { route = "/node-staff"
          , title = "Staff Engineer"
          , tagline = "Staff Engineer · AI / Next.js / TypeScript / Node"
          , design = "Portrait (modern)"
          , when = "IC contract / staff Next.js / Node roles. The current portrait cut, two pages."
          , pdf = Just "Oliver-Searle-Barnes-Staff-Engineer.pdf"
          , legacy = False
          }
        , { route = "/node-lead"
          , title = "Team Lead"
          , tagline = "Team Lead · AI / Next.js / TypeScript / Node"
          , design = "Portrait (modern)"
          , when = "Hands-on leadership on a Node stack: Tech Lead, player-coach, hands-on CTO / founding engineer."
          , pdf = Just "Oliver-Searle-Barnes-Hands-On-CTO.pdf"
          , legacy = False
          }
        , { route = "/node"
          , title = "Staff Node.js Engineer"
          , tagline = "Staff full-stack engineer"
          , design = "Landscape (sidebar)"
          , when = "Older landscape Node IC cut. Prefer /node-staff."
          , pdf = Just "Oliver-Searle-Barnes-Staff-NodeJS-Engineer-2026.pdf"
          , legacy = True
          }
        , { route = "/node?leader=true"
          , title = "CPO / Node.js"
          , tagline = "Hands-on CTO · Staff Engineer"
          , design = "Landscape (sidebar)"
          , when = "Older landscape Node leadership cut. Prefer /node-lead."
          , pdf = Just "Oliver-Searle-Barnes-CPO-NodeJS-2026.pdf"
          , legacy = True
          }
        ]
    }


engineeringManager : Group
engineeringManager =
    { name = "Engineering Manager"
    , blurb = "Pick by the JD's hands-on expectation, the biggest axis of divergence in the EM market. Both cuts share role history, highlights, and capabilities; only the tagline and profile flex."
    , entries =
        [ { route = "/em"
          , title = "Engineering Manager"
          , tagline = "Engineering Manager"
          , design = "Portrait (modern)"
          , when = "Manager-first roles: not expected to code, lead through others, people-first JDs, manager-of-managers. The canonical EM cut."
          , pdf = Just "Oliver-Searle-Barnes-Engineering-Manager.pdf"
          , legacy = False
          }
        , { route = "/team-lead"
          , title = "Team Lead"
          , tagline = "Team Lead · Player-Coach"
          , design = "Portrait (modern)"
          , when = "Player-coach / writes-code-weekly / ~50% IC roles, and founder or first-EM seats."
          , pdf = Just "Oliver-Searle-Barnes-Team-Lead.pdf"
          , legacy = False
          }
        ]
    }


general : Group
general =
    { name = "Full CV (landscape)"
    , blurb = "The long-form landscape CV with every section."
    , entries =
        [ { route = "/"
          , title = "Leadership (full landscape CV)"
          , tagline = "Passionate full-stack tech leader"
          , design = "Landscape (sidebar)"
          , when = "The detailed landscape CV with every section (open source, community). Use /cto for the tight executive cut instead."
          , pdf = Just "Oliver-Searle-Barnes-CTO-2026.pdf"
          , legacy = False
          }
        ]
    }
