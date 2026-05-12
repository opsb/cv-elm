module Experimental.View exposing (view)

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Experimental.Data as Data exposing (Institution, OpenSourceProject, Position, Project, SkillGroup, Variant(..))
import Html exposing (Html)
import Html.Attributes


view : Browser.Document msg
view =
    { title = "Oliver Searle-Barnes — CV"
    , body = [ Element.layout pageAttrs page ]
    }



---- TOKENS ----


primaryVariant : Variant
primaryVariant =
    Elixir


textColor : Color
textColor =
    rgb255 28 28 32


subtleColor : Color
subtleColor =
    rgb255 130 130 138


ruleColor : Color
ruleColor =
    rgb255 30 30 34


accentColor : Color
accentColor =
    rgb255 246 217 39


paperColor : Color
paperColor =
    rgb255 250 246 238


outerBg : Color
outerBg =
    rgb255 232 228 220


sans : Element.Attribute msg
sans =
    Font.family
        [ Font.typeface "DM Sans"
        , Font.typeface "Helvetica Neue"
        , Font.typeface "Helvetica"
        , Font.typeface "Arial"
        , Font.sansSerif
        ]


letterSpacing : Float -> Element.Attribute msg
letterSpacing px_ =
    htmlAttribute (Html.Attributes.style "letter-spacing" (String.fromFloat px_ ++ "px"))


lineHeight : Float -> Element.Attribute msg
lineHeight n =
    htmlAttribute (Html.Attributes.style "line-height" (String.fromFloat n))



---- LAYOUT ----


pageAttrs : List (Attribute msg)
pageAttrs =
    [ sans
    , Font.color textColor
    , Background.color outerBg
    , width fill
    , height fill
    , Font.size 13
    , lineHeight 1.5
    , paddingXY 0 40
    ]


page : Element msg
page =
    column
        [ width (fill |> maximum 960)
        , centerX
        , Background.color paperColor
        , paddingXY 64 56
        , spacing 32
        , Border.shadow
            { offset = ( 0, 4 )
            , size = 0
            , blur = 20
            , color = rgba 0 0 0 0.08
            }
        ]
        [ header
        , yellowRule
        , bodyRow "Profile" aboutBlock
        , bodyRow "Skills" skillsBlock
        , bodyRow "Work Experience" experienceBlock
        , bodyRow "Education" educationBlock
        , bodyRow "Open Source" openSourceBlock
        ]



---- HEADER ----


header : Element msg
header =
    row [ width fill, spacing 30, alignTop ]
        [ headerLeft
        , headerRight
        ]


headerLeft : Element msg
headerLeft =
    el
        [ alignTop
        , width fill
        , paddingEach { top = 16, right = 0, bottom = 12, left = 36 }
        , behindContent yellowCircle
        ]
        (column [ spacing 6 ]
            [ el
                [ Font.size 46
                , Font.bold
                , letterSpacing -0.5
                ]
                (text Data.name)
            , el
                [ Font.size 16
                , Font.regular
                , Font.color textColor
                ]
                (text "Senior Elixir Engineer · Tech Lead")
            ]
        )


yellowCircle : Element msg
yellowCircle =
    el
        [ width (px 100)
        , height (px 100)
        , Background.color accentColor
        , Border.rounded 50
        , alignLeft
        , alignTop
        ]
        none


headerRight : Element msg
headerRight =
    column
        [ alignRight
        , alignTop
        , spacing 12
        , Font.size 12
        , paddingEach { top = 8, right = 0, bottom = 0, left = 0 }
        ]
        [ contactRow "Email" "oliver@opsb.co.uk"
        , contactRow "Location" "Barcelona, Spain · UK RTW"
        , contactRow "GitHub" "github.com/opsb"
        , contactRow "LinkedIn" "/in/oliversearlebarnes"
        ]


contactRow : String -> String -> Element msg
contactRow label value =
    row [ spacing 14, alignRight ]
        [ el
            [ Font.size 10
            , Font.color subtleColor
            , letterSpacing 1.5
            , width (px 70)
            , Font.alignRight
            ]
            (text (String.toUpper label))
        , el [ Font.size 12, Font.color textColor ] (text value)
        ]



---- YELLOW RULE ----


yellowRule : Element msg
yellowRule =
    el
        [ width fill
        , height (px 3)
        , Background.color accentColor
        ]
        none



---- BODY ROW: section label (narrow left) | content (wide right) ----


bodyRow : String -> Element msg -> Element msg
bodyRow label content =
    row [ width fill, spacing 30, alignTop, paddingEach { top = 8, right = 0, bottom = 0, left = 0 } ]
        [ el [ width (fillPortion 2), alignTop ] (sectionLabel label)
        , el [ width (fillPortion 7), alignTop ] content
        ]


sectionLabel : String -> Element msg
sectionLabel s =
    column [ spacing 6, alignTop ]
        [ el
            [ Font.size 18
            , Font.bold
            ]
            (text s)
        , el
            [ width (px 32)
            , height (px 2)
            , Background.color ruleColor
            ]
            none
        ]



---- ABOUT / PROFILE ----


