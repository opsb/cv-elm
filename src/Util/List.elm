module Util.List exposing (..)



splitInTwo : List a -> ( List a, List a )
splitInTwo list =
    let
        index =
            round (((toFloat <| List.length list) - 1) / toFloat 2)
    in
    ( List.take index list, List.drop index list )
