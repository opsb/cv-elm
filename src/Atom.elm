module Atom exposing (a4Page, sectionTitle, bodyText)

import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element exposing (..)
import Html exposing (Html)
import Html.Attributes
import Extra.Element exposing (..)


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


sectionTitle : List (Attribute msg) -> String -> Element msg
sectionTitle props title =
    el
        (List.append props
            [ paddingEach { bottom = 16, top = 0, left = 0, right = 0 }
            , uppercase
            , Font.size h2Size
            , Font.letterSpacing 2
            , Font.weight 600
            ]
        )
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


h2Size =
    20


fonts =
    { roboto =
        Font.family [ Font.typeface "Roboto" ]
    , helvetica =
        Font.family [ Font.typeface "helvetica neue" ]
    }