aboutBlock : Element msg
aboutBlock =
    column [ spacing 10, width fill ]
        (Data.introductionParagraphsFor primaryVariant
            |> List.map
                (\p ->
                    Element.paragraph
                        [ Font.size 13
                        , lineHeight 1.55
                        ]
                        [ text p ]
                )
        )



---- SKILLS ----


skillsBlock : Element msg
skillsBlock =
    wrappedRow [ spacing 22, width fill ]
        (List.map skillGroupItem (Data.skillGroupsFor primaryVariant))


skillGroupItem : SkillGroup -> Element msg
skillGroupItem group =
    column [ spacing 4, alignTop, width (px 170) ]
        [ el
            [ Font.size 11
            , Font.bold
            , letterSpacing 1.5
            ]
            (text (String.toUpper group.name))
        , column [ spacing 2 ]
            (group.skills
                |> List.map
                    (\s ->
                        Element.paragraph
                            [ Font.size 11
                            , lineHeight 1.45
                            ]
                            [ text "• "
                            , text s.name
                            ]
                    )
            )
        ]



---- EDUCATION ----


educationBlock : Element msg
educationBlock =
    column [ spacing 14, width fill ]
        (List.map institutionItem Data.education)


institutionItem : Institution -> Element msg
institutionItem inst =
    row [ width fill, spacing 25, alignTop ]
        [ el [ Font.size 12, width (px 110), alignTop ]
            (text (String.fromInt inst.startYear ++ " – " ++ String.fromInt inst.endYear))
        , column [ spacing 2, alignTop, width fill ]
            [ el [ Font.size 13, Font.bold ] (text inst.course)
            , el [ Font.size 12, Font.color subtleColor ] (text inst.name)
            ]
        ]



---- OPEN SOURCE ----


openSourceBlock : Element msg
openSourceBlock =
    column [ spacing 12, width fill ]
        (List.map openSourceItem Data.openSourceProjects)


openSourceItem : OpenSourceProject -> Element msg
openSourceItem proj =
    column [ spacing 2, width fill ]
        [ el
            [ Font.size 12
            , Font.bold
            ]
            (text proj.name)
        , Element.paragraph [ Font.size 11, Font.color subtleColor, lineHeight 1.4 ]
            [ text proj.shortInvolvement
            , text " · "
            , text proj.language
            ]
        ]



---- EXPERIENCE ----


experienceBlock : Element msg
experienceBlock =
    column
        [ spacing 24
        , width fill
        , Border.widthEach { top = 0, right = 0, bottom = 0, left = 2 }
        , Border.color accentColor
        , paddingEach { top = 0, right = 0, bottom = 0, left = 20 }
        ]
        (Data.experiencePositionsFor primaryVariant
            |> List.map positionBlock
        )


positionBlock : Position -> Element msg
positionBlock position =
    row [ width fill, spacing 24, alignTop ]
        [ positionLeftMeta position
        , positionRightContent position
        ]


positionLeftMeta : Position -> Element msg
positionLeftMeta position =
    column
        [ width (px 130)
        , alignTop
        , spacing 3
        ]
        [ el
            [ Font.size 12
            , Font.bold
            ]
            (text position.dates)
        , el
            [ Font.size 12
            , Font.color subtleColor
            ]
            (text (positionCompanyClean position.company))
        , el
            [ Font.size 11
            , Font.color subtleColor
            ]
            (text position.location)
        ]


positionCompanyClean : String -> String
positionCompanyClean company =
    String.replace "\n" "" company


positionRightContent : Position -> Element msg
positionRightContent position =
    column [ spacing 6, alignTop, width fill ]
        [ el
            [ Font.size 14
            , Font.bold
            ]
            (text (Data.positionTitle primaryVariant position))
        , companyStackLine position.companyStack
        , column [ spacing 10, width fill ]
            (List.map projectBlock position.projects)
        ]


companyStackLine : List String -> Element msg
companyStackLine stack =
    case stack of
        [] ->
            none

        _ ->
            el
                [ Font.size 11
                , Font.color subtleColor
                , letterSpacing 0.5
                ]
                (text (String.join " / " stack))


projectBlock : Project -> Element msg
projectBlock project =
    column [ spacing 5, width fill ]
        [ el
            [ Font.size 12
            , Font.bold
            ]
            (text project.name)
        , Element.paragraph
            [ Font.size 12
            , lineHeight 1.5
            ]
            [ text project.overview ]
        , talkingPointsBlock project.talkingPoints
        ]


talkingPointsBlock : List String -> Element msg
talkingPointsBlock points =
    case points of
        [] ->
            none

        _ ->
            column [ spacing 3, paddingEach { top = 4, right = 0, bottom = 0, left = 14 }, width fill ]
                (List.map bulletItem points)


bulletItem : String -> Element msg
bulletItem t =
    row [ spacing 8, alignTop, width fill ]
        [ el [ Font.size 11, Font.color accentColor, alignTop, Font.bold ] (text "•")
        , Element.paragraph
            [ Font.size 11
            , lineHeight 1.5
            ]
            [ text t ]
        ]
