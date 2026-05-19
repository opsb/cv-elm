module Cpo.View exposing (view)

{-| CPO / Product & Technology Executive variant. Renders the
shared two-page CV layout in `Cv.View` against the CPO-framed copy
in `Cpo.Data`. All visual decisions (fonts, colours, page geometry,
section ordering, pagination split) live in the shared layer; only
the copy is local.

-}

import Browser
import Cpo.Data as Data
import Cv.View


view : Browser.Document msg
view =
    Cv.View.view Data.cv
