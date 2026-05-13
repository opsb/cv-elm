module Experimental2.View exposing (view)

import Browser
import Data exposing (Institution, OpenSourceProject, Position, Project, Skill, SkillGroup, Variant(..))
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Html exposing (Html)
import Html.Attributes
import Util.List exposing (splitInTwo)
import View.Atom as Atom exposing (..)
import View.Colors as Colors
import View.Icon as Icon


view : Browser.Document msg
view =
    { title = "Oliver Searle-Barnes — CV"
    , body =
        Html.node "style"
            []
            [ Html.text "@media print { [data-print=\"false\"] { display: none !important; } }" ]
            :: downloadLinkHtml
            :: a4PagesLayout
    }


pdfFileName : String
pdfFileName =
    "Oliver-Searle-Barnes-Senior-Elixir-Engineer-2026.pdf"


downloadLinkHtml : Html msg
downloadLinkHtml =
    Html.a
        [ Html.Attributes.href ("/" ++ pdfFileName)
        , Html.Attributes.attribute "download" pdfFileName
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


primaryVariant : Variant
primaryVariant =
    Elixir



---- PAGE LAYOUT ----


a4PagesLayout : List (Html msg)
a4PagesLayout =
    [ Element.layout
        [ Atom.bodyTextFont ]
        (column [ width fill ]
            [ overviewPage
            , experiencePage
            ]
        )
    ]



---- PAGE 1: overview + experience kick-off ----


overviewPage : Element msg
overviewPage =
    Atom.a4Page [] <|
        row [ width fill, height fill ]
            [ pagePersonalDetailsSection
            , Atom.verticalDivider
            , Atom.pageColumn [ spacing 20 ]
                [ pageSection "Introduction" introductionSection
                , pageSection "Skills" skillsSection
                ]
            , Atom.verticalDivider
            , Atom.pageColumn [ spacing 26 ]
                [ pageSection "Experience" experiencePage1Block
                ]
            ]


pageSection : String -> Element msg -> Element msg
pageSection title body =
    Atom.section []
        [ Atom.title1 [] title
        , body
        ]



---- DARK SIDEBAR (col 1) — now includes Open Source ----


pagePersonalDetailsSection : Element msg
pagePersonalDetailsSection =
    Atom.pageColumn [ spacing 0, Background.color Colors.grey, Font.color Colors.white ]
        [ column [ spacing 14, paddingEach { top = 80, right = 0, bottom = 0, left = 0 } ]
            [ overviewName
            , column [ spacing 10, paddingXY 0 4 ]
                (Data.sidePanelLabels primaryVariant
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
        [ row [ spacing 10 ] [ el [] (Icon.youtube 18), newTabLink [] { label = text "FnCasts — youtube", url = "https://www.youtube.com/channel/UCEVIBi0jFVXrCvd7CdVYxvw" } ]
        , row [ spacing 10 ] [ el [] (Icon.github 18), newTabLink [] { label = text "opsb — 200+ repos", url = "https://github.com/opsb" } ]
        , row [ spacing 10 ] [ el [] (Icon.slack 18), el [] (text "opsb — 14 communities") ]
        , row [ spacing 10 ] [ el [] (Icon.stackoverflow 18), newTabLink [] { label = text "opsb — top 1%", url = "https://stackoverflow.com/users/162337/opsb" } ]
        ]


contactDetails : Element msg
contactDetails =
    column [ Font.color Colors.white, spacing 8, Font.size 13, Font.light, Atom.letterSpacing 1 ]
        [ row [ spacing 10 ] [ el [] (Icon.twitter 18), newTabLink [] { label = text "ollysb", url = "https://twitter.com/ollysb" } ]
        , row [ spacing 10 ] [ el [] (Icon.envelope 18), link [] { label = text "oliver@opsb.co.uk", url = "mailto:oliver@opsb.co.uk" } ]
        ]


darkOpenSourceSection : Element msg
darkOpenSourceSection =
    column [ spacing 10, width fill ]
        [ el
            [ Font.color Colors.white
            , Font.size 14
            , Font.bold
            , Atom.titleFont
            , Atom.letterSpacing 1.5
            ]
            (text "OPEN SOURCE")
        , column [ spacing 8, width fill ]
            (List.map darkOpenSourceItem Data.openSourceProjects)
        ]


darkOpenSourceItem : OpenSourceProject -> Element msg
darkOpenSourceItem proj =
    column [ spacing 2, width fill ]
        [ newTabLink []
            { url = proj.repo
            , label =
                el
                    [ Font.color Colors.white
                    , Font.size 12
                    , Font.medium
                    ]
                    (text proj.name)
            }
        , Element.paragraph [ Font.size 10, Font.color Colors.white, alpha 0.7, Atom.lineHeight 13 ]
            [ text proj.overview ]
        ]



---- SECTIONS reused from main design ----


introductionSection : Element msg
introductionSection =
    column [ spacing 14 ]
        (Data.introductionParagraphsFor primaryVariant
            |> List.map (\p -> Atom.paragraph [ Font.regular ] [ text p ])
        )


skillsSection : Element msg
skillsSection =
    let
        ( leftGroups, rightGroups ) =
            splitInTwo (Data.skillGroupsFor primaryVariant)
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
        , el
            [ width fill
            , height (px 15)
            , paddingXY 10 0
            , htmlAttribute (Html.Attributes.style "background-image" "radial-gradient(circle, rgba(140,140,148,0.7) 0.7px, transparent 0.9px)")
            , htmlAttribute (Html.Attributes.style "background-size" "3px 3px")
            , htmlAttribute (Html.Attributes.style "background-position" "left bottom 1px")
            , htmlAttribute (Html.Attributes.style "background-repeat" "repeat-x")
            ]
            Element.none
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


---- EXPERIENCE SPLIT ----


experiencePage1Block : Element msg
experiencePage1Block =
    column [ spacing 26, width fill ]
        (List.map positionView page1Positions)


experiencePage : Element msg
experiencePage =
    Atom.a4Page [] <|
        row [ width fill, height fill ]
            [ Atom.pageColumn [ spacing 12, paddingEach { top = 22, right = 20, bottom = 10, left = 20 } ]
                (List.map positionView page2Col1Positions)
            , Atom.verticalDivider
            , Atom.pageColumn [ spacing 12, paddingEach { top = 22, right = 20, bottom = 10, left = 20 } ]
                (List.map positionView page2Col2Positions)
            , Atom.verticalDivider
            , Atom.pageColumn [ spacing 12, paddingEach { top = 22, right = 20, bottom = 10, left = 20 } ]
                (List.map positionView page2Col3Positions
                    ++ [ pageSection "Open Source" openSourceSection
                       , el [ height (px 12) ] none
                       , pageSection "Education" educationSection
                       ]
                )
            ]


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


chronologicalPositions : List Position
chronologicalPositions =
    [ engineerXpflowMerged
    , Data.experience.tastermonial
    , Data.experience.boulevard
    , Data.experience.vorwerk
    , Data.experience.ctm
    , Data.experience.twentyBn
    , Data.experience.liqid
    , Data.experience.zapnito
    , Data.experience.lytbulb
    , Data.experience.myschooldirect
    , Data.experience.informa
    ]


engineerXpflowMerged : Position
engineerXpflowMerged =
    Data.experienceColumnsFor primaryVariant
        |> .left
        |> List.head
        |> Maybe.withDefault Data.experience.xpflow


page1Positions : List Position
page1Positions =
    List.take 2 chronologicalPositions


page2Positions : List Position
page2Positions =
    List.drop 2 chronologicalPositions


page2Col1Positions : List Position
page2Col1Positions =
    List.take 3 page2Positions


page2Col2Positions : List Position
page2Col2Positions =
    page2Positions |> List.drop 3 |> List.take 3


page2Col3Positions : List Position
page2Col3Positions =
    List.drop 6 page2Positions



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
            , text (Data.positionTitle primaryVariant position)
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


{-| Per-variant project visibility for /elixir. Informa is kept on the timeline
as a position-level entry (it's the earliest big-engineering chapter), but the
project bullets — Java / Mondrian / Oracle / WebDAV — are not on-target for an
Elixir-engineer audience and are hidden here.
-}
visibleProjectsFor : Position -> List Project
visibleProjectsFor position =
    if position.company == "Informa" then
        []

    else
        position.projects


companyStackLine : List String -> Element msg
companyStackLine stack =
    case stack of
        [] ->
            none

        _ ->
            el
                [ Font.size 12
                , Font.color Colors.grey
                ]
                (text (String.join ", " stack))


projectView : { showTitle : Bool } -> Project -> Element msg
projectView { showTitle } project =
    let
        titleNode =
            if showTitle then
                Atom.title3 [ Font.size 13, Font.medium, Font.color Colors.red ] project.name

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
