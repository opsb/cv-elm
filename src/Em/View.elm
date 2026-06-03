module Em.View exposing (view)

{-| Engineering Manager (player-coach) view at `/em`. Renders the shared
two-page executive layout in `Cv.View` against the EM-framed copy in
`Em.Data`, so it appears as A4 pages like the /cto and /cpo variants and
paginates to two sheets. All visual decisions live in the shared layer;
only the copy is local.

-}

import Browser
import Cv.View
import Em.Data as Data


view : Browser.Document msg
view =
    Cv.View.view Data.cv
