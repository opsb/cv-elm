module Main exposing (..)

import Time exposing (Time)
import Element exposing (..)
import Element.Events as Events
import Element.Input as Input
import Html exposing (Html)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Color
import Data exposing (..)
import List.Extra
import Html.Attributes
import Atom exposing (..)
import Extra.Element exposing (..)
import Styles exposing (..)


--import Styles

import String.Extra
import Icon


type alias El =
    Element Msg


type alias Attr =
    Element.Attribute Msg



---- MODEL ----


type alias Model =
    { data : Data
    }


init : ( Model, Cmd Msg )
init =
    ( initModel, Cmd.none )


initModel =
    { data = Data.init
    }



---- UPDATE ----


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



---- VIEW ----


gutter =
    30


view : Model -> Html Msg
view model =
    Element.layout [ fonts.helvetica, Font.color colors.black, Background.color colors.transparent ] <|
        a4Page [ padding 30 ] <|
            column []
                -- HEADER
                [ column
                    [ center, width <| fill ]
                    [ headerTitle model.data.name
                    , headerSubTitle model.data.tagline
                    ]

                -- LEFT COLUMN
                , row [ paddingXY 0 20, spacing 30 ]
                    [ column []
                        [ section "Introduction" <|
                            column [] <|
                                flip List.map model.data.introduction <|
                                    (.body >> bodyText)
                        , section "Skills" <|
                            column [] <|
                                let
                                    ( columnA, columnB ) =
                                        splitInTwo model.data.skills
                                in
                                    [ row
                                        [ spacing 15 ]
                                        [ keyValueTable <| skillsData <| columnA
                                        , keyValueTable <| skillsData <| columnB
                                        ]
                                    ]
                        , section "Open Source" <|
                            column [ spacing 15 ] <|
                                flip List.map model.data.openSource <|
                                    \project ->
                                        column
                                            []
                                            [ smallTitle <| project.name ++ "  |  " ++ (String.toLower project.shortInvolvement)
                                            , bodyText project.overview
                                            ]
                        , section "Education" <|
                            column [] <|
                                flip List.map model.data.education <|
                                    \institution ->
                                        column
                                            []
                                            [ smallTitle <| institutionTitle <| institution
                                            , bodyText <| courseTitle <| institution
                                            ]
                        ]
                    , columnDivider

                    -- RIGHT COLUMN
                    , column []
                        [ section "Experience" <|
                            column
                                [ spacing 15 ]
                                (flip List.map model.data.experience <|
                                    \position ->
                                        column
                                            []
                                            [ subSectionTitle <| positionTitle <| position
                                            , metaTitle <| positionMetaTitle <| position
                                            , column [] <|
                                                (flip List.map position.projects <|
                                                    \project ->
                                                        column
                                                            [ paddingBottom 7 ]
                                                            [ smallTitle project.name
                                                            , bodyText <| project.overview ++ " " ++ (projectHashTags project)
                                                            ]
                                                )
                                            ]
                                )
                        ]
                    ]
                , footerView model
                ]



-- SECTIONS


splitInTwo list =
    let
        index =
            round (((toFloat <| List.length list) - 1) / (toFloat 2))
    in
        List.Extra.splitAt index list


skillsData skills =
    List.map (\skill -> { key = skill.name, value = toString skill.years ++ " years" }) skills


codify text =
    text
        |> String.Extra.replace "/" ""
        |> String.Extra.underscored
        |> String.Extra.dasherize


institutionTitle institution =
    String.join ""
        [ institution.name
        , " | "
        , toString institution.startYear
        , "-"
        , toString institution.endYear
        ]


courseTitle institution =
    String.join "" [ institution.course, " | ", institution.result ]


positionDivider =
    el [ center, paddingBottom 5 ] (text " ")


positionTitle position =
    String.join " // " <| [ position.title, position.company ]


positionMetaTitle position =
    String.join " " <|
        List.filterMap identity <|
            [ positionDateRange position
            , Just <| position.location
            ]


positionDateRange position =
    let
        start =
            List.map .start position.projects
                |> List.minimum
                |> Maybe.map toString

        end =
            List.map .end position.projects
                |> List.maximum
                |> Maybe.map toString
    in
        Maybe.map2 (\a b -> a ++ "–" ++ b) start end


projectHashTags project =
    project.stack
        |> List.map (codify)
        |> List.map (String.append "#")
        |> String.join (" ")


footerView model =
    row
        [ center
        , centerY
        , paddingEach { top = 7, bottom = 0, left = 0, right = 0 }
        , Font.size 12
        , Font.color (grey 100)
        , width <| shrink
        , spacing 25
        ]
        [ socialDetails Icon.envelope "oliver@opsb.co.uk"
        , socialDetails Icon.stackoverflow "opsb"
        , socialDetails Icon.twitter "ollysb"
        , socialDetails Icon.github "opsb"
        ]


socialDetails icon detail =
    row
        [ spacing 5, centerY ]
        [ icon iconSize
        , text detail
        ]


iconSize =
    16



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }



---- STYLES ----


tag name =
    attribute <| Html.Attributes.attribute "data-tag" name
