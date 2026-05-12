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
    rgb255 24 24 28


subtleColor : Color
subtleColor =
    rgb255 120 120 128


ruleColor : Color
ruleColor =
    rgb255 210 210 215


paperColor : Color
paperColor =
    rgb255 244 244 242


outerBg : Color
outerBg =
    rgb255 232 230 224


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
        [ centerX
        , spacing 24
        ]
        [ a4Page page1
        , a4Page page2
        ]


page1 : Element msg
page1 =
    column
        [ width fill
        , height fill
        , paddingXY 56 56
        , spacing 32
        ]
        [ header
        , horizontalRule
        , twoColumnBody
        ]


page2 : Element msg
page2 =
    column
        [ width fill
        , height fill
        , paddingXY 56 56
        , spacing 28
        ]
        [ page2Header
        , horizontalRule
        , section "Experience" experienceBlock
        ]


page2Header : Element msg
page2Header =
    row [ width fill, spacing 30, alignTop ]
        [ el
            [ Font.size 16
            , Font.bold
            , letterSpacing 4
            , alignLeft
            ]
            (text "OLIVER SEARLE-BARNES")
        , el
            [ Font.size 11
            , Font.light
            , letterSpacing 4
            , Font.color subtleColor
            , alignRight
            ]
            (text (String.toUpper "page 2 of 2"))
        ]


a4Page : Element msg -> Element msg
a4Page body =
    el
        [ width fill
        , htmlAttribute (Html.Attributes.style "width" "210mm")
        , htmlAttribute (Html.Attributes.style "height" "297mm")
        , htmlAttribute (Html.Attributes.style "page-break-after" "always")
        , htmlAttribute (Html.Attributes.style "page-break-before" "always")
        , htmlAttribute (Html.Attributes.style "overflow" "hidden")
        , htmlAttribute (Html.Attributes.attribute "data-class" "page")
        , Background.color paperColor
        , Border.shadow
            { offset = ( 0, 4 )
            , size = 0
            , blur = 22
            , color = rgba 0 0 0 0.08
            }
        ]
        body



---- HEADER ----


header : Element msg
header =
    row [ width fill, spacing 30, alignTop ]
        [ headerLeft
        , headerRight
        ]


headerLeft : Element msg
headerLeft =
    column [ alignLeft, spacing 16, width fill, alignBottom ]
        [ column
            [ Font.size 42
            , letterSpacing 6
            , spacing 6
            ]
            [ el [ Font.bold ] (text "OLIVER")
            , el [ Font.light ] (text "SEARLE-BARNES")
            ]
        , el
            [ Font.size 14
            , Font.light
            , Font.color subtleColor
            , letterSpacing 8
            ]
            (text (String.toUpper "Senior Elixir Engineer"))
        ]


headerRight : Element msg
headerRight =
    column
        [ alignRight
        , alignTop
        , spacing 12
        , Font.size 12
        , paddingEach { top = 6, right = 0, bottom = 0, left = 0 }
        ]
        [ contactRow "oliver@opsb.co.uk" "✉"
        , contactRow "Barcelona, Spain · UK RTW" "⌂"
        , contactRow "linkedin.com/in/oliversearlebarnes" "in"
        , contactRow "github.com/opsb" "↗"
        ]


contactRow : String -> String -> Element msg
contactRow value glyph =
    row [ spacing 16, alignRight ]
        [ el [ Font.size 13, Font.color textColor ] (text value)
        , el
            [ Font.size 12
            , Font.color textColor
            , width (px 16)
            , height (px 16)
            , Background.color textColor
            , Font.color paperColor
            , Font.center
            , Font.size 10
            , Font.bold
            , Border.rounded 2
            ]
            (el [ centerX, centerY ] (text glyph))
        ]



---- RULES ----


horizontalRule : Element msg
horizontalRule =
    el
        [ width fill
        , height (px 1)
        , Background.color ruleColor
        ]
        none


sectionDivider : Element msg
sectionDivider =
    el
        [ width (px 28)
        , height (px 1)
        , Background.color ruleColor
        , paddingEach { top = 0, right = 0, bottom = 0, left = 0 }
        ]
        none


horizontalDividerFull : Element msg
horizontalDividerFull =
    el
        [ width fill
        , height (px 1)
        , Background.color ruleColor
        ]
        none



---- TWO-COLUMN BODY ----


twoColumnBody : Element msg
twoColumnBody =
    row [ width fill, spacing 50, alignTop ]
        [ leftColumn
        , rightColumn
        ]


leftColumn : Element msg
leftColumn =
    column [ width (fillPortion 3), alignTop, spacing 28 ]
        [ section "Education" educationBlock
        , sectionDivider
        , section "Skills" skillsBlock
        , sectionDivider
        , section "Open Source" openSourceBlock
        ]


rightColumn : Element msg
rightColumn =
    column [ width (fillPortion 5), alignTop, spacing 28 ]
        [ section "Profile" aboutBlock
        ]



