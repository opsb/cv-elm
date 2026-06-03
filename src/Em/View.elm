module Em.View exposing (view)

{-| Two-page Engineering Manager CV layout, served at `/team-lead` (hands-on
player-coach) and `/em` (manager-first). The variant only changes the copy in
`Em.Data` (tagline + profile); this view renders whichever `CvData` it is
handed.

  - portrait A4 pages paginated to two sheets
  - page 1: header → Profile → Core Capabilities → Professional Experience
    header → leading position → second position → Thoughtclay (first engagement)
  - page 2: rest of Thoughtclay → other positions → Education
  - each role: a one-line company | title | dates header, then indented
    `Scope:` / `Stack:` lines and bullets
  - grouped Core Capabilities (labelled comma-separated lines) from
    `Em.Data.skillGroups`
  - blue uppercase section headings with hairline rules
  - weight hierarchy: section headings bold blue; role / capability labels
    medium; body and bullets regular (dark); supporting Scope/Stack/overview
    text in grey

Pagination is explicit: page 1 takes the first `page1Count` Thoughtclay
engagements, page 2 the rest. Adjust the slice in `pages` if the copy shifts.
The page geometry is declared via inline styles so the portrait dimensions
override the global landscape rule in `main.css`.

-}

import Browser
import Cv.Types exposing (CvData, Institution, Position, Project)
import Em.Data
import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Html exposing (Html)
import Html.Attributes


view : CvData -> Browser.Document msg
view cv =
    { title = "Oliver Searle-Barnes CV"
    , body =
        [ Html.node "style" [] [ Html.text printStyles ]
        , downloadLinkHtml cv
        , Element.layout pageAttrs (pages cv)
        ]
    }


downloadLinkHtml : CvData -> Html msg
downloadLinkHtml cv =
    Html.a
        [ Html.Attributes.href ("/" ++ cv.pdfFileName)
        , Html.Attributes.attribute "download" cv.pdfFileName
        , Html.Attributes.attribute "data-print" "false"
        , Html.Attributes.style "position" "fixed"
        , Html.Attributes.style "top" "16px"
        , Html.Attributes.style "right" "20px"
        , Html.Attributes.style "font-family" "Helvetica, Arial, sans-serif"
        , Html.Attributes.style "font-size" "12px"
        , Html.Attributes.style "color" "#1c1c20"
        , Html.Attributes.style "text-decoration" "none"
        , Html.Attributes.style "background" "rgba(255,255,255,0.92)"
        , Html.Attributes.style "border" "1px solid #d8d8dd"
        , Html.Attributes.style "border-radius" "4px"
        , Html.Attributes.style "padding" "6px 10px"
        , Html.Attributes.style "z-index" "100"
        ]
        [ Html.text "↓ Download PDF" ]


printStyles : String
printStyles =
    """
html, body { background-color: #f4f4f4 !important; margin: 0; padding: 0; }

@page { size: A4 portrait; margin: 0; }

@media screen {
    [data-class="page"] {
        margin-top: 0 !important;
        margin-bottom: 0 !important;
    }
}

@media print {
    html, body { background-color: #ffffff !important; }
    [data-print="false"] { display: none !important; }
}
"""



---- TOKENS ----


bodyColor : Color
bodyColor =
    rgb255 32 32 36


mutedColor : Color
mutedColor =
    rgb255 110 110 116


textColor : Color
textColor =
    rgb255 74 74 82


accentBlue : Color
accentBlue =
    rgb255 47 84 150


ruleColor : Color
ruleColor =
    rgb255 47 84 150


pageBg : Color
pageBg =
    rgb255 255 255 255


sans : Attribute msg
sans =
    Font.family
        [ Font.typeface "Calibri"
        , Font.typeface "Helvetica Neue"
        , Font.typeface "Helvetica"
        , Font.typeface "Arial"
        , Font.sansSerif
        ]


lineHeight : Float -> Attribute msg
lineHeight n =
    htmlAttribute (Html.Attributes.style "line-height" (String.fromFloat n))


letterSpacing : Float -> Attribute msg
letterSpacing px_ =
    htmlAttribute (Html.Attributes.style "letter-spacing" (String.fromFloat px_ ++ "px"))



---- PAGE GEOMETRY ----


pageAttrs : List (Attribute msg)
pageAttrs =
    [ sans
    , Font.color bodyColor
    , Font.size 13
    , lineHeight 1.35
    , Background.color (rgb255 244 244 244)
    , width fill
    , htmlAttribute (Html.Attributes.style "min-height" "100vh")
    ]


