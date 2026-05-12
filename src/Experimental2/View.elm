module Experimental2.View exposing (view)

import Browser
import Data exposing (Institution, OpenSourceProject, Position, Project, SkillGroup, Variant(..))
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
    , body = a4PagesLayout
    }


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
            , Atom.pageColumn [ spacing 25 ]
                [ pageSection "Introduction" introductionSection
                , pageSection "Skills" skillsSection
                , pageSection "Education" educationSection
                ]
            , Atom.verticalDivider
            , Atom.pageColumn [ spacing 18 ]
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
    Atom.pageColumn [ spacing 30, Background.color Colors.grey, Font.color Colors.white ]
        [ column [ spacing 14 ]
            [ overviewName
            , column [ spacing 10, paddingXY 0 4 ]
                (Data.sidePanelLabels primaryVariant
                    |> List.map (\label -> el [ Font.light, Font.size 16 ] (text label))
                )
            ]
        , contentDetails
        , darkOpenSourceSection
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
    column [ spacing 1, width fill ]
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
        , el [ Font.size 10, Font.color Colors.white, alpha 0.65 ]
            (text (proj.shortInvolvement ++ " · " ++ proj.language))
        ]



---- SECTIONS reused from main design ----


introductionSection : Element msg
introductionSection =
    column [ spacing 12 ]
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
    column [ width (fillPortion 1), spacing 6, alignTop ] (List.map skillGroupView groups)


skillGroupView : SkillGroup -> Element msg
skillGroupView group =
    column [ width fill, spacing 3 ]
        [ Atom.title5 [ Font.size 11, Font.color Colors.red, Font.bold ] group.name
        , column [ width fill, spacing 1 ]
            (List.map
                (\{ name, years } -> Atom.tableOfContentsLine name (String.fromFloat years))
                group.skills
            )
        ]


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
    column [ spacing 18, width fill ]
        (List.map positionView page1Positions)


experiencePage : Element msg
experiencePage =
    Atom.a4Page [] <|
        column [ width fill, height fill ]
            [ el
                [ width fill
                , paddingXY 20 10
                , Background.color Colors.grey
                ]
                (Atom.title1
                    [ Font.color Colors.white
                    , paddingEach { top = 5, right = 0, bottom = 0, left = 0 }
                    ]
                    "Experience — continued"
                )
            , row [ width fill, height fill ]
                [ Atom.pageColumn [ spacing 14, paddingXY 20 10 ]
                    (List.map positionView page2Col1Positions)
                , Atom.verticalDivider
                , Atom.pageColumn [ spacing 14, paddingXY 20 10 ]
                    (List.map positionView page2Col2Positions)
                , Atom.verticalDivider
                , Atom.pageColumn [ spacing 14, paddingXY 20 10 ]
                    (List.map positionView page2Col3Positions)
                ]
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
    column [ spacing 4, width fill, paddingEach { top = 0, right = 0, bottom = 8, left = 0 } ]
        [ row [ width fill, spacing 10 ]
            [ el [ alignLeft ] (Atom.title3 [ Font.size 15, paddingEach { top = 0, right = 0, bottom = 0, left = 0 } ] (String.replace "\n" "" position.company))
            , el [ alignRight ] (Element.paragraph [ titleFont, Font.size 13, Font.bold, Font.color Colors.red, Font.alignRight ] [ text (Data.positionTitle primaryVariant position) ])
            ]
        , row [ width fill, spacing 10 ]
            [ el [ alignLeft ] (companyStackLine position.companyStack)
            , el [ alignRight ] (Atom.bodyText [ Font.size 10, Font.regular ] position.dates)
            ]
        , column [ spacing 8, width fill, paddingEach { top = 4, right = 0, bottom = 0, left = 0 } ]
            (List.map projectView position.projects)
        ]


companyStackLine : List String -> Element msg
companyStackLine stack =
    case stack of
        [] ->
            none

        _ ->
            el
                [ Font.size 11
                , Font.color Colors.grey
                , Font.bold
                ]
                (text (String.join " / " stack))


projectView : Project -> Element msg
projectView project =
    column [ spacing 4, width fill ]
        [ Atom.title3 [ Font.size 13, Font.medium ] project.name
        , Atom.paragraph [ Font.size 12, Font.regular ] [ text project.overview ]
        , talkingPointsBlock project.talkingPoints
        ]


talkingPointsBlock : List String -> Element msg
talkingPointsBlock points =
    case points of
        [] ->
            none

        _ ->
            column
                [ spacing 3
                , paddingEach { top = 4, right = 0, bottom = 0, left = 8 }
                , width fill
                ]
                (List.map bulletItem points)


bulletItem : String -> Element msg
bulletItem t =
    row [ spacing 6, alignTop, width fill ]
        [ el [ Font.size 11, Font.color Colors.red, alignTop, Font.bold ] (text "•")
        , Atom.paragraph [ Font.size 11, Font.regular ] [ text t ]
        ]