---- SECTIONS ----


section : String -> Element msg -> Element msg
section title body =
    column [ spacing 18, width fill, alignTop ]
        [ sectionHeader title
        , body
        ]


sectionHeader : String -> Element msg
sectionHeader title =
    el
        [ Font.size 16
        , Font.regular
        , letterSpacing 6
        , Font.color textColor
        ]
        (text (String.toUpper title))


subSectionHeader : String -> Element msg
subSectionHeader title =
    el
        [ Font.size 12
        , Font.bold
        , letterSpacing 2.5
        , Font.color textColor
        ]
        (text (String.toUpper title))


metaLabel : String -> Element msg
metaLabel s =
    el
        [ Font.size 11
        , Font.regular
        , letterSpacing 2
        , Font.color subtleColor
        ]
        (text (String.toUpper s))



---- ABOUT / PROFILE ----


aboutBlock : Element msg
aboutBlock =
    column [ spacing 10, width fill ]
        (Data.introductionParagraphsFor primaryVariant
            |> List.map
                (\p ->
                    Element.paragraph
                        [ Font.size 13
                        , lineHeight 1.6
                        , Font.color textColor
                        ]
                        [ text p ]
                )
        )



---- EDUCATION ----


educationBlock : Element msg
educationBlock =
    column [ spacing 16, width fill ]
        (List.map institutionItem Data.education)


institutionItem : Institution -> Element msg
institutionItem inst =
    column [ spacing 4, width fill ]
        [ subSectionHeader inst.course
        , el [ Font.size 13, Font.color subtleColor ] (text inst.name)
        , el [ Font.size 12, Font.color subtleColor ]
            (text (String.fromInt inst.startYear ++ " – " ++ String.fromInt inst.endYear))
        ]



---- SKILLS ----


skillsBlock : Element msg
skillsBlock =
    column [ spacing 18, width fill ]
        (List.map skillGroupItem (Data.skillGroupsFor primaryVariant))


skillGroupItem : SkillGroup -> Element msg
skillGroupItem group =
    column [ spacing 6, width fill ]
        [ subSectionHeader group.name
        , column [ spacing 2, width fill ]
            (group.skills
                |> List.map
                    (\s ->
                        row [ width fill ]
                            [ el [ Font.size 13, Font.color textColor, alignLeft ] (text s.name)
                            , el [ Font.size 11, Font.color subtleColor, alignRight ]
                                (text (formatYears s.years))
                            ]
                    )
            )
        ]


formatYears : Float -> String
formatYears y =
    let
        rounded =
            round y
    in
    if toFloat rounded == y then
        String.fromInt rounded ++ "y"

    else
        String.fromFloat y ++ "y"



---- OPEN SOURCE ----


openSourceBlock : Element msg
openSourceBlock =
    column [ spacing 14, width fill ]
        (List.map openSourceItem Data.openSourceProjects)


openSourceItem : OpenSourceProject -> Element msg
openSourceItem proj =
    column [ spacing 3, width fill ]
        [ subSectionHeader proj.name
        , el [ Font.size 12, Font.color subtleColor ]
            (text (proj.shortInvolvement ++ " · " ++ proj.language))
        ]



---- EXPERIENCE ----


experienceBlock : Element msg
experienceBlock =
    column [ spacing 26, width fill ]
        (Data.experiencePositionsFor primaryVariant
            |> List.map positionBlock
        )


positionBlock : Position -> Element msg
positionBlock position =
    column [ spacing 8, width fill ]
        [ subSectionHeader (Data.positionTitle primaryVariant position)
        , metaLabel
            (positionCompanyClean position.company
                ++ "   |   "
                ++ position.dates
            )
        , companyStackLine position.companyStack
        , column [ spacing 12, width fill ]
            (List.map projectBlock position.projects)
        ]


positionCompanyClean : String -> String
positionCompanyClean company =
    String.replace "\n" "" company


companyStackLine : List String -> Element msg
companyStackLine stack =
    case stack of
        [] ->
            none

        _ ->
            el
                [ Font.size 11
                , Font.color subtleColor
                , Font.italic
                , letterSpacing 0.5
                ]
                (text (String.join " / " stack))


projectBlock : Project -> Element msg
projectBlock project =
    column [ spacing 6, width fill ]
        [ el
            [ Font.size 13
            , Font.bold
            , Font.color textColor
            ]
            (text project.name)
        , Element.paragraph
            [ Font.size 13
            , lineHeight 1.55
            , Font.color textColor
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
            column [ spacing 4, paddingEach { top = 6, right = 0, bottom = 0, left = 14 }, width fill ]
                (List.map bulletItem points)


bulletItem : String -> Element msg
bulletItem t =
    row [ spacing 10, alignTop, width fill ]
        [ el [ Font.size 12, Font.color textColor, alignTop ] (text "•")
        , Element.paragraph
            [ Font.size 12
            , lineHeight 1.55
            , Font.color textColor
            ]
            [ text t ]
        ]
