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
                [ headerView model
                , mainColumns
                    { left =
                        [ introductionView model
                        , skillsView model
                        , openSourceView model
                        , educationView model
                        ]
                    , right =
                        [ experienceView model
                        ]
                    }
                , footerView model
                ]


mainColumns { left, right } =
    row [ paddingXY 0 20 ]
        [ column
            [ borderRight 2
            , Border.color colors.blue
            , paddingRight gutter
            ]
            left
        , column
            [ paddingLeft gutter ]
            right
        ]



-- HEADER


headerView model =
    column
        [ center, tag "headerView", width <| fill ]
        [ el
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
            (text model.data.name)
        , el
            [ center
            , padding 10
            , uppercase
            , Font.letterSpacing 2
            , Font.size 12
            ]
            (text model.data.tagline)
        ]



-- SECTIONS


introductionView model =
    column
        []
        [ sectionTitle [ alignRight, Font.color colors.black ] "Introduction"
        , column [] <| (List.map introSectionView model.data.introduction)
        ]


introSectionView : IntroSection -> El
introSectionView data =
    paragraph
        [ paddingEach { bottom = 10, top = 0, right = 0, left = 0 }
        , Font.size 12
        , Font.lineHeight 1.4
        , hyphenatedText
        , fonts.roboto
        , Font.justify
        , Font.weight 300
        , Font.letterSpacing 0.5
        ]
        [ text data.body ]


skillsView model =
    let
        ( columnA, columnB ) =
            splitInTwo model.data.skills
    in
        column
            [ paddingBottom 25 ]
            [ sectionTitle [ alignRight ] "Skills"
            , row
                [ spacing 15 ]
                [ column (List.append [] skillStyles) <| List.map skillView columnA
                , column (List.append [] skillStyles) <| List.map skillView columnB
                ]
            ]


skillStyles =
    [ Font.size skillsSize
    , Font.alignRight
    , skillsWeight
    , fonts.roboto
    ]


splitInTwo list =
    let
        index =
            round (((toFloat <| List.length list) - 1) / (toFloat 2))
    in
        List.Extra.splitAt index list


skillView skill =
    row
        [ paddingBottom 5, alignBottom, spaceEvenly, alignLeft ]
        [ el [] (text skill.name)
        , el [ Font.size skillsSize, skillsWeight, fonts.roboto ] <| text <| (toString skill.years) ++ " years"
        ]


codify text =
    text
        |> String.Extra.replace "/" ""
        |> String.Extra.underscored
        |> String.Extra.dasherize


educationView model =
    column
        []
        [ sectionTitle [ alignRight ] "Education"
        , column
            []
            (List.map institutionView model.data.education)
        ]


institutionView institution =
    column
        []
        [ el
            [ alignRight
            , paddingBottom 4
            , Font.size 10
            , uppercase
            , Font.weight 600
            , Font.letterSpacing 1
            ]
            (text
                (String.join ""
                    [ institution.name
                    , " | "
                    , toString institution.startYear
                    , "-"
                    , toString institution.endYear
                    ]
                )
            )
        , el
            [ alignRight
            , Font.size 12
            , Font.lineHeight 1.4
            , Font.justify
            , Font.weight 200
            , Font.letterSpacing 0.5
            , fonts.roboto
            ]
            (text (String.join "" [ institution.course, " | ", institution.result ]))
        ]


openSourceView model =
    column
        [ paddingBottom 20 ]
        [ sectionTitle [ alignRight ] "Open Source"
        , column [ spacing 15 ] <| List.map openSourceProjectView model.data.openSource
        ]


openSourceProjectView project =
    column
        [ alignRight ]
        [ el
            [ paddingBottom 1
            , Font.size 10
            , Font.letterSpacing 1
            , uppercase
            , Font.weight 600
            , alignRight
            ]
            (text <| project.name ++ "  |  " ++ (String.toLower project.shortInvolvement))
        , paragraph
            [ alignRight
            , Font.size 12
            , Font.lineHeight 1.5
            , Font.alignRight
            , Font.weight 200
            , fonts.roboto
            , Font.letterSpacing 0.5
            ]
            [ text project.overview ]
        ]


experienceView model =
    let
        ( full, simple ) =
            List.Extra.splitAt 4 model.data.experience
    in
        column
            []
            [ sectionTitle [ alignLeft ] "Experience"
            , column
                [ spacing 15 ]
                (List.concat
                    [ List.map
                        (positionView fullProjectView)
                        full
                    , List.map (positionView simpleProjectView) simple
                    ]
                )
            ]


positionDivider =
    el [ center, paddingBottom 5 ] (text " ")


positionView : (Project -> El) -> Position -> El
positionView func position =
    let
        positionTitle =
            String.join " // " <| [ position.title, position.company ]
    in
        column
            []
            [ el
                [ paddingBottom 3
                , Font.size 13
                , Font.weight 800
                , uppercase
                , Font.letterSpacing 1
                , alignLeft
                ]
                (text positionTitle)
            , row [ paddingBottom 10, spacing 5 ] <|
                List.filterMap identity
                    [ flip Maybe.map (positionDateRange position) <|
                        \dateRange ->
                            el
                                [ Font.size 10
                                , Font.color colors.lighterGrey
                                , Font.letterSpacing 1
                                , alignLeft
                                ]
                                (text dateRange)
                    , Just <|
                        el
                            [ Font.size 10
                            , Font.color colors.lighterGrey
                            , Font.letterSpacing 1
                            , alignLeft
                            ]
                            (text position.location)
                    ]
            , column [] (List.map func position.projects)
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


fullProjectView : Project -> El
fullProjectView project =
    let
        hashtags =
            project.stack
                |> List.map (codify)
                |> List.map (String.append "#")
                |> String.join (" ")
    in
        column
            [ paddingBottom 7 ]
            [ projectTitle project.name
            , bodyText <| project.overview ++ " " ++ hashtags
            ]


simpleProjectView : Project -> El
simpleProjectView project =
    column
        [ paddingBottom 5 ]
        [ projectTitle project.name
        , bodyText project.overview
        ]


projectTitle string =
    el
        [ paddingBottom 3
        , Font.size 10
        , uppercase
        , Font.weight 600
        , Font.letterSpacing 1
        , alignLeft
        ]
        (text <| String.join " // " [ string ])


listSingleton a =
    [ a ]


footerView model =
    el [] <|
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


h1Size =
    30


h3Size =
    16


h4Size =
    10


fonts =
    { roboto =
        Font.family [ Font.typeface "Roboto" ]
    , helvetica =
        Font.family [ Font.typeface "helvetica neue" ]
    }


skillsSize =
    12


skillsWeight =
    Font.weight 300


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


tag name =
    attribute <| Html.Attributes.attribute "data-tag" name