{-| Portrait A4 sheet. Inline padding wins over main.css's screen-only
10mm rule (no !important on the source), so the same gutter applies
in screen and print. Print pagination via `page-break-after: always`.
-}
a4Portrait : List (Element msg) -> Element msg
a4Portrait body =
    column
        [ htmlAttribute (Html.Attributes.style "width" "210mm")
        , htmlAttribute (Html.Attributes.style "height" "297mm")
        , htmlAttribute (Html.Attributes.style "padding" "16mm 18mm 13mm 18mm")
        , htmlAttribute (Html.Attributes.style "box-sizing" "border-box")
        , htmlAttribute (Html.Attributes.attribute "data-class" "page")
        , htmlAttribute (Html.Attributes.style "page-break-after" "always")
        , htmlAttribute (Html.Attributes.style "overflow" "hidden")
        , Background.color pageBg
        , spacing 9
        ]
        body



---- PAGES ----


pages : CvData -> Element msg
pages cv =
    let
        thoughtclay =
            cv.thoughtclay

        -- When a secondPosition occupies page 1, fewer Thoughtclay
        -- engagements fit above the fold, so take 1 instead of 3.
        page1Count =
            case cv.secondPosition of
                Just _ ->
                    1

                Nothing ->
                    3

        thoughtclayPage1 =
            { thoughtclay | projects = List.take page1Count thoughtclay.projects }

        thoughtclayPage2Projects =
            List.drop page1Count thoughtclay.projects
    in
    column [ width fill, spacing 0 ]
        [ page1 cv thoughtclayPage1
        , page2 cv thoughtclayPage2Projects
        ]


page1 : CvData -> Position -> Element msg
page1 cv thoughtclayHead =
    a4Portrait
        [ header cv
        , section cv.profileTitle (executiveProfileBlock cv)
        , section "Selected Highlights" highlightsBlock
        , section "Core Capabilities" coreCapabilitiesBlock
        , section "Professional Experience"
            (column [ spacing 13, width fill, paddingEach { top = 4, right = 0, bottom = 0, left = 0 } ]
                ([ positionView cv.leadingPosition ]
                    ++ (case cv.secondPosition of
                            Just p ->
                                [ positionView p ]

                            Nothing ->
                                []
                       )
                    ++ [ positionView thoughtclayHead ]
                )
            )
        ]


page2 : CvData -> List Project -> Element msg
page2 cv thoughtclayTail =
    a4Portrait
        [ column [ spacing 16, width fill ]
            (nestedProjectsBlock thoughtclayTail
                :: List.map positionView cv.otherPositions
            )
        , section "Education" (educationBlock cv)
        ]



---- HEADER ----


header : CvData -> Element msg
header cv =
    column [ spacing 2, width fill, paddingEach { top = 0, right = 0, bottom = 6, left = 0 } ]
        [ el
            [ Font.size 34
            , Font.bold
            , Font.color bodyColor
            ]
            (text cv.name)
        , el
            [ Font.size 16
            , Font.italic
            , Font.color accentBlue
            , paddingEach { top = 2, right = 0, bottom = 0, left = 0 }
            ]
            (text cv.tagline)
        , el
            [ Font.size 13
            , Font.color bodyColor
            , paddingEach { top = 2, right = 0, bottom = 0, left = 0 }
            ]
            (text cv.email)
        ]



---- SECTIONS ----


section : String -> Element msg -> Element msg
section title body =
    column [ spacing 6, width fill ]
        [ sectionHeader title
        , body
        ]


sectionHeader : String -> Element msg
sectionHeader title =
    column [ spacing 3, width fill ]
        [ el
            [ width fill
            , height (px 2)
            , Background.color ruleColor
            ]
            none
        , el
            [ Font.size 15
            , Font.bold
            , Font.color accentBlue
            , letterSpacing 0.5
            , paddingEach { top = 3, right = 0, bottom = 3, left = 0 }
            ]
            (text (String.toUpper title))
        , el
            [ width fill
            , height (px 1)
            , Background.color ruleColor
            ]
            none
        ]



---- PROFILE ----


executiveProfileBlock : CvData -> Element msg
executiveProfileBlock cv =
    column [ spacing 9, width fill ]
        (cv.executiveProfile
            |> List.map
                (\p ->
                    Element.paragraph
                        [ Font.size 13
                        , lineHeight 1.3
                        , Font.color bodyColor
                        ]
                        [ text p ]
                )
        )



---- SELECTED HIGHLIGHTS ----


highlightsBlock : Element msg
highlightsBlock =
    column [ width fill, spacing 4 ]
        (List.map bulletItem Em.Data.highlights)



---- CORE CAPABILITIES ----


