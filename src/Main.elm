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
import Data exposing (..)
import List.Extra
import Styles
import String.Extra
import Icon


type alias El =
    Element Styles.Styles Styles.Variations Msg


type alias Attr =
    Element.Attribute Styles.Variations Msg



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
    Element.viewport Styles.stylesheet <|
        column Styles.Main
            []
            [ el Styles.Page [ padding 30, class "page", center ] <|
                column Styles.None
                    [ width <| fill, height <| fill ]
                    [ headerView model
                    , row Styles.None
                        [ paddingTop 20, width <| fill, height <| fill, paddingBottom 20 ]
                        [ column Styles.LeftColumn
                            [ width <| fill, paddingRight gutter, height <| fill ]
                            [ introductionView model
                            , skillsView model
                            , openSourceView model
                            , educationView model
                            ]
                        , column Styles.RightColumn
                            [ width <| fill, paddingLeft gutter, height <| fill ]
                            [ experienceView model
                            ]
                        ]
                    , footerView model
                    ]
            ]



-- BASE ELEMENTS


sectionTitle : List Attr -> String -> El
sectionTitle props title =
    el Styles.SectionTitle (List.append props [ paddingBottom 16 ]) (text title)



-- HEADER


headerView model =
    column Styles.None
        [ center ]
        [ el
            Styles.DeveloperTitle
            [ center, padding 20 ]
            (text model.data.name)
        , el
            Styles.Tagline
            [ center, padding 10 ]
            (text model.data.tagline)
        ]



-- SECTIONS


introductionView model =
    column Styles.None
        []
        [ sectionTitle [ alignRight ] "Introduction"
        , column Styles.None
            []
            (List.map introSectionView model.data.introduction)
        ]


introSectionView : IntroSection -> El
introSectionView data =
    paragraph Styles.BodyTextJustified [ paddingBottom 10 ] [ text data.body ]


skillsView model =
    let
        ( columnA, columnB ) =
            splitInTwo model.data.skills
    in
        column Styles.None
            [ paddingBottom 25 ]
            [ sectionTitle [ alignRight ] "Skills"
            , row Styles.None
                [ spacing 15 ]
                [ column Styles.Skill [ width <| percent 50 ] <| List.map skillView columnA
                , column Styles.Skill [ width <| percent 50 ] <| List.map skillView columnB
                ]
            ]


splitInTwo list =
    let
        index =
            round (((toFloat <| List.length list) - 1) / (toFloat 2))
    in
        List.Extra.splitAt index list


skillView skill =
    row Styles.None
        [ alignLeft, paddingBottom 5, spacing 5, alignBottom, spread ]
        [ text ((skill.name))
        , el Styles.SkillYears [] <| text <| (toString skill.years) ++ " years"
        ]


codify text =
    text
        |> String.Extra.replace "/" ""
        |> String.Extra.underscored
        |> String.Extra.dasherize


educationView model =
    column Styles.None
        []
        [ sectionTitle [ alignRight ] "Education"
        , column Styles.None
            []
            (List.map institutionView model.data.education)
        ]


institutionView institution =
    column Styles.None
        []
        [ el Styles.EducationInstitution
            [ alignRight
            , paddingBottom 4
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
        , el Styles.EducationCourse [ alignRight ] (text (String.join "" [ institution.course, " | ", institution.result ]))
        ]


openSourceView model =
    column Styles.None
        [ paddingBottom 20 ]
        [ sectionTitle [ alignRight ] "Open Source"
        , column Styles.None [ spacing 15 ] <| List.map openSourceProjectView model.data.openSource
        ]


openSourceProjectView project =
    column Styles.None
        [ alignRight ]
        [ el Styles.OpenSourceRepo [ paddingBottom 1 ] (text <| project.name ++ "  |  " ++ (String.toLower project.shortInvolvement))
        , paragraph Styles.OpenSourceText [ alignRight ] [ text project.overview ]
        ]


experienceView model =
    let
        ( full, simple ) =
            List.Extra.splitAt 4 model.data.experience
    in
        column Styles.None
            []
            [ sectionTitle [] "Experience"
            , column Styles.None
                [ spacing 15 ]
                (List.concat
                    [ List.map
                        (positionView fullProjectView)
                        full
                    , List.map (positionView simpleProjectView) simple
                    ]
                )
            ]


ellipsis props =
    el Styles.Ellipsis props (text "...")


positionDivider =
    el Styles.None [ center, paddingBottom 5 ] (text " ")


positionView : (Project -> El) -> Position -> El
positionView func position =
    let
        positionTitle =
            String.join " // " <| [ position.title, position.company ]
    in
        column Styles.None
            []
            [ el Styles.PositionTitle [ paddingBottom 3 ] (text positionTitle)
            , row Styles.None [ paddingBottom 10, spacing 5 ] <|
                List.filterMap identity
                    [ flip Maybe.map (positionDateRange position) <|
                        \dateRange ->
                            el Styles.PositionDateRange [] (text dateRange)
                    , Just <| el Styles.PositionLocation [] (text position.location)
                    ]
            , column Styles.None [] (List.map func position.projects)
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
        column Styles.None
            [ paddingBottom 7 ]
            [ el Styles.ProjectTitle [ paddingBottom 3 ] (text project.name)
            , paragraph Styles.BodyText [ paddingBottom 6 ] [ text <| project.overview ++ " " ++ hashtags ]
            ]


simpleProjectView : Project -> El
simpleProjectView project =
    column Styles.None
        [ paddingBottom 5 ]
        [ el Styles.ProjectTitle [ paddingBottom 3 ] (text <| String.join " // " [ project.name ])
        , paragraph Styles.BodyText [ paddingBottom 6 ] [ text <| project.overview ]
        ]


listSingleton a =
    [ a ]


footerView model =
    row Styles.Footer
        [ spacing 25, center, verticalCenter, paddingTop 7 ]
        [ socialDetails Icon.envelope "oliver@opsb.co.uk"
        , socialDetails Icon.stackoverflow "opsb"
        , socialDetails Icon.twitter "ollysb"
        , socialDetails Icon.github "opsb"
        ]


socialDetails icon detail =
    row Styles.None
        [ spacing 5, verticalCenter ]
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
