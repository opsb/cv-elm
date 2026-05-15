module Experimental3.View exposing (view)

{-| ATS-optimised CV view. Keeps the typography tokens from /experimental
(DM Sans family, lined-text body, capitalised section headings) but strips
the layout decorations that confuse Applicant Tracking Systems:

  - single column linear flow (no two-column body, no A4 page cards)
  - white background, no warm-paper / shadow / colour blocks
  - plain-text contact line (no icon glyphs, no boxed letterforms)
  - standard section names ("Summary", "Skills", "Experience", "Education",
    "Open Source Projects")
  - standard `•` bullets only
  - skills as comma-separated runs per group, not a column grid
  - no tables, no images, no headers/footers
  - selectable text throughout; fonts fall back to Helvetica/Arial so that
    a stripped-PDF parser still sees the unicode

Data sources mirror /experimental: `Data` (canonical /elixir module) drives
the Experience section; `Experimental.Data` drives the Summary/Skills/
Education/Open Source sidebar content that already reads as Elixir-track tuned.

-}

import Browser
import Data
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Experimental.Data as ExpData
import Html exposing (Html)
import Html.Attributes
import View.Colors as Colors


view : Browser.Document msg
view =
    { title = "Oliver Searle-Barnes CV"
    , body =
        [ Html.node "style"
            []
            [ Html.text printStyles ]
        , downloadLinkHtml
        , Element.layout pageAttrs page
        ]
    }


pdfFileName : String
pdfFileName =
    "Oliver-Searle-Barnes-Senior-Elixir-Engineer-ATS-2026.pdf"


