module Styles exposing (..)

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


type Styles
    = Main
    | Page
    | DeveloperTitle
    | IntroTitle
    | Tagline
    | SectionTitle
    | BodyText
    | BodyTextJustified
    | LeftColumn
    | RightColumn
    | PositionTitle
    | PositionDateRange
    | PositionLocation
    | ProjectTitle
    | Skill
    | SkillYears
    | SkillYearsLabel
    | Footer
    | StackText
    | OpenSourceTitle
    | OpenSourceRepo
    | OpenSourceText
    | OpenSourceInvolvement
    | EducationInstitution
    | EducationCourse
    | Ellipsis
    | None


type Variations
    = Active


stylesheet =
    Style.styleSheet
        [ Style.style DeveloperTitle
            [ Color.text colors.black
            , Font.size h1Size
            , Color.border colors.blue
            , Border.all 2
            , Font.uppercase
            , Font.weight 600
            , Font.letterSpacing 4
            ]
        , Style.style Main
            [ fonts.helvetica
            , Color.background colors.lightGrey
            ]
        , Style.style Page
            [ prop "width" "210mm"
            , prop "height" "296mm"
            , Color.background colors.white
            ]
        , Style.style Tagline
            [ Font.uppercase
            , Font.letterSpacing 2
            , Font.size 12
            ]
        , Style.style IntroTitle
            [ Font.italic, Font.size 12 ]
        , Style.style SectionTitle
            [ Font.uppercase
            , Font.size h2Size
            , Font.weight 600
            , Font.letterSpacing 2
            ]
        , Style.style BodyText
            [ Font.size 12
            , Font.lineHeight 1.4
            , fonts.roboto
            , Font.weight 300
            , Font.letterSpacing 0.5
            ]
        , Style.style BodyTextJustified
            [ Font.size 12
            , Font.lineHeight 1.4
            , prop "hyphens" "auto"
            , fonts.roboto
            , Font.justify
            , Font.weight 300
            , Font.letterSpacing 0.5
            ]
        , Style.style OpenSourceText
            [ Font.size 12
            , Font.lineHeight 1.5
            , Font.alignRight
            , Font.weight 200
            , fonts.roboto
            , Font.letterSpacing 0.5
            ]
        , Style.style None
            []
        , Style.style LeftColumn
            [ Border.right 2, Color.border colors.blue ]
        , Style.style RightColumn
            []
        , Style.style PositionTitle
            [ Font.size 13
            , Font.weight 800
            , Font.uppercase
            , Font.letterSpacing 1
            ]
        , Style.style ProjectTitle
            [ Font.size 10
            , Font.uppercase
            , Font.weight 600
            , Font.letterSpacing 1
            ]
        , Style.style StackText
            [ Font.italic
            , Font.size 10
            , Font.weight 400
            , Font.letterSpacing 1
            ]
        , Style.style OpenSourceTitle
            [ Font.size 13, Font.uppercase ]
        , Style.style OpenSourceRepo
            [ Font.size 10
            , Font.letterSpacing 1
            , Font.uppercase
            , Font.weight 600
            ]
        , Style.style OpenSourceInvolvement
            [ Font.size 10
            , Font.italic
            , Font.uppercase
            ]
        , Style.style Skill
            [ Font.size skillsSize
            , Font.alignRight
            , skillsWeight
            , fonts.roboto
            ]
        , Style.style SkillYears
            [ Font.size skillsSize
            , skillsWeight
            , fonts.roboto
            ]
        , Style.style SkillYearsLabel
            [ Font.size skillsSize
            , Color.text <| Color.rgba 100 100 100 1
            , skillsWeight
            , fonts.roboto
            ]
        , Style.style PositionDateRange
            [ Font.size 10
            , Color.text colors.lighterGrey
            , Font.letterSpacing 1
            ]
        , Style.style PositionLocation
            [ Font.size 10
            , Color.text colors.lighterGrey
            , Font.letterSpacing 1
            ]
        , Style.style EducationInstitution
            [ Font.size 10
            , Font.uppercase
            , Font.weight 600
            , Font.letterSpacing 1
            ]
        , Style.style EducationCourse
            [ Font.size 12
            , Font.lineHeight 1.4
            , Font.justify
            , Font.weight 200
            , Font.letterSpacing 0.5
            , fonts.roboto
            ]
        , Style.style Ellipsis
            [ Font.letterSpacing 3
            ]
        , Style.style Footer
            [ Font.size 12
            , Color.text (grey 100)
            ]
        ]


h1Size =
    30


h2Size =
    20


h3Size =
    16


h4Size =
    10


fonts =
    { roboto =
        Font.typeface [ Font.font "Roboto" ]
    , helvetica =
        Font.typeface [ Font.font "helvetica neue" ]
    }


skillsSize =
    12


skillsWeight =
    Font.weight 300


colors =
    { white = Color.white
    , darkGrey = Color.grey
    , black = Color.black
    , lightGrey = Color.rgba 244 244 244 1
    , lighterGrey = Color.rgba 140 140 140 1
    , blue = Color.rgba 148 196 252 100
    }


grey level =
    Color.rgba level level level 1
