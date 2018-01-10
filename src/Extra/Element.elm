module Extra.Element exposing (..)

import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element exposing (..)
import Html exposing (Html)
import Html.Attributes


borderRight n =
    Border.widthEach { right = n, left = 0, top = 0, bottom = 0 }


paddingRight n =
    paddingEach { right = n, left = 0, top = 0, bottom = 0 }


paddingBottom pxs =
    paddingEach { bottom = pxs, top = 0, left = 0, right = 0 }


paddingLeft n =
    paddingEach { right = 0, left = n, top = 0, bottom = 0 }


uppercase =
    attribute <| Html.Attributes.style [ ( "text-transform", "uppercase" ) ]


hyphenatedText =
    attribute <| Html.Attributes.style [ ( "hyphens", "auto" ) ]
