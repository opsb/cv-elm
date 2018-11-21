module Util.String exposing (AutolinkConfig, LinkOrText(..), autolink, autolinkHelp, linkOrText)

import Parser exposing (..)
import Util.Parser exposing (..)



---- AUTOLINK ----


type LinkOrText
    = Link String
    | Text String


type alias AutolinkConfig a =
    { mapText : String -> a
    , mapLink : String -> a
    }


autolink : AutolinkConfig a -> String -> Result String (List a)
autolink config text =
    text
        |> Parser.run linkOrText
        |> Result.map (List.map (autolinkHelp config))
        |> Result.mapError (\_ -> "Unable to autolink: " ++ text)


autolinkHelp : AutolinkConfig a -> LinkOrText -> a
autolinkHelp config item =
    case item of
        Link link_ ->
            config.mapLink link_

        Text text_ ->
            config.mapText text_


linkOrText : Parser (List LinkOrText)
linkOrText =
    let
        merge list text =
            case list of
                (Text constant) :: rest ->
                    Text (constant ++ text) :: rest

                _ ->
                    Text text :: list
    in
    loop [] <|
        \revList ->
            oneOf
                [ succeed (\parsed -> Loop <| Link parsed :: revList)
                    |= backtrackable link
                , succeed (merge revList >> Loop)
                    |= getChompedString (chomp 1)
                , succeed (Done <| List.reverse revList)
                ]
