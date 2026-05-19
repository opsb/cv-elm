module Cpo.Data exposing (cv)

{-| CPO / Product & Technology Executive variant. Self-contained
content (no shared copy with the CTO variant); types and rendering
come from `Cv.Types` and `Cv.View` respectively. Edit any string in
this file to change what shows up at /cpo.

Mirrors the structure of the 2026-04-06 "CPO-framing" PDF:

  - "Executive Profile" rather than a longer "Introduction" intro
  - "Core Capabilities" rather than a per-year skill grid (labels
    only, no year counts)
  - Thoughtclay is one Principal-Consultant position carrying five
    nested engagements (Tree3, Tastermonial, Boulevard, Vorwerk,
    CompareTheMarket); the View splits them across the page break

-}

import Cv.Types exposing (CvData, Institution, Position, Project)


cv : CvData
cv =
    { pdfFileName = "Oliver-Searle-Barnes-CPO-2026.pdf"
    , name = "Oliver Searle-Barnes"
    , tagline = "CPO, XP Flow | Product & Technology Executive"
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
    [ "Technology executive and product leader with over two decades building and scaling software products across SaaS, fintech, e-commerce, energy, and affiliate marketing. Currently CPO of XP Flow, leading product development for Alfie.io, an AI-powered affiliate platform automating partner discovery, evaluation, and outreach at scale."
    , "Known for bridging deep engineering expertise with clear product strategy and commercial execution. Experienced leading distributed teams through early-stage discovery, product-market fit, and growth-phase scaling, including co-founding a platform acquired by Marks & Spencer, and consistently taking products from zero to production in complex, regulated, and high-scale environments."
    , "Operates at the intersection of product, data, and platform thinking. Comfortable owning roadmaps, structuring and hiring product teams, and working directly with enterprise design partners to shape category-defining products."
    ]



---- CORE CAPABILITIES ----


coreCapabilities : List String
coreCapabilities =
    [ "Product Strategy & Roadmap Leadership"
    , "Platform & Data Architecture"
    , "Affiliate & Partnership Technology"
    , "Discovery-Led Product Development"
    , "Engineering Team Leadership & Hiring"
    , "SaaS Monetisation & Pricing Design"
    , "AI-Augmented Workflow Design"
    , "Early-Stage & Growth-Stage Ventures"
    ]



---- EXPERIENCE ----


xpflow : Position
xpflow =
    { title = "CPO"
    , location = "Dallas / Remote"
    , company = "XP Flow (alfie.io)"
    , dates = "Feb 2025 – Present"
    , overview = Nothing
    , projects =
        [ { name = "Alfie.io"
          , dates = "Feb 2025 – Present"
          , overview = ""
          , talkingPoints =
                [ "Led initial product discovery and proposed Alfie.io, an AI-powered affiliate marketing platform that automates partner discovery, outreach, and management, growing the product from concept to a broad base of active customers."
                , "Defined the product vision for AI-powered affiliate scouts that autonomously discover, evaluate, and outreach to partners, fully automating workflows that agencies previously handled manually."
                , "Shaped the end-to-end scout experience from brief configuration through to ranked partner shortlists and automated outreach, replacing multi-day manual research with a fully autonomous agent workflow."
                , "Created the plan-based subscription model with Stripe billing and per-workspace agency structure, establishing the company's early revenue engine."
                , "Specified LLM-driven evaluation and personalised outreach pipelines within the scout workflow, enabling the platform to analyse affiliate websites, assess brand fit, and generate tailored messages autonomously."
                , "Drove affiliate network integrations (Everflow) and multi-campaign workflow tooling, enabling agencies to manage high-volume partner programmes from a single platform."
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
          , overview = "Built and launched xpaffiliate.com ahead of schedule, delivering the full technical stack for a new affiliate network from infrastructure through to production."
          , talkingPoints = []
          }
        , { name = "Tastermonial · Interim CTO"
          , dates = "Jun – Dec 2023"
          , overview = "Engaged as Interim CTO to replace an underperforming MVP with a production-grade mobile application, materially improving reliability and performance. Established infrastructure and CI/CD pipelines, leaving the engineering function in a scalable, stable state."
          , talkingPoints = []
          }
        , { name = "Boulevard (LA) · Unicorn"
          , dates = "Oct 2021 – Jun 2023"
          , overview = "Scaled core API platform services for a unicorn salon & spa SaaS company, improving system reliability under high-volume booking loads."
          , talkingPoints = []
          }
        , { name = "Vorwerk"
          , dates = "Apr – Sep 2021"
          , overview = "Bootstrapped an engineering team and delivered cloud services powering IoT connectivity for a new line of commercial robot vacuum cleaners, shipping to production on schedule."
          , talkingPoints = []
          }
        , { name = "CompareTheMarket / Bean"
          , dates = "Feb 2019 – Mar 2021"
          , overview = "Rebuilt Bean.com as a high-performance Open Banking service, integrating the majority of UK high street banks and enabling users to manage subscriptions across all their accounts."
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
                [ "Led engineering team building a white-labelled real-time community platform for B2B publishers, owning technical strategy and delivery end-to-end."
                , "Delivered a Phoenix/Elixir-powered platform with real-time collaboration, taking it from early-stage prototype to a stable multi-tenant SaaS serving multiple enterprise publishers."
                , "Introduced an event-driven architecture enabling real-time content updates and collaboration features that became a key product differentiator."
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
                , "Defined architecture, hired engineers, and took the product from concept to live deployment in a lean startup environment."
                , "Built a real-time Kanban-style workflow engine with drag-and-drop task management, enabling field teams to coordinate complex operational projects."
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
                , "Delivered three products: a school fundraising platform, the Give4Sure charitable browser extension, and the M&S school uniform store, the last subsequently sold to Marks & Spencer and brought in-house."
                , "Built the Give4Sure charitable shopping browser extension, which used affiliate links to generate funds for schools and charities when users shopped with major UK retailers."
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
                [ "Co-founded Nutshell Development straight out of university, a Brighton-based web agency building digital products for local businesses."
                , "Delivered booking systems, content management systems for retail clients, and bespoke websites across a range of small business engagements."
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
                , "Delivered a Business Intelligence portal based on the Mondrian OLAP engine and a WebDAV-based CMS, enabling analysts and journalists to query complex datasets and author reports directly in Microsoft Word."
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
