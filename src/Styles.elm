module Styles exposing (..)

import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Color


colors =
    { white = Color.white
    , darkGrey = Color.grey
    , black = Color.black
    , lightGrey = Color.rgba 244 244 244 1
    , lighterGrey = Color.rgba 140 140 140 1
    , blue = Color.rgba 148 196 252 100
    , transparent = Color.rgba 255 255 255 0
    }


grey level =
    Color.rgba level level level 1


fonts =
    { roboto =
        Font.family [ Font.typeface "Roboto" ]
    , helvetica =
        Font.family [ Font.typeface "helvetica neue" ]
    }


h1Size =
    30


h3Size =
    16


h4Size =
    10
