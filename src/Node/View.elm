module Node.View exposing (view)

{-| Node / Next.js Staff Engineer view. Layout cloned from
`Experimental2.View` (the polished /elixir design: dark sidebar,
3-column experience grid, sidebar Open Source + Education) but driven
from `Node.Data`, which carries Node-flavoured copy and no Variant
plumbing.

XP Flow and Tree3 are shown as separate position entries here, so the
12-position chronology is sliced as 3 on the overview page + 3-3-3 on
page two (the last column also carries Open Source and Education).

-}

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Html exposing (Html)
import Html.Attributes
import Node.Data as Data exposing (Institution, OpenSourceProject, Position, Project, Skill, SkillGroup)
import Util.List exposing (splitInTwo)
import View.Atom as Atom exposing (..)
import View.Colors as Colors
import View.Icon as Icon


type alias Options =
    { leader : Bool }


view : Options -> Browser.Document msg
view options =
    { title = "Oliver Searle-Barnes CV"
    , body =
        Html.node "style"
            []
            [ Html.text "@media print { [data-print=\"false\"] { display: none !important; } }" ]
            :: downloadLinkHtml options
            :: a4PagesLayout options
    }


pdfFileNameFor : Options -> String
pdfFileNameFor options =
    if options.leader then
        Data.leaderPdfFileName

    else
        Data.pdfFileName


