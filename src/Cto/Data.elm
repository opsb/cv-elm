module Cto.Data exposing (cv)

{-| CTO / Engineering & Technology Executive variant. Mirrors the
CPO variant structurally but reframes the copy for an engineering
leadership audience: architecture, technical strategy, team building,
and platform thinking over product discovery and commercial design.

Most of the older positions (Zapnito VP Eng, Lytbulb CTO, Myschooldirect
CTO & Co-founder, Informa Tech Lead/Architect) were already
engineering-led so their bullets stay close to the CPO variant. The
material differences live in:

  - tagline + side-panel framing
  - executive profile paragraphs (engineering & architecture lead)
  - core capabilities (engineering replacements for product-strategy items)
  - XP Flow bullets (full-stack build, AI agent architecture, LLM
    pipeline engineering, billing infra, network integration, cloud
    infra) rather than product discovery + scout experience
  - Tree3 / Tastermonial / Boulevard / Vorwerk / CompareTheMarket
    overviews tilted toward the technical lift rather than the
    product outcome

-}

import Cv.Types exposing (CvData, Institution, Position, Project)


cv : CvData
cv =
    { pdfFileName = "Oliver-Searle-Barnes-CTO-2026.pdf"
    , name = "Oliver Searle-Barnes"
    , tagline = "CTO, XP Flow | Engineering & Technology Executive"
    , email = "oliver@opsb.co.uk"
    , executiveProfile = executiveProfile
    , coreCapabilities = coreCapabilities
    , leadingPosition = xpflow
    , thoughtclay = thoughtclay
    , otherPositions = [ zapnito, lytbulb, myschooldirect, informa, nutshell ]
    , education = education
    }



---- EXECUTIVE PROFILE ----


executiveProfile : List String
executiveProfile =
    [ "Engineering leader and technology executive with over two decades architecting and scaling software products across SaaS, fintech, e-commerce, energy, and affiliate marketing. Currently CTO of XP Flow, leading the engineering build of Alfie.io, an AI-powered affiliate platform automating partner discovery, evaluation, and outreach at scale."
    , "Known for pairing deep engineering expertise with clear product strategy and commercial execution. Experienced leading distributed engineering teams through early-stage discovery, product-market fit, and growth-phase scaling, including co-founding a platform acquired by Marks & Spencer, and consistently taking products from zero to production in complex, regulated, and high-scale environments."
    , "Operates at the intersection of architecture, platform, and team thinking. Comfortable owning the technical roadmap, structuring and hiring engineering teams, and partnering directly with founders and enterprise design partners to ship category-defining products."
    ]



---- CORE CAPABILITIES ----


coreCapabilities : List String
coreCapabilities =
    [ "Engineering Strategy & Technical Roadmap"
    , "Platform & Data Architecture"
    , "Distributed Systems & API Design"
    , "AI Agent & LLM Pipeline Engineering"
    , "Engineering Team Leadership & Hiring"
    , "DevOps, Observability & Reliability"
    , "Zero-to-One Delivery in Regulated Domains"
    , "Early-Stage & Growth-Stage Ventures"
    ]



---- EXPERIENCE ----


xpflow : Position
xpflow =
    { title = "CTO"
    , location = "Dallas / Remote"
    , company = "XP Flow (alfie.io)"
    , dates = "Feb 2025 – Present"
    , overview = Nothing
    , projects =
        [ { name = "Alfie.io"
          , dates = "Feb 2025 – Present"
          , overview = ""
          , talkingPoints =
                [ "Architected and shipped the full Next.js / TypeScript / Postgres stack for Alfie.io, an AI-powered affiliate marketing platform, taking the product from concept to a broad base of active customers."
                , "Designed the agentic AI architecture on LangGraph / LangChain, including a regression-test harness for prompts and an agentic learning loop that continuously improves scout behaviour."
                , "Built the LLM-driven evaluation pipeline that scrapes affiliate websites, assesses brand fit across multiple stages, and generates personalised outreach autonomously."
                , "Implemented the subscription billing infrastructure on Stripe with per-workspace agency isolation, establishing the company's early revenue plumbing."
                , "Integrated the Everflow affiliate-network API and built the multi-campaign workflow tooling enabling agencies to manage high-volume partner programmes from a single platform."
                , "Built a custom chat stack with in-chat widgets and tool-calling UI to surface agent state and decisions to operators in real time."
                ]
          }
        ]
    }


