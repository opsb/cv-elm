module View.Atom exposing
    ( a4Page
    , attrsEl
    , autolink
    , bodyText
    , bodyTextFont
    , horizontalDivider
    , id
    , letterSpacing
    , lineHeight
    , monospacedFont
    , pageColumn
    , paragraph
    , section
    , tableOfContentsLine
    , title1
    , title2
    , title3
    , title4
    , titleFont
    , verticalDivider
    )

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Html.Attributes
import Util.List exposing (splitInTwo)
import Util.String exposing (autolink)
import View.Colors as Colors


lineHeight : Int -> Element.Attribute msg
lineHeight lineHeight_ =
    htmlAttribute <| Html.Attributes.style "line-height" (String.fromInt lineHeight_ ++ "px")


letterSpacing : Float -> Element.Attribute msg
letterSpacing letterSpacing_ =
    htmlAttribute <| Html.Attributes.style "letter-spacing" (String.fromFloat letterSpacing_ ++ "px")


id : String -> Element.Attribute msg
id =
    htmlAttribute << Html.Attributes.attribute "id"


title1 : List (Element.Attribute msg) -> String -> Element msg
title1 customAttrs title_ =
    attrsEl
        [ titleFont
        , Font.size 26
        , Font.bold
        , Font.color Colors.grey
        , letterSpacing 1
        ]
        customAttrs
        (text <| String.toUpper <| title_)


title2 : List (Element.Attribute msg) -> String -> Element msg
title2 customAttrs title_ =
    attrsEl
        [ titleFont
        , Font.size 24
        , Font.bold
        , Font.color Colors.grey
        , letterSpacing 0.5
        ]
        customAttrs
        (text title_)


title3 : List (Element.Attribute msg) -> String -> Element msg
title3 customAttrs title_ =
    attrsEl
        [ titleFont
        , Font.size 18
        , Font.color Colors.grey
        , Font.semiBold
        , letterSpacing -0.2
        ]
        customAttrs
        (text title_)


title4 : List (Element.Attribute msg) -> String -> Element msg
title4 customAttrs title_ =
    attrsEl
        [ titleFont
        , Font.size 14
        , Font.color Colors.grey
        ]
        customAttrs
        (text title_)


verticalDivider : Element msg
verticalDivider =
    el
        [ width (px 5)
        , Background.color Colors.lightestGrey
        , height fill
        ]
        (text " ")


horizontalDivider : Element msg
horizontalDivider =
    el
        [ height (px 5)
        , Background.color Colors.lightGrey
        , width fill
        ]
        (text " ")


attrsEl : List (Element.Attribute msg) -> List (Element.Attribute msg) -> Element msg -> Element msg
attrsEl defaultAttrs customAttrs body =
    el
        (defaultAttrs ++ customAttrs)
        body


pageColumn : List (Element.Attribute msg) -> List (Element msg) -> Element msg
pageColumn attrs body =
    let
        defaultAttrs =
            [ width (fillPortion 1)
            , height fill
            , padding 20
            , spacing 30
            , Background.color Colors.white
            ]
    in
    column (defaultAttrs ++ attrs) body


section : List (Element.Attribute msg) -> List (Element msg) -> Element msg
section attrs body =
    let
        defaultAttrs =
            [ spacing 15
            , width fill
            ]
    in
    column (defaultAttrs ++ attrs) body


paragraph : List (Element.Attribute msg) -> List (Element msg) -> Element msg
paragraph customAttrs body =
    let
        defaultAttrs =
            [ Font.alignLeft
            , bodyTextFont
            , Font.color Colors.grey
            , Font.size 13
            , Font.light
            , lineHeight 18
            ]
    in
    Element.paragraph (defaultAttrs ++ customAttrs) body


bodyText : List (Element.Attribute msg) -> String -> Element msg
bodyText customAttrs text_ =
    attrsEl
        [ bodyTextFont, Font.color Colors.grey, Font.size 12, Font.light ]
        customAttrs
        (text text_)


tableOfContentsLine : String -> String -> Element msg
tableOfContentsLine leftText rightText =
    row [ width fill, Font.family [ Font.monospace ] ]
        [ el
            [ Font.color
                Colors.grey
            , paddingEach { bottom = 0, left = 0, top = 0, right = 5 }
            ]
            (title4 [ Font.family [ Font.monospace ], Font.size 11 ] leftText)
        , el
            [ width fill
            , Border.dotted
            , Border.color Colors.lightGrey
            , Border.widthEach { bottom = 1, left = 0, top = 0, right = 0 }
            , moveUp 7
            , Font.color Colors.lightGrey
            ]
            (text " ")
        , el
            [ Font.color Colors.grey
            , paddingEach { bottom = 0, left = 5, top = 0, right = 0 }
            ]
            (title4 [ Font.family [ Font.monospace ], Font.size 12 ] rightText)
        ]


autolink : String -> Element msg
autolink text_ =
    let
        config =
            { mapText = text
            , mapLink = \link -> newTabLink [ Font.medium ] { url = link, label = text link }
            }
    in
    case Util.String.autolink config text_ of
        Ok paragraphItems ->
            paragraph [] paragraphItems

        Err _ ->
            paragraph [] [ text text_ ]


bullets : List String -> Element msg
bullets items =
    column [ spacing 15 ] <|
        List.map
            (\item ->
                row [ spacing 3 ]
                    [ bodyText [ alignTop ] "•"
                    , paragraph [ Font.size 11, lineHeight 14 ] [ text item ]
                    ]
            )
            items



---- FONTS ----


bodyTextFont =
    Font.family
        [ Font.typeface "Museo Sans"
        , Font.typeface "Helvetica Neue"
        , Font.typeface "Helvetica"
        , Font.typeface "Arial"
        , Font.typeface "Sans Serif"
        ]


titleFont =
    Font.family
        [ Font.typeface "Proxima Nova"
        , Font.typeface "Helvetica Neue"
        , Font.typeface "Helvetica"
        , Font.typeface "Arial"
        , Font.typeface "Sans Serif"
        ]


monospacedFont =
    Font.family
        [ Font.typeface "monospace" ]



---- PAGES ----


a4Page : List (Element.Attribute msg) -> (Element msg -> Element msg)
a4Page attrs =
    let
        pageAttrs =
            [ htmlAttribute <| Html.Attributes.style "height" "210mm"
            , htmlAttribute <| Html.Attributes.style "width" "297.3mm"
            , htmlAttribute <| Html.Attributes.attribute "data-class" "page"
            , htmlAttribute <| Html.Attributes.style "page-break-after" "always"
            , htmlAttribute <| Html.Attributes.style "page-break-before" "always"
            , htmlAttribute <| Html.Attributes.style "overflow" "hidden"
            ]
    in
    el (pageAttrs ++ attrs)