{-| Grouped Core Capabilities: one labelled, comma-separated line per group
(Leadership, Engineering Leadership, Product & Discovery, AI, Languages &
Platform). The final group carries the technical stack, so there is no
separate Technical Skills line on this layout.
-}
coreCapabilitiesBlock : Element msg
coreCapabilitiesBlock =
    let
        lastIndex =
            List.length Em.Data.skillGroups - 1
    in
    column [ width fill, spacing 5 ]
        (List.indexedMap
            (\i group -> skillGroupLine (i == lastIndex) group)
            Em.Data.skillGroups
        )


skillGroupLine : Bool -> Em.Data.SkillGroup -> Element msg
skillGroupLine isLast group =
    Element.paragraph
        [ Font.size 13, lineHeight 1.22, Font.color textColor ]
        [ el [ Font.medium, Font.color bodyColor ] (text (group.name ++ ": "))
        , text
            (String.join ", " group.skills
                ++ (if isLast then
                        "."

                    else
                        ""
                   )
            )
        ]



---- POSITION ----


positionView : Position -> Element msg
positionView position =
    column [ spacing 5, width fill ]
        [ companyLine position
        , scopeLine position.scope
        , stackLine position.stack
        , projectsBlock position.projects
        ]


scopeLine : String -> Element msg
scopeLine scope =
    if scope == "" then
        none

    else
        Element.paragraph
            [ Font.size 13, lineHeight 1.3, Font.color textColor, paddingEach { top = 0, right = 0, bottom = 0, left = 18 } ]
            [ el [ Font.medium, Font.color bodyColor ] (text "Scope: "), text scope ]


stackLine : List String -> Element msg
stackLine stack =
    case stack of
        [] ->
            none

        _ ->
            Element.paragraph
                [ Font.size 13, lineHeight 1.3, Font.color textColor, paddingEach { top = 0, right = 0, bottom = 0, left = 18 } ]
                [ el [ Font.medium, Font.color bodyColor ] (text "Stack: "), text (String.join ", " stack) ]


{-| A project with an `overview` is a sub-engagement that needs its own
name/dates header (e.g. each Thoughtclay engagement). A project with
only `talkingPoints` is essentially the same entity as its parent
position (e.g. XP Flow → Alfie.io) so the bullets render inline under
the position's role line without repeating the project name.
-}
projectsBlock : List Project -> Element msg
projectsBlock projects =
    if List.any (\p -> p.overview /= "") projects then
        nestedProjectsBlock projects

    else
        bulletList (List.concatMap .talkingPoints projects)


companyLine : Position -> Element msg
companyLine position =
    Element.paragraph
        [ width fill ]
        [ el [ Font.size 16, Font.medium, Font.color bodyColor ] (text (String.replace "\n" "" position.company))
        , el [ Font.size 16, Font.medium, Font.color bodyColor ] (text ("  |  " ++ position.title ++ "  |  " ++ position.dates))
        ]


nestedProjectsBlock : List Project -> Element msg
nestedProjectsBlock projects =
    column
        [ spacing 14, width fill, paddingEach { top = 4, right = 0, bottom = 0, left = 18 } ]
        (List.map nestedProjectView projects)


nestedProjectView : Project -> Element msg
nestedProjectView project =
    column [ spacing 3, width fill ]
        [ Element.paragraph
            [ width fill ]
            [ el [ Font.size 14, Font.medium, Font.color bodyColor ] (text project.name)
            , el [ Font.size 13, Font.color mutedColor ] (text ("  ·  " ++ project.dates))
            ]
        , if project.overview == "" then
            none

          else
            Element.paragraph
                [ Font.size 13
                , lineHeight 1.35
                , Font.color textColor
                ]
                [ text project.overview ]
        , bulletList project.talkingPoints
        ]


bulletList : List String -> Element msg
bulletList points =
    case points of
        [] ->
            none

        _ ->
            column
                [ spacing 3
                , paddingEach { top = 3, right = 0, bottom = 0, left = 18 }
                , width fill
                ]
                (List.map bulletItem points)


bulletItem : String -> Element msg
bulletItem t =
    row [ spacing 8, alignTop, width fill ]
        [ el [ Font.size 13, alignTop, Font.color bodyColor ] (text "•")
        , Element.paragraph
            [ Font.size 13
            , lineHeight 1.35
            , Font.color bodyColor
            ]
            [ text t ]
        ]



---- EDUCATION ----


educationBlock : CvData -> Element msg
educationBlock cv =
    column [ spacing 4, width fill ]
        (List.map institutionView cv.education)


institutionView : Institution -> Element msg
institutionView inst =
    column [ spacing 3, width fill ]
        [ el [ Font.size 16, Font.medium, Font.color bodyColor ] (text inst.name)
        , Element.paragraph
            [ Font.size 14
            , Font.color bodyColor
            ]
            [ el [ Font.medium ] (text inst.course)
            , text (", " ++ inst.result ++ "  |  " ++ inst.dates)
            ]
        ]
