module Cto.View exposing (view)

{-| CTO / Engineering & Technology Executive variant. Renders the
shared two-page CV layout in `Cv.View` against the CTO-framed copy
in `Cto.Data`. All visual decisions live in the shared layer; only
the copy is local.

-}

import Browser
import Cto.Data as Data
import Cv.View


view : Browser.Document msg
view =
    Cv.View.view Data.cv