downloadLinkHtml : Options -> Html msg
downloadLinkHtml options =
    let
        file =
            pdfFileNameFor options
    in
    Html.a
        [ Html.Attributes.href ("/" ++ file)
        , Html.Attributes.attribute "download" file
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



---- PAGE LAYOUT ----


a4PagesLayout : Options -> List (Html msg)
a4PagesLayout options =
    [ Element.layout
        [ Atom.bodyTextFont ]
        (column [ width fill ]
            [ overviewPage options
            , experiencePage options
            ]
        )
    ]



---- PAGE 1: overview + experience kick-off ----


overviewPage : Options -> Element msg
overviewPage options =
    Atom.a4Page [] <|
        row [ width fill, height fill ]
            [ pagePersonalDetailsSection options
            , Atom.verticalDivider
            , Atom.pageColumn [ spacing 20 ]
                [ pageSection "Introduction" introductionSection
                , pageSection "Skills" (skillsSection options)
                ]
            , Atom.verticalDivider
            , Atom.pageColumn [ spacing 26 ]
                [ pageSection "Experience" (experiencePage1Block options)
                ]
            ]


pageSection : String -> Element msg -> Element msg
pageSection title body =
    Atom.section []
        [ Atom.title1 [] title
        , body
        ]



---- DARK SIDEBAR ----


pagePersonalDetailsSection : Options -> Element msg
pagePersonalDetailsSection options =
    Atom.pageColumn [ spacing 0, Background.color Colors.grey, Font.color Colors.white ]
        [ column [ spacing 14, paddingEach { top = 80, right = 0, bottom = 0, left = 0 } ]
            [ overviewName
            , column [ spacing 10, paddingXY 0 4 ]
                (sidePanelLabelsFor options
                    |> List.map (\label -> el [ Font.light, Font.size 16 ] (text label))
                )
            ]
        , el [ height fill ] none
        , contentDetails
        , el [ height fill ] none
        , contactDetails
        ]


overviewName : Element msg
overviewName =
    column
        [ Font.color Colors.white
        , Font.size 34
        , Atom.titleFont
        , Font.bold
        , Atom.letterSpacing 1
        ]
        [ text "Oliver", text "Searle-Barnes" ]


contentDetails : Element msg
contentDetails =
    column
        [ Font.color Colors.white
        , spacing 8
        , Font.size 13
        , Font.light
        , Atom.letterSpacing 1
        ]
        [ row [ spacing 10 ] [ el [] (Icon.youtube 18), newTabLink [] { label = text "FnCasts (youtube)", url = "https://www.youtube.com/channel/UCEVIBi0jFVXrCvd7CdVYxvw" } ]
        , row [ spacing 10 ] [ el [] (Icon.github 18), newTabLink [] { label = text "opsb (200+ repos)", url = "https://github.com/opsb" } ]
        , row [ spacing 10 ] [ el [] (Icon.slack 18), el [] (text "opsb (14 communities)") ]
        , row [ spacing 10 ] [ el [] (Icon.stackoverflow 18), newTabLink [] { label = text "opsb (top 1%)", url = "https://stackoverflow.com/users/162337/opsb" } ]
        ]


contactDetails : Element msg
contactDetails =
    column [ Font.color Colors.white, spacing 8, Font.size 13, Font.light, Atom.letterSpacing 1 ]
        [ row [ spacing 10 ] [ el [] (Icon.twitter 18), newTabLink [] { label = text "ollysb", url = "https://twitter.com/ollysb" } ]
        , row [ spacing 10 ] [ el [] (Icon.envelope 18), link [] { label = text "oliver@opsb.co.uk", url = "mailto:oliver@opsb.co.uk" } ]
        ]



---- INTRODUCTION + SKILLS ----


introductionSection : Element msg
introductionSection =
    column [ spacing 14 ]
        (Data.introductionParagraphs
            |> List.map (\p -> Atom.paragraph [ Font.regular, Font.size 12 ] [ text p ])
        )


skillsSection : Options -> Element msg
skillsSection options =
    let
        ( leftGroups, rightGroups ) =
            splitInTwo (skillGroupsFor options)
    in
    row [ spacing 30, width fill ]
        [ skillGroupsColumn leftGroups
        , skillGroupsColumn rightGroups
        ]


skillGroupsColumn : List SkillGroup -> Element msg
skillGroupsColumn groups =
    column [ width (fillPortion 1), spacing 10, alignTop ] (List.map skillGroupView groups)


skillGroupView : SkillGroup -> Element msg
skillGroupView group =
    column [ width fill, spacing 8 ]
        [ el
            [ Atom.titleFont
            , Font.size 12
            , Font.color Colors.red
            , Font.bold
            ]
            (text group.name)
        , column [ width fill, spacing 8 ]
            (List.map skillRow group.skills)
        ]


skillRow : Skill -> Element msg
skillRow s =
    row [ width fill ]
        [ el [ Font.size 12, Font.color Colors.grey ] (text s.name)
        , el [ width fill, paddingXY 8 0 ]
            (el
                [ width fill
                , height (px 9)
                , htmlAttribute (Html.Attributes.style "border-bottom" "1px dotted rgba(140,140,148,0.7)")
                ]
                Element.none
            )
        , el [ Font.size 12, Font.color Colors.grey, alignRight ] (text (formatYears s.years))
        ]


formatYears : Float -> String
formatYears y =
    let
        i =
            floor y

        base =
            if toFloat i == y then
                String.fromInt i

            else
                String.fromFloat y
    in
    base ++ "y"



---- EDUCATION + OPEN SOURCE ----


educationSection : Element msg
educationSection =
    column [ width fill ] (List.map institutionView Data.education)


institutionView : Institution -> Element msg
institutionView inst =
    newTabLink [ width fill ]
        { url = inst.link
        , label =
            column [ spacing 5, width fill ]
                [ row [ width fill ]
                    [ el [ alignLeft ] (Atom.title3 [] inst.course)
                    , el [ alignRight ] (Atom.title3 [] inst.result)
                    ]
                , row [ width fill ]
                    [ el [ alignLeft ] (Atom.bodyText [] inst.name)
                    , el [ alignRight ] (Atom.bodyText [] (String.fromInt inst.startYear ++ "-" ++ String.fromInt inst.endYear))
                    ]
                ]
        }


openSourceSection : Element msg
openSourceSection =
    column [ spacing 12, width fill ]
        (List.map openSourceProject Data.openSourceProjects)


openSourceProject : OpenSourceProject -> Element msg
openSourceProject project =
    column [ spacing 4, width fill ]
        [ newTabLink [ width fill ]
            { url = project.repo
            , label = Atom.title3 [ Font.size 13, Font.medium ] project.name
            }
        , Atom.paragraph [ Font.size 12, Font.regular, Atom.lineHeight 17 ] [ text project.overview ]
        ]



---- EXPERIENCE SPLIT ----


{-| 12 positions total. Page 1 carries the most-recent two (XP Flow, Tree3);
page 2 carries the rest split across three columns.
-}
experiencePage1Block : Options -> Element msg
experiencePage1Block options =
    column [ spacing 26, width fill ]
        (List.map positionView (page1Positions options))


experiencePage : Options -> Element msg
experiencePage options =
    Atom.a4Page [] <|
        row [ width fill, height fill ]
            [ Atom.pageColumn [ spacing 22, paddingEach { top = 22, right = 20, bottom = 10, left = 20 } ]
                (List.map positionView (page2Col1Positions options))
            , Atom.verticalDivider
            , Atom.pageColumn [ spacing 22, paddingEach { top = 22, right = 20, bottom = 10, left = 20 } ]
                (List.map positionView (page2Col2Positions options))
            , Atom.verticalDivider
            , Atom.pageColumn [ spacing 22, paddingEach { top = 22, right = 20, bottom = 10, left = 20 } ]
                (List.map positionView (page2Col3Positions options)
                    ++ [ pageSection "Education" educationSection ]
                )
            ]


experiencePositions : Options -> List Position
experiencePositions options =
    List.map (applyLeaderOverrides options) Data.experiencePositions


sidePanelLabelsFor : Options -> List String
sidePanelLabelsFor options =
    if options.leader then
        Data.leaderSidePanelLabels

    else
        Data.sidePanelLabels


skillGroupsFor : Options -> List Data.SkillGroup
skillGroupsFor options =
    if options.leader then
        Data.leaderSkillGroups

    else
        Data.skillGroups


{-| When `?leader=true` is set on the `/node` route, the CV is reframed
as a hands-on CTO pitch: XP Flow leads with the CPO + Founding Engineer
title, and the sidebar headline switches to "Hands-on CTO · Staff Engineer"
(see `sidePanelLabelsFor`).
-}
applyLeaderOverrides : Options -> Position -> Position
applyLeaderOverrides options position =
    if options.leader && position.company == "XP Flow" then
        { position | title = "CPO and Founding Engineer" }

    else
        position


page1Positions : Options -> List Position
page1Positions options =
    List.take 2 (experiencePositions options)


page2Positions : Options -> List Position
page2Positions options =
    List.drop 2 (experiencePositions options)


page2Col1Positions : Options -> List Position
page2Col1Positions options =
    List.take 3 (page2Positions options)


page2Col2Positions : Options -> List Position
page2Col2Positions options =
    page2Positions options |> List.drop 3 |> List.take 3


page2Col3Positions : Options -> List Position
page2Col3Positions options =
    List.drop 6 (page2Positions options)



---- POSITION ----


positionView : Position -> Element msg
positionView position =
    column [ spacing 6, width fill, paddingEach { top = 0, right = 0, bottom = 8, left = 0 } ]
        [ Element.paragraph
            [ titleFont
            , Font.size 17
            , Font.bold
            , Font.color Colors.grey
            ]
            [ text (String.replace "\n" "" position.company)
            , el [ Atom.letterSpacing -2, paddingXY 8 0 ] (text "//")
            , text (Data.positionTitle position)
            ]
        , companyStackLine position.companyStack
        , Atom.bodyText [ Font.size 10, Font.regular, Font.italic ] (position.dates ++ "  ·  " ++ position.location)
        , column [ spacing 16, width fill, paddingEach { top = 8, right = 0, bottom = 0, left = 0 } ]
            (let
                projects =
                    visibleProjectsFor position

                showTitle =
                    List.length projects > 1
             in
             List.map (projectView { showTitle = showTitle }) projects
            )
        ]


{-| Informa stays on the timeline as a position-level entry (it's the
earliest big-engineering chapter), but the project bullets are Java /
Oracle / WebDAV and aren't on-target for a Next.js audience, so they're
hidden here. Myschooldirect keeps its overview but drops bullets to
ease pressure on the third column of page 2.
-}
visibleProjectsFor : Position -> List Project
visibleProjectsFor position =
    if position.company == "Informa" then
        []

    else if position.company == "Myschooldirect" then
        List.map clearTalkingPoints position.projects

    else
        position.projects


clearTalkingPoints : Project -> Project
clearTalkingPoints project =
    { project | talkingPoints = [] }


companyStackLine : List String -> Element msg
companyStackLine stack =
    case stack of
        [] ->
            none

        _ ->
            el
                [ Font.size 12
                , Font.color Colors.red
                ]
                (text (String.join ", " stack))


projectView : { showTitle : Bool } -> Project -> Element msg
projectView { showTitle } project =
    let
        titleNode =
            if showTitle then
                Atom.title3 [ Font.size 13, Font.medium, Font.color Colors.grey ] project.name

            else
                none
    in
    column [ spacing 5, width fill ]
        [ titleNode
        , Atom.paragraph [ Font.size 12, Font.regular, Atom.lineHeight 17 ] [ text project.overview ]
        , talkingPointsBlock project.talkingPoints
        ]


talkingPointsBlock : List String -> Element msg
talkingPointsBlock points =
    case points of
        [] ->
            none

        _ ->
            column
                [ spacing 5
                , paddingEach { top = 5, right = 0, bottom = 0, left = 8 }
                , width fill
                ]
                (List.map bulletItem points)


bulletItem : String -> Element msg
bulletItem t =
    row [ spacing 8, alignTop, width fill ]
        [ el [ Font.size 12, Font.color Colors.red, alignTop, Font.bold ] (text "•")
        , Atom.paragraph [ Font.size 12, Font.regular, Atom.lineHeight 17 ] [ text t ]
        ]
