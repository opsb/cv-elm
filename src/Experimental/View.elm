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
    rgb255 110 110 118


ruleColor : Color
ruleColor =
    rgb255 200 200 205


paperColor : Color
paperColor =
    rgb255 246 244 240


outerBg : Color
outerBg =
    rgb255 232 228 220


displaySerif : Element.Attribute msg
displaySerif =
    Font.family
        [ Font.typeface "Playfair Display"
        , Font.typeface "EB Garamond"
        , Font.typeface "Georgia"
        , Font.serif
        ]


bodySerif : Element.Attribute msg
bodySerif =
    Font.family
        [ Font.typeface "EB Garamond"
        , Font.typeface "Source Serif Pro"
        , Font.typeface "Georgia"
        , Font.serif
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
    [ bodySerif
    , Font.color textColor
    , Background.color outerBg
    , width fill
    , height fill
    , Font.size 14
    , lineHeight 1.55
    , paddingXY 0 40
    ]


page : Element msg
page =
    column
        [ width (fill |> maximum 960)
        , centerX
        , Background.color paperColor
        , paddingXY 70 60
        , spacing 36
        , Border.shadow
            { offset = ( 0, 4 )
            , size = 0
            , blur = 22
            , color = rgba 0 0 0 0.08
            }
        ]
        [ header
        , horizontalRule
        , twoColumnBody
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
    column [ alignLeft, spacing 8, width fill, alignBottom ]
        [ el
            [ displaySerif
            , Font.size 58
            , Font.regular
            , letterSpacing -0.5
            ]
            (text Data.name)
        , el
            [ Font.size 15
            , Font.color textColor
            , letterSpacing 6
            , Font.italic
            ]
            (text (String.toUpper "Senior Elixir Engineer · Tech Lead"))
        ]


headerRight : Element msg
headerRight =
    column
        [ alignRight
        , alignTop
        , spacing 8
        , Font.size 13
        ]
        [ contactRow "+44 phone on request" "☏"
        , contactRow "oliver@opsb.co.uk" "✉"
        , contactRow "Barcelona, Spain · UK RTW" "⌂"
        , contactRow "linkedin.com/in/oliversearlebarnes" "in"
        , contactRow "github.com/opsb" "↗"
        ]


contactRow : String -> String -> Element msg
contactRow value glyph =
    row [ spacing 12, alignRight ]
        [ el [ Font.size 13, Font.color textColor ] (text value)
        , el
            [ Font.size 13
            , Font.color textColor
            , width (px 18)
            , Font.center
            ]
            (text glyph)
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


verticalRule : Element msg
verticalRule =
    el
        [ width (px 1)
        , height fill
        , Background.color ruleColor
        ]
        none



---- TWO-COLUMN BODY ----


twoColumnBody : Element msg
twoColumnBody =
    row [ width fill, spacing 36, height fill, alignTop ]
        [ leftColumn
        , verticalRule
        , rightColumn
        ]


leftColumn : Element msg
leftColumn =
    column [ width (fillPortion 3), alignTop, spacing 28 ]
        [ sidebarSection "Education" educationBlock
        , sidebarSection "Skills" skillsBlock
        , sidebarSection "Open Source" openSourceBlock
        ]


rightColumn : Element msg
rightColumn =
    column [ width (fillPortion 7), alignTop, spacing 28 ]
        [ sidebarSection "Profile" aboutBlock
        , sidebarSection "Experience" experienceBlock
        ]



---- SECTION HEADERS ----


sidebarSection : String -> Element msg -> Element msg
sidebarSection title body =
    column [ spacing 14, width fill, alignTop ]
        [ el
            [ displaySerif
            , Font.size 22
            , Font.regular
            ]
            (text title)
        , body
        ]



---- ABOUT / PROFILE ----


aboutBlock : Element msg
aboutBlock =
    column [ spacing 10, width fill ]
        (Data.introductionParagraphsFor primaryVariant
            |> List.map
                (\p ->
                    Element.paragraph
                        [ Font.size 14
                        , lineHeight 1.55
                        ]
                        [ text p ]
                )
        )



---- EDUCATION ----


educationBlock : Element msg
educationBlock =
    column [ spacing 14, width fill ]
        (List.map institutionItem Data.education)


institutionItem : Institution -> Element msg
institutionItem inst =
    column [ spacing 2, width fill ]
        [ el [ Font.size 13, Font.bold ] (text inst.course)
        , el [ Font.size 13 ] (text inst.name)
        , el [ Font.size 12, Font.color subtleColor ]
            (text (String.fromInt inst.startYear ++ " – " ++ String.fromInt inst.endYear))
        ]



---- SKILLS ----


skillsBlock : Element msg
skillsBlock =
    column [ spacing 16, width fill ]
        (List.map skillGroupItem (Data.skillGroupsFor primaryVariant))


skillGroupItem : SkillGroup -> Element msg
skillGroupItem group =
    column [ spacing 3, width fill ]
        [ el
            [ Font.size 13
            , Font.bold
            ]
            (text group.name)
        , column [ spacing 1 ]
            (group.skills
                |> List.map
                    (\s ->
                        Element.paragraph
                            [ Font.size 13
                            , lineHeight 1.4
                            ]
                            [ text s.name ]
                    )
            )
        ]



---- OPEN SOURCE ----


openSourceBlock : Element msg
openSourceBlock =
    column [ spacing 14, width fill ]
        (List.map openSourceItem Data.openSourceProjects)


openSourceItem : OpenSourceProject -> Element msg
openSourceItem proj =
    column [ spacing 2, width fill ]
        [ el
            [ Font.size 13
            , Font.bold
            ]
            (text proj.name)
        , Element.paragraph [ Font.size 12, Font.color subtleColor, lineHeight 1.4 ]
            [ text proj.shortInvolvement
            , text " · "
            , text proj.language
            ]
        ]



---- EXPERIENCE ----


experienceBlock : Element msg
experienceBlock =
    column [ spacing 22, width fill ]
        (Data.experiencePositionsFor primaryVariant
            |> List.map positionBlock
        )


positionBlock : Position -> Element msg
positionBlock position =
    column [ spacing 8, width fill ]
        [ positionTitleLine position
        , companyStackLine position.companyStack
        , column [ spacing 10, width fill ]
            (List.map projectBlock position.projects)
        ]


positionTitleLine : Position -> Element msg
positionTitleLine position =
    Element.paragraph
        [ Font.size 14
        , lineHeight 1.4
        ]
        [ el [ Font.bold ] (text (Data.positionTitle primaryVariant position))
        , el [ Font.color subtleColor ] (text "  |  ")
        , text (positionCompanyClean position.company)
        , el [ Font.color subtleColor ] (text "  |  ")
        , text position.dates
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
                [ Font.size 12
                , Font.color subtleColor
                , Font.italic
                ]
                (text (String.join " / " stack))


projectBlock : Project -> Element msg
projectBlock project =
    column [ spacing 6, width fill ]
        [ el
            [ Font.size 13
            , Font.bold
            ]
            (text project.name)
        , Element.paragraph
            [ Font.size 13
            , lineHeight 1.55
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
            column [ spacing 5, paddingEach { top = 6, right = 0, bottom = 0, left = 12 }, width fill ]
                (List.map bulletItem points)


bulletItem : String -> Element msg
bulletItem t =
    row [ spacing 10, alignTop, width fill ]
        [ el [ Font.size 13, Font.color textColor, alignTop ] (text "•")
        , Element.paragraph
            [ Font.size 13
            , lineHeight 1.5
            ]
            [ text t ]
        ]