{-| Small fixed-position link in the top-right so it stays visible while
scrolling. Marked `data-print="false"` so the print/PDF pipeline strips it.
-}
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
        , Html.Attributes.style "color" "#404048"
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
html, body { background-color: #ffffff !important; margin: 0; padding: 0; }

@page { size: A4 portrait; margin: 14mm; }

@media print {
    html, body { background-color: #ffffff !important; }
    [data-print="false"] { display: none !important; }
    [data-class="page"] { page-break-before: auto !important; page-break-after: auto !important; }
}
"""



---- TOKENS ----


primaryVariant : ExpData.Variant
primaryVariant =
    ExpData.Elixir


primaryVariantData : Data.Variant
primaryVariantData =
    Data.Elixir


textColor : Color
textColor =
    rgb255 24 24 28


subtleColor : Color
subtleColor =
    rgb255 80 80 88


ruleColor : Color
ruleColor =
    rgb255 200 200 205


bgColor : Color
bgColor =
    rgb255 255 255 255


redColor : Color
redColor =
    Colors.red


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
    , Background.color bgColor
    , width fill
    , height fill
    , Font.size 12
    , lineHeight 1.45
    ]


page : Element msg
page =
    el
        [ centerX
        , width (fill |> maximum 640)
        , paddingXY 40 48
        ]
        bodyColumn


bodyColumn : Element msg
bodyColumn =
    column [ spacing 44, width fill ]
        [ header
        , section "Summary" summaryBlock
        , section "Skills" skillsBlock
        , section "Education" educationBlock
        , section "Experience" experienceBlock
        , section "Open Source Projects" openSourceBlock
        ]



---- HEADER ----


header : Element msg
header =
    column [ spacing 6, width fill ]
        [ nameLine
        , taglineLine
        , contactLine
        ]


nameLine : Element msg
nameLine =
    el
        [ Font.size 41
        , Font.bold
        , letterSpacing 0.5
        ]
        (text "Oliver Searle-Barnes")


taglineLine : Element msg
taglineLine =
    el
        [ Font.size 13
        , Font.color textColor
        ]
        (text "Senior Elixir/React Engineer | Thoughtclay Ltd")


contactLine : Element msg
contactLine =
    column
        [ spacing 6
        , width fill
        , paddingEach { top = 18, right = 0, bottom = 0, left = 0 }
        ]
        [ contactRow "Email" "oliver@opsb.co.uk"
        , contactRow "LinkedIn" "linkedin.com/in/oliversearlebarnes"
        , contactRow "GitHub" "github.com/opsb"
        ]


contactRow : String -> String -> Element msg
contactRow label value =
    Element.paragraph
        [ Font.size 12, lineHeight 1.5 ]
        [ el [ Font.bold ] (text (label ++ ": "))
        , text value
        ]



---- SECTIONS ----


section : String -> Element msg -> Element msg
section title body =
    column [ spacing 16, width fill ]
        [ sectionHeader title
        , body
        ]


sectionHeader : String -> Element msg
sectionHeader title =
    column [ spacing 6, width fill ]
        [ el
            [ Font.size 24
            , Font.bold
            , letterSpacing 1.5
            ]
            (text (String.toUpper title))
        , el
            [ width fill
            , height (px 1)
            , Background.color ruleColor
            ]
            none
        ]



---- SUMMARY ----


summaryBlock : Element msg
summaryBlock =
    column [ spacing 14, width fill ]
        (Data.introductionParagraphsFor Data.Leadership
            |> List.map
                (\p ->
                    Element.paragraph
                        [ Font.size 12
                        , lineHeight 1.5
                        ]
                        [ text p ]
                )
        )



---- SKILLS ----


skillsBlock : Element msg
skillsBlock =
    column [ spacing 6, width fill ]
        (ExpData.skillGroupsFor primaryVariant
            |> List.map skillGroupLine
        )


skillGroupLine : ExpData.SkillGroup -> Element msg
skillGroupLine group =
    Element.paragraph
        [ Font.size 12, lineHeight 1.5 ]
        (el [ Font.bold ] (text (group.name ++ ": "))
            :: (group.skills
                    |> List.map skillTokens
                    |> List.intersperse [ text ",\u{2002}" ]
                    |> List.concat
               )
        )


skillTokens : { name : String, years : Float } -> List (Element msg)
skillTokens s =
    [ text s.name
    , text " "
    , el [ Font.size 9, Font.color subtleColor ] (text (formatYears s.years))
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



---- EXPERIENCE ----


experienceBlock : Element msg
experienceBlock =
    column [ spacing 50, width fill ]
        (Data.experiencePositionsFor primaryVariantData
            |> List.map positionBlock
        )


positionBlock : Data.Position -> Element msg
positionBlock position =
    column [ spacing 4, width fill ]
        [ el
            [ Font.size 18, Font.bold ]
            (text (positionCompanyClean position.company ++ " | " ++ position.dates))
        , el
            [ Font.size 13, Font.semiBold, Font.color textColor ]
            (text (Data.positionTitle primaryVariantData position))
        , companyStackLine position.companyStack
        , column [ spacing 22, paddingEach { top = 10, right = 0, bottom = 0, left = 20 }, width fill ]
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
            Element.paragraph
                [ Font.size 11, Font.color textColor ]
                [ el [ Font.bold ] (text "Stack: ")
                , text (String.join ", " stack)
                ]


projectBlock : Data.Project -> Element msg
projectBlock project =
    column [ spacing 6, width fill ]
        [ el [ Font.size 13, Font.bold, Font.color textColor ] (text project.name)
        , Element.paragraph [ Font.size 12, lineHeight 1.5 ] [ text project.overview ]
        , talkingPointsBlock project.talkingPoints
        ]


talkingPointsBlock : List String -> Element msg
talkingPointsBlock points =
    case points of
        [] ->
            none

        _ ->
            column [ spacing 4, width fill ]
                (List.map bulletItem points)


bulletItem : String -> Element msg
bulletItem t =
    row [ spacing 8, alignTop, width fill ]
        [ el [ Font.size 12, alignTop ] (text "•")
        , Element.paragraph
            [ Font.size 12
            , lineHeight 1.5
            ]
            [ text t ]
        ]



---- EDUCATION ----


educationBlock : Element msg
educationBlock =
    column [ spacing 8, width fill ]
        (List.map institutionItem ExpData.education)


institutionItem : ExpData.Institution -> Element msg
institutionItem inst =
    column [ spacing 2, width fill ]
        [ Element.paragraph [ Font.size 14 ]
            [ el [ Font.bold ] (text inst.course)
            , el [ Font.color subtleColor ] (text (" · " ++ inst.result))
            ]
        , el [ Font.size 12, Font.color subtleColor ] (text inst.name)
        ]



---- OPEN SOURCE ----


openSourceBlock : Element msg
openSourceBlock =
    column [ spacing 6, width fill ]
        (List.map openSourceItem ExpData.openSourceProjects)


openSourceItem : ExpData.OpenSourceProject -> Element msg
openSourceItem proj =
    Element.paragraph
        [ Font.size 12, lineHeight 1.5 ]
        [ el [ Font.bold ] (text proj.name)
        , text (" (" ++ proj.shortInvolvement ++ ") | " ++ proj.language)
        ]
