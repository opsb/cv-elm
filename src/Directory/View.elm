module Directory.View exposing (view)

{-| Screen index of every CV variant, served at `/directory`. Reads the
hand-maintained registry in `Directory.Data` and renders it as a grouped,
clickable list: route (navigates in-app), title, tagline, when-to-use, and a
direct PDF link. Not a print CV, so this is an ordinary scrolling page rather
than an A4 sheet, and it has no `generate-pdf` entry.
-}

import Browser
import Directory.Data as Data exposing (Entry, Group)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Html.Attributes


view : Browser.Document msg
view =
    { title = "Oliver Searle-Barnes CV directory"
    , body =
        [ Element.layout
            [ sans
            , Font.color bodyColor
            , Font.size 15
            , Background.color pageBg
            , width fill
            , height fill
            , paddingXY 24 48
            ]
            (column
                [ centerX
                , width (fill |> maximum 820)
                , spacing 36
                ]
                (heading :: List.map groupView Data.groups)
            )
        ]
    }


heading : Element msg
heading =
    column [ spacing 8, width fill ]
        [ el [ Font.size 32, Font.bold ] (text "CV directory")
        , paragraph
            [ Font.size 15, Font.color mutedColor, lineHeight 1.4 ]
            [ text "Every role-targeted cut and when to reach for it. Start from the track, then refine. Click a route to open the CV, or grab the PDF." ]
        ]



---- GROUP ----


groupView : Group -> Element msg
groupView group =
    column [ spacing 14, width fill ]
        [ groupHeader group.name
        , paragraph [ Font.size 14, Font.color mutedColor, lineHeight 1.4 ] [ text group.blurb ]
        , column [ spacing 10, width fill ] (List.map entryView group.entries)
        ]


groupHeader : String -> Element msg
groupHeader name =
    column [ spacing 4, width fill ]
        [ el
            [ Font.size 19
            , Font.bold
            , Font.color accentBlue
            ]
            (text name)
        , el [ width fill, height (px 2), Background.color accentBlue ] none
        ]



---- ENTRY ----


entryView : Entry -> Element msg
entryView entry =
    column
        [ spacing 6
        , width fill
        , paddingXY 16 14
        , Background.color cardBg
        , Border.rounded 6
        , Border.width 1
        , Border.color borderColor
        ]
        [ wrappedRow [ spacing 10, width fill ]
            [ routeLink entry.route
            , designTag entry.design
            , if entry.legacy then
                legacyTag

              else
                none
            , el [ alignRight ] (pdfLink entry.pdf)
            ]
        , el [ Font.size 15, Font.semiBold ] (text entry.title)
        , el [ Font.size 13, Font.italic, Font.color mutedColor ] (text entry.tagline)
        , paragraph [ Font.size 14, lineHeight 1.4, Font.color textColor ] [ text entry.when ]
        ]


routeLink : String -> Element msg
routeLink route =
    link
        [ Font.color accentBlue
        , Font.semiBold
        , Font.size 14
        , htmlAttribute (Html.Attributes.style "font-family" "ui-monospace, SFMono-Regular, Menlo, monospace")
        ]
        { url = route, label = text route }


pdfLink : Maybe String -> Element msg
pdfLink pdf =
    case pdf of
        Nothing ->
            none

        Just file ->
            newTabLink
                [ Font.color mutedColor
                , Font.size 13
                ]
                { url = "/" ++ file, label = text "PDF ↓" }


designTag : String -> Element msg
designTag design =
    el
        [ Font.size 11
        , Font.color accentBlue
        , Background.color accentTint
        , Border.rounded 3
        , Border.width 1
        , Border.color accentBorder
        , paddingXY 6 2
        ]
        (text design)


legacyTag : Element msg
legacyTag =
    el
        [ Font.size 11
        , Font.color mutedColor
        , Background.color pageBg
        , Border.rounded 3
        , Border.width 1
        , Border.color borderColor
        , paddingXY 6 2
        ]
        (text "legacy")



---- TOKENS ----


bodyColor : Color
bodyColor =
    rgb255 32 32 36


textColor : Color
textColor =
    rgb255 74 74 82


mutedColor : Color
mutedColor =
    rgb255 110 110 116


accentBlue : Color
accentBlue =
    rgb255 47 84 150


accentTint : Color
accentTint =
    rgb255 235 240 248


accentBorder : Color
accentBorder =
    rgb255 198 213 234


pageBg : Color
pageBg =
    rgb255 244 244 244


cardBg : Color
cardBg =
    rgb255 255 255 255


borderColor : Color
borderColor =
    rgb255 216 216 221


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