thoughtclay : Position
thoughtclay =
    { title = "Principal Consultant"
    , location = "Barcelona / Remote"
    , company = "Thoughtclay"
    , dates = "2018 – Present"
    , overview = Nothing
    , projects =
        [ { name = "Tree3"
          , dates = "Dec 2024 – Present"
          , overview = "Led the engineering build of xpaffiliate.com, delivering the full technical stack for a new affiliate network on Next.js / Postgres / Redis, from infrastructure through to production and ahead of schedule."
          , talkingPoints = []
          }
        , { name = "Tastermonial · Interim CTO"
          , dates = "Jun – Dec 2023"
          , overview = "Engaged as Interim CTO to rebuild a failing iOS MVP into a production-grade Flutter app on iOS and Android. Established AWS infrastructure and CI/CD via Terraform, materially improving reliability and leaving the engineering function stable and scalable."
          , talkingPoints = []
          }
        , { name = "Boulevard (LA) · Unicorn"
          , dates = "Oct 2021 – Jun 2023"
          , overview = "Senior 2 Engineer on the API platform team at this salon & spa SaaS unicorn, shipping cross-cutting platform infrastructure: third-party App Store, GraphQL rate limiter, HIPAA compliance, webhook delivery, and OpenTelemetry rollout across the platform."
          , talkingPoints = []
          }
        , { name = "Vorwerk"
          , dates = "Apr – Sep 2021"
          , overview = "Tech Lead bootstrapping a backend team at this German consumer-appliance giant, delivering Elixir / Python cloud services on AWS that power IoT connectivity for a new commercial robot vacuum line. Shipped on schedule for commercial launch."
          , talkingPoints = []
          }
        , { name = "CompareTheMarket / Bean"
          , dates = "Feb 2019 – Mar 2021"
          , overview = "Rebuilt Bean.com on Elixir / GraphQL as a high-performance Open Banking service for this leading UK price-comparison site, integrating the majority of UK high street banks under FCA-authorised account-information services."
          , talkingPoints = []
          }
        ]
    }


zapnito : Position
zapnito =
    { title = "VP Engineering"
    , location = "London / Remote"
    , company = "Zapnito"
    , dates = "2014 – 2017"
    , overview = Nothing
    , projects =
        [ { name = "Feeds"
          , dates = "2014 – 2017"
          , overview = ""
          , talkingPoints =
                [ "Led the engineering team building a white-labelled real-time community platform for B2B publishers, owning technical strategy and delivery end-to-end."
                , "Delivered a Phoenix / Elixir platform with real-time collaboration over WebSockets, taking it from early-stage prototype to a stable multi-tenant SaaS serving multiple enterprise publishers."
                , "Introduced an event-driven architecture and embedding API with SSO across third-party host platforms, enabling the realtime features that became a key product differentiator."
                ]
          }
        ]
    }


lytbulb : Position
lytbulb =
    { title = "CTO"
    , location = "London / Remote"
    , company = "Lytbulb"
    , dates = "2014 – 2015"
    , overview = Nothing
    , projects =
        [ { name = "lytbulb.com"
          , dates = "2014 – 2015"
          , overview = ""
          , talkingPoints =
                [ "Led the technical build of a Trello-style project management product aimed at the energy sector, with a focus on oil and gas operations."
                , "Defined the architecture, hired engineers, and took the product from concept to live deployment in a lean startup environment."
                , "Built a real-time Kanban-style workflow engine on an Ember.js front-end with Firebase backend, enabling field teams to coordinate complex operational projects."
                ]
          }
        ]
    }


myschooldirect : Position
myschooldirect =
    { title = "CTO & Co-founder"
    , location = "London"
    , company = "Myschooldirect"
    , dates = "2010 – 2014"
    , overview = Nothing
    , projects =
        [ { name = "Myschooldirect & Give4Sure"
          , dates = "2010 – 2014"
          , overview = ""
          , talkingPoints =
                [ "Co-founded and led technology at Myschooldirect, a school-shopping affiliate platform serving UK schools."
                , "Architected and delivered three products: a school fundraising platform, the Give4Sure charitable browser extension, and the M&S school uniform store, the last subsequently sold to Marks & Spencer and brought in-house."
                , "Designed a compression-based algorithm for detecting broken or incorrect affiliate links across third-party networks, plus the browser extensions that handled high traffic at low infrastructure cost."
                ]
          }
        ]
    }


nutshell : Position
nutshell =
    { title = "Technical Co-founder"
    , location = "Brighton"
    , company = "Nutshell Development"
    , dates = "Oct 2004 – Jun 2005"
    , overview = Nothing
    , projects =
        [ { name = "Nutshell Development"
          , dates = "Oct 2004 – Jun 2005"
          , overview = ""
          , talkingPoints =
                [ "Co-founded Nutshell Development straight out of university, a Brighton-based web agency delivering Java-based digital products for local businesses."
                , "Built booking systems, content management systems for retail clients, and bespoke websites across a range of small business engagements."
                ]
          }
        ]
    }


informa : Position
informa =
    { title = "Tech Lead / Architect"
    , location = "London"
    , company = "Informa Telecoms & Media"
    , dates = "2005 – 2010"
    , overview = Nothing
    , projects =
        [ { name = "World Cellular Information Service"
          , dates = "2005 – 2010"
          , overview = ""
          , talkingPoints =
                [ "Architected the replacement for Informa's flagship World Cellular Information Service (WCIS), a mission-critical intelligence platform covering mobile markets across 226 countries, used by global telecoms operators, analysts, and regulators."
                , "Delivered a Business Intelligence portal on the Mondrian OLAP engine and a WebDAV-based CMS, enabling analysts and journalists to query complex datasets and author reports directly in Microsoft Word."
                , "Led a multi-year platform migration from legacy systems, coordinating across editorial, product, and infrastructure teams to deliver without disrupting paying subscribers."
                ]
          }
        ]
    }



---- EDUCATION ----


education : List Institution
education =
    [ { name = "University of Sussex"
      , course = "BSc Artificial Intelligence"
      , result = "2:1"
      , dates = "2001 – 2004"
      }
    ]
