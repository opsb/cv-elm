module View.Atom exposing (a4Page, attrsEl, bodyText, bodyTextFont, id, letterSpacing, lineHeight, pageColumn, paragraph, section, title1, title2, title3, title4, titleFont, verticalDivider)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Html.Attributes
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
        , Font.size 28
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
        , Font.size 17
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
        , Font.size 12
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


paragraph : List (Element.Attribute msg) -> String -> Element msg
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
    Element.paragraph (defaultAttrs ++ customAttrs) [ text body ]


bodyText : List (Element.Attribute msg) -> String -> Element msg
bodyText customAttrs text_ =
    attrsEl
        [ bodyTextFont, Font.color Colors.grey, Font.size 12, Font.light ]
        customAttrs
        (text text_)



---- FONTS ----


bodyTextFont =
    Font.family
        [ Font.typeface "Museo Sans"
        , Font.typeface "Sans Serif"
        ]


titleFont =
    Font.family
        [ Font.typeface "Proxima Nova"
        , Font.typeface "Sans Serif"
        ]



---- PAGES ----


a4Page : List (Element.Attribute msg) -> (Element msg -> Element msg)
a4Page attrs =
    let
        pageAttrs =
            [ htmlAttribute <| Html.Attributes.style "height" "209.88mm"
            , htmlAttribute <| Html.Attributes.style "width" "297mm"
            , htmlAttribute <| Html.Attributes.attribute "data-class" "page"
            , htmlAttribute <| Html.Attributes.attribute "page-break-after" "always"
            , htmlAttribute <| Html.Attributes.attribute "page-break-before" "always"
            , htmlAttribute <| Html.Attributes.attribute "overflow" "hidden"
            ]
    in
    el (pageAttrs ++ attrs)
