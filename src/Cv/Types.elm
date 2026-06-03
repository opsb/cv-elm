module Cv.Types exposing
    ( CvData
    , Institution
    , Position
    , Project
    )

{-| Shared type definitions for the two-page executive-CV variants
that render via `Cv.View` (Cpo, Cto, and any future siblings). Each
variant's `Data` module assembles a `CvData` record from these
building blocks; the View module never names variant-specific copy.

-}


type alias Position =
    { title : String
    , location : String
    , company : String
    , dates : String
    , scope : String
    , stack : List String
    , overview : Maybe String
    , projects : List Project
    }


type alias Project =
    { name : String
    , dates : String
    , overview : String
    , talkingPoints : List String
    }


type alias Institution =
    { name : String
    , course : String
    , result : String
    , dates : String
    }


{-| Everything `Cv.View` needs to render a complete two-page CV. The
positions are split structurally because the layout treats them
asymmetrically: the leading position and Thoughtclay each get
bespoke handling on page 1 / across the page break, then
`otherPositions` flows linearly on page 2 before Education.
-}
type alias CvData =
    { pdfFileName : String
    , name : String
    , tagline : String
    , email : String
    , profileTitle : String
    , executiveProfile : List String
    , coreCapabilities : List String
    , technicalSkills : String
    , leadingPosition : Position
    , secondPosition : Maybe Position
    , thoughtclay : Position
    , otherPositions : List Position
    , education : List Institution
    }
