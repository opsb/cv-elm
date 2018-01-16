module Atom
    exposing
        ( a4Page
        , sectionTitle
        , bodyText
        , verticalLine
        , section
        , subSectionTitle
        , columnDivider
        , smallTitle
        , metaTitle
        , headerTitle
        , headerSubTitle
        , keyValueTable
        )

import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element exposing (..)
import Html exposing (Html)
import Html.Attributes
import Extra.Element exposing (..)
import Styles exposing (..)


a4Page attrs =
    let
        pageAttrs =
            [ attribute <|
                Html.Attributes.style
                    [ ( "width", "210mm" )
                    , ( "height", "296mm" )
                    ]
            , attribute <| Html.Attributes.attribute "data-class" "page"
            ]
    in
        el (pageAttrs ++ attrs)


headerTitle title =
    el
        [ center
        , padding 20
        , Font.color colors.black
        , Font.size h1Size
        , Border.color colors.blue
        , Border.width 2
        , uppercase
        , Font.letterSpacing 4
        , width <| shrink
        , Font.weight 400
        ]
        (text title)


headerSubTitle title =
    el
        [ center
        , padding 10
        , uppercase
        , Font.letterSpacing 2
        , Font.size 12
        ]
        (text title)


section title child =
    column
        []
        [ sectionTitle [ alignRight ] title
        , child
        ]


sectionTitle : List (Attribute msg) -> String -> Element msg
sectionTitle props title =
    el
        (List.append props
            [ paddingEach { bottom = 16, top = 0, left = 0, right = 0 }
            , uppercase
            , Font.size 20
            , Font.letterSpacing 2
            , Font.weight 600
            , Font.color colors.black
            ]
        )
        (text title)


subSectionTitle title =
    el
        [ paddingBottom 3
        , Font.size 13
        , Font.weight 800
        , uppercase
        , Font.letterSpacing 1
        , alignLeft
        ]
        (text title)


smallTitle : String -> Element msg
smallTitle title =
    el
        [ paddingBottom 1
        , Font.size 10
        , Font.letterSpacing 1
        , uppercase
        , Font.weight 600
        , alignRight
        ]
        (text title)


metaTitle title =
    el
        [ Font.size 10
        , Font.color colors.lighterGrey
        , Font.letterSpacing 1
        , alignLeft
        ]
        (text title)


bodyText string =
    paragraph
        [ Font.size 12
        , Font.lineHeight 1.4
        , fonts.roboto
        , Font.weight 300
        , Font.letterSpacing 0.5
        , paddingBottom 6
        ]
        [ text <| string ]


fonts =
    { roboto =
        Font.family [ Font.typeface "Roboto" ]
    , helvetica =
        Font.family [ Font.typeface "helvetica neue" ]
    }


verticalLine { width, color } =
    el [ height <| fill, borderLeft width, Border.color color ] (text "")


columnDivider =
    verticalLine { color = colors.blue, width = 2 }


keyValueTable : List { key : String, value : String } -> Element msg
keyValueTable data =
    column
        [ Font.size 12
        , Font.alignRight
        , fonts.roboto
        ]
    <|
        flip List.map data <|
            \{ key, value } ->
                row
                    [ paddingBottom 5, alignBottom, spaceEvenly, alignLeft ]
                    [ el [] (text key)
                    , el [ Font.weight 300, fonts.roboto ] <| text <| value
                    ]
