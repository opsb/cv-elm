module Util.StringTest exposing (all)

import Expect
import Parser exposing (..)
import Regex
import Test exposing (..)
import Util.String exposing (autolink)

all : Test
all =
    describe "autolink"
        [ test "autolinks" <|
            \_ ->
                Expect.equal
                    (autolink
                        { mapText = \text_ -> "text:" ++ text_
                        , mapLink = \link_ -> "link:" ++ link_
                        }
                        "one two https://boom.io three"
                    )
                    (Ok [ "text:one two ", "link:https://boom.io", "text: three" ])
        ]
