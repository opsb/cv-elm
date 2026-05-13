module Experimental.View exposing (view)

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Data
import Experimental.Data as ExpData
import Html exposing (Html)
import Html.Attributes


view : Browser.Document msg
view =
    { title = "Oliver Searle-Barnes — CV"
    , body =
        [ Html.node "style"
            []
            [ Html.text "html, body { background-color: rgb(232, 230, 224) !important; } @media print { [data-print=\"false\"] { display: none !important; } }" ]
        , downloadLinkHtml
        , Element.layout pageAttrs page
        ]
    }


pdfFileName : String
pdfFileName =
    "Oliver-Searle-Barnes-Elixir-Editorial-2026.pdf"


downloadLinkHtml : Html msg
downloadLinkHtml =
    Html.a
        [ Html.Attributes.href ("/" ++ pdfFileName)
        , Html.Attributes.attribute "download" pdfFileName
        , Html.Attributes.attribute "data-print" "false"
        , Html.Attributes.style "position" "fixed"
        , Html.Attributes.style "top" "16px"
        , Html.Attributes.style "right" "20px"
        , Html.Attributes.style "font-family" "DM Sans, Helvetica, Arial, sans-serif"
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



---- TOKENS ----


{-| The variant for the experimental (sidebar) content — drives Profile/Skills/etc. -}
primaryVariant : ExpData.Variant
primaryVariant =
    ExpData.Elixir


{-| The variant for the canonical /elixir experience content. Structurally the same as
`primaryVariant` but a distinct Elm type, so we keep a parallel value.
-}
primaryVariantData : Data.Variant
primaryVariantData =
    Data.Elixir


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
        , section "Experience (continued)" experienceBlockPage2
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
        , sectionDivider
        , section "Experience" experienceBlockPage1
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
        (ExpData.introductionParagraphsFor primaryVariant
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
        (List.map institutionItem ExpData.education)


institutionItem : ExpData.Institution -> Element msg
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
        (List.map skillGroupItem (ExpData.skillGroupsFor primaryVariant))


skillGroupItem : ExpData.SkillGroup -> Element msg
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
        (List.map openSourceItem ExpData.openSourceProjects)


openSourceItem : ExpData.OpenSourceProject -> Element msg
openSourceItem proj =
    column [ spacing 3, width fill ]
        [ subSectionHeader proj.name
        , el [ Font.size 12, Font.color subtleColor ]
            (text (proj.shortInvolvement ++ " · " ++ proj.language))
        ]



---- EXPERIENCE ----


{-| How many positions render on page 1 (under Profile, in the right column).
The remainder flows onto page 2. Tune visually if the page 1 right column overflows
or runs short.
-}
page1ExperienceCount : Int
page1ExperienceCount =
    1


experiencePositionsAll : List Data.Position
experiencePositionsAll =
    Data.experiencePositionsFor primaryVariantData


experienceBlockPage1 : Element msg
experienceBlockPage1 =
    column [ spacing 26, width fill ]
        (experiencePositionsAll
            |> List.take page1ExperienceCount
            |> List.map positionBlock
        )


experienceBlockPage2 : Element msg
experienceBlockPage2 =
    column [ spacing 26, width fill ]
        (experiencePositionsAll
            |> List.drop page1ExperienceCount
            |> List.map positionBlock
        )


positionBlock : Data.Position -> Element msg
positionBlock position =
    column [ spacing 8, width fill ]
        [ subSectionHeader (Data.positionTitle primaryVariantData position)
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


projectBlock : Data.Project -> Element msg
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
