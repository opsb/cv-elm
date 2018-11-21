module Util.Parser exposing (chomp, link, protocol, string, word)

import Parser exposing (..)


chomp : Int -> Parser ()
chomp n =
    if n <= 1 then
        chompIf (\_ -> True)

    else
        chompIf (\_ -> True) |. chomp (n - 1)


link : Parser String
link =
    succeed (\a b -> a ++ b)
        |= protocol
        |= word


word : Parser String
word =
    getChompedString <|
        succeed ()
            |. chompIf (\c -> c /= ' ')
            |. chompWhile (\c -> c /= ' ')


protocol : Parser String
protocol =
    Parser.oneOf
        [ string "http://"
        , string "https://"
        ]


string : String -> Parser String
string text =
    succeed (\_ -> text)
        |= symbol text
