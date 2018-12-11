module Main exposing (main)

import Browser
import Data exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)


main =
    div []
        [ h1 [] [ text "Experience" ]
        , div [] (List.map positionView positions)
        ]


positions =
    List.map (\callback -> Data.experience |> callback)
        [ .twentyBn
        , .liqid
        , .zapnito
        , .lytbulb
        , .myschooldirect
        , .informa
        , .nutshellDevelopment
        ]


positionView : Position -> Html Never
positionView position =
    div [ class "position" ]
        [ h2 [ class "company name" ] [ text position.company ]
        , h2 [ class "dates" ] [ text position.dates ]
        , h2 [ class "job title" ] [ text position.title ]
        , div [ class "projects" ]
            (List.map projectView position.projects)
        ]


projectView : Project -> Html Never
projectView project =
    div [ class "project" ]
        [ h3 [] [ text project.name ]
        , p [] [ text project.overview ]
        ]
