module Main exposing (..)

import Time exposing (Time)
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events as Events
import Element.Input as Input
import Html exposing (Html)
import Style exposing (StyleSheet, style, prop)
import Style.Background as Background
import Style.Border as Border
import Style.Color as Color
import Style.Filter as Filter
import Style.Font as Font
import Style.Scale as Scale
import Style.Shadow as Shadow
import Style.Sheet as Sheet
import Style.Transition as Transition
import Color


-- STYLES


type Styles
    = Main
    | Page
    | Title


stylesheet =
    Style.styleSheet
        [ Style.style Title
            [ Color.text colors.darkGrey
            , Color.background colors.white
            , Font.size 25 -- all units given as px
            ]
        , Style.style Main
            [ Font.typeface [ Font.font "helvetica" ]
            , Color.background colors.lightGrey
            ]
        , Style.style Page
            [ prop "width" "210mm"
            , prop "height" "296mm"
            , prop "box-shadow" "0 .5mm 2mm rgba(0,0,0,.3)"
            , prop "margin-top" "20mm"
            , prop "margin-bottom" "20mm"
            , Color.background colors.white
            ]
        ]


colors =
    { white = Color.white
    , darkGrey = Color.grey
    , black = Color.black
    , lightGrey = Color.rgba 224 224 224 1
    }



---- MODEL ----


type alias Model =
    { experience : List Position
    }


type alias Position =
    { title : String
    , location : String
    , company : String
    , projects : List Project
    }


type alias Project =
    { name : String
    , startDate : Time
    , endDate : Time
    }


init : ( Model, Cmd Msg )
init =
    ( { experience = initExperience }, Cmd.none )


initExperience =
    [ { title = "VP Engineering", location = "London", company = "Zapnito", projects = [] }
    , { title = "CTO", location = "London", company = "Lytbulb", projects = [] }
    , { title = "CTO", location = "London", company = "Myschooldirect", projects = [] }
    , { title = "Tech lead", location = "London", company = "Informa", projects = [] }
    , { title = "CTO", location = "Brighton", company = "Nutshell Development", projects = [] }
    , { title = "Contractor", location = "Brighton", company = "Runtime Collective", projects = [] }
    ]



---- UPDATE ----


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    Element.viewport stylesheet <|
        column Main
            []
            [ el Page [ center ] <|
                el Title [] (text "Oliver Searle-Barnes")
            , el Page [ center ] <|
                el Title [] (text "Oliver Searle-Barnes")
            ]



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
