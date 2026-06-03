module EmAts.View exposing (view)

{-| ATS-optimised Engineering Manager (player-coach) CV at `/em-ats` — the
default for blind / ATS apply-flows. Single-column linear flow, white
background, plain-text contact line, standard section names, `•` bullets,
comma-separated skills, no tables / images / columns. Each role opens with a
`Scope:` line (team size + area), the signature EM-CV convention.

Layout mirrors `Experimental3.View` (the Elixir ATS cut); copy comes from
`EmAts.Data`. The designed two-page sibling lives at `/em`.

-}

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import EmAts.Data as Data
import Html exposing (Html)
import Html.Attributes


view : Browser.Document msg
view =
    { title = "Oliver Searle-Barnes CV"
    , body =
        [ Html.node "style" [] [ Html.text printStyles ]
        , downloadLinkHtml
        , Element.layout pageAttrs pagesColumn
        ]
    }


downloadLinkHtml : Html msg
downloadLinkHtml =
    Html.a
        [ Html.Attributes.href ("/" ++ Data.pdfFileName)
        , Html.Attributes.attribute "download" Data.pdfFileName
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
html, body { background-color: #f4f4f4 !important; margin: 0; padding: 0; }

@page { size: A4 portrait; margin: 0; }

@media screen {
    [data-class="page"] {
        margin: 0 auto 16px auto;
        box-shadow: 0 1px 4px rgba(0,0,0,0.15);
    }
}

@media print {
    html, body { background-color: #ffffff !important; }
    [data-print="false"] { display: none !important; }
    [data-class="page"] { box-shadow: none !important; margin: 0 !important; }
}
"""



---- TOKENS ----


textColor : Color
textColor =
    rgb255 24 24 28


subtleColor : Color
subtleColor =
    rgb255 80 80 88


ruleColor : Color
ruleColor =
    rgb255 200 200 205


accentBlue : Color
accentBlue =
    rgb255 47 84 150


bgColor : Color
bgColor =
    rgb255 255 255 255


pageGrey : Color
pageGrey =
    rgb255 244 244 244


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
    , Background.color pageGrey
    , width fill
    , height fill
    , Font.size 14
    , lineHeight 1.3
    ]


{-| The CV laid out as stacked fixed-height A4 sheets (210mm × 297mm). Content
is split explicitly across sheets, sized so nothing overflows the page box.
-}
pagesColumn : Element msg
pagesColumn =
    column [ centerX, width shrink, spacing 0 ]
        [ a4Sheet page1Body
        , a4Sheet page2Body
        , a4Sheet page3Body
        ]


a4Sheet : List (Element msg) -> Element msg
a4Sheet body =
    column
        [ htmlAttribute (Html.Attributes.style "width" "210mm")
        , htmlAttribute (Html.Attributes.style "height" "297mm")
        , htmlAttribute (Html.Attributes.style "padding" "12mm 15mm")
        , htmlAttribute (Html.Attributes.style "box-sizing" "border-box")
        , htmlAttribute (Html.Attributes.attribute "data-class" "page")
        , htmlAttribute (Html.Attributes.style "page-break-after" "always")
        , htmlAttribute (Html.Attributes.style "overflow" "hidden")
        , Background.color bgColor
        , spacing 24
        ]
        body


page1Body : List (Element msg)
page1Body =
    [ header
    , section "Profile" summaryBlock
    , section "Core Capabilities" skillsBlock
    , section "Experience" (experienceList (List.take 1 Data.positions))
    ]


page2Body : List (Element msg)
page2Body =
    [ experienceList (Data.positions |> List.drop 1 |> List.take 4) ]


page3Body : List (Element msg)
page3Body =
    [ experienceList (List.drop 5 Data.positions)
    , section "Open Source Projects" openSourceBlock
    , section "Education" educationBlock
    , communityBlock
    ]


communityBlock : Element msg
communityBlock =
    Element.paragraph
        [ Font.size 14, lineHeight 1.32 ]
        [ el [ Font.bold ] (text "Community: ")
        , text "FnCasts (coding on YouTube), Stack Overflow top 1%, Barcelona Elm hack-night organiser."
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
        [ Font.size 34
        , Font.bold
        , letterSpacing 0.5
        ]
        (text Data.name)


taglineLine : Element msg
taglineLine =
    el
        [ Font.size 14
        , Font.italic
        , Font.color accentBlue
        ]
        (text Data.tagline)


contactLine : Element msg
contactLine =
    Element.paragraph
        [ Font.size 14
        , width fill
        , paddingEach { top = 8, right = 0, bottom = 0, left = 0 }
        ]
        [ el [ Font.bold ] (text "Email: ")
        , text "oliver@opsb.co.uk  |  "
        , el [ Font.bold ] (text "LinkedIn: ")
        , text "linkedin.com/in/oliversearlebarnes  |  "
        , el [ Font.bold ] (text "GitHub: ")
        , text "github.com/opsb"
        ]


contactRow : String -> String -> Element msg
contactRow label value =
    Element.paragraph
        [ Font.size 14, lineHeight 1.32 ]
        [ el [ Font.bold ] (text (label ++ ": "))
        , text value
        ]



---- SECTIONS ----


section : String -> Element msg -> Element msg
section title body =
    column [ spacing 8, width fill ]
        [ sectionHeader title
        , body
        ]


sectionHeader : String -> Element msg
sectionHeader title =
    column [ spacing 6, width fill ]
        [ el
            [ Font.size 21
            , Font.bold
            , Font.color accentBlue
            , letterSpacing 1.5
            ]
            (text (String.toUpper title))
        , el
            [ width fill
            , height (px 1)
            , Background.color accentBlue
            ]
            none
        ]



---- SUMMARY ----


summaryBlock : Element msg
summaryBlock =
    column [ spacing 14, width fill ]
        (Data.summaryParagraphs
            |> List.map
                (\p ->
                    Element.paragraph
                        [ Font.size 14, lineHeight 1.32 ]
                        [ text p ]
                )
        )



---- SKILLS ----


skillsBlock : Element msg
skillsBlock =
    column [ spacing 6, width fill ]
        (List.map skillGroupLine Data.skillGroups)


skillGroupLine : Data.SkillGroup -> Element msg
skillGroupLine group =
    Element.paragraph
        [ Font.size 14, lineHeight 1.32 ]
        [ el [ Font.bold ] (text (group.name ++ ": "))
        , text (String.join ", " group.skills)
        ]



---- EXPERIENCE ----


experienceList : List Data.Position -> Element msg
experienceList ps =
    column [ spacing 24, width fill ]
        (List.map positionBlock ps)


positionBlock : Data.Position -> Element msg
positionBlock position =
    column [ spacing 4, width fill ]
        [ el
            [ Font.size 20, Font.bold ]
            (text (position.company ++ " | " ++ position.dates))
        , el
            [ Font.size 14, Font.semiBold, Font.color textColor ]
            (text position.title)
        , scopeLine position.scope
        , stackLine position.stack
        , overviewLine position.overview
        , highlightsBlock position.highlights
        ]


scopeLine : Maybe String -> Element msg
scopeLine scope =
    case scope of
        Nothing ->
            none

        Just s ->
            Element.paragraph
                [ Font.size 14, lineHeight 1.32, paddingEach { top = 4, right = 0, bottom = 0, left = 0 } ]
                [ el [ Font.bold ] (text "Scope: ")
                , text s
                ]


stackLine : List String -> Element msg
stackLine stack =
    case stack of
        [] ->
            none

        _ ->
            Element.paragraph
                [ Font.size 12, Font.color textColor ]
                [ el [ Font.bold ] (text "Stack: ")
                , text (String.join ", " stack)
                ]


overviewLine : String -> Element msg
overviewLine overview =
    if String.isEmpty overview then
        none

    else
        Element.paragraph
            [ Font.size 14, lineHeight 1.32, paddingEach { top = 6, right = 0, bottom = 0, left = 0 } ]
            [ text overview ]


highlightsBlock : List String -> Element msg
highlightsBlock points =
    case points of
        [] ->
            none

        _ ->
            column [ spacing 4, paddingEach { top = 8, right = 0, bottom = 0, left = 20 }, width fill ]
                (List.map bulletItem points)


bulletItem : String -> Element msg
bulletItem t =
    row [ spacing 8, alignTop, width fill ]
        [ el [ Font.size 14, alignTop ] (text "•")
        , Element.paragraph
            [ Font.size 14, lineHeight 1.32 ]
            [ text t ]
        ]



---- EDUCATION ----


educationBlock : Element msg
educationBlock =
    column [ spacing 8, width fill ]
        (List.map institutionItem Data.education)


institutionItem : Data.Institution -> Element msg
institutionItem inst =
    column [ spacing 2, width fill ]
        [ Element.paragraph [ Font.size 15 ]
            [ el [ Font.bold ] (text inst.course)
            , el [ Font.color subtleColor ] (text (" · " ++ inst.result))
            ]
        , el [ Font.size 14, Font.color subtleColor ] (text inst.name)
        ]



---- OPEN SOURCE ----


openSourceBlock : Element msg
openSourceBlock =
    column [ spacing 6, width fill ]
        (List.map openSourceItem Data.openSource)


openSourceItem : Data.OpenSourceProject -> Element msg
openSourceItem proj =
    Element.paragraph
        [ Font.size 14, lineHeight 1.32 ]
        [ el [ Font.bold ] (text proj.name)
        , text (" (" ++ proj.shortInvolvement ++ ") | " ++ proj.language)
        ]
