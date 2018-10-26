module Main exposing (Model, Msg(..), init, main, openSourceProject, overviewName, overviewPage, overviewTagline, tableOfContentsLine, update, view)

import Browser
import Data exposing (..)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Html exposing (Html)
import Html.Attributes exposing (src)
import View.Atom as Atom
import View.Colors as Colors
import View.Icon as Icon
import View.TimelineBars as TimelineBars



---- MODEL ----


type alias Model =
    {}


init : ( Model, Cmd Msg )
init =
    ( {}, Cmd.none )



---- UPDATE ----


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    layout [ Atom.bodyTextFont ] <|
        column [ width fill ]
            [ overviewPage
            , experiencePage
            ]


overviewPage : Element msg
overviewPage =
    Atom.a4Page [] <|
        row
            [ width fill, height fill ]
            [ personalDetailsSection
            , Atom.pageColumn [ spacing 50 ]
                [ introductionSection
                , communitySection
                , educationSection
                ]
            , Atom.verticalDivider
            , Atom.pageColumn [ spacing 50 ]
                [ skillsSection
                , openSourceSection
                ]
            ]


personalDetailsSection : Element msg
personalDetailsSection =
    Atom.pageColumn [ spacing 40, Background.color Colors.grey ]
        [ column [ height (fillPortion 1) ]
            [ column [ alignBottom, moveUp 100, spacing 10 ] [ overviewName, overviewTagline ]
            ]
        , column [ height (fillPortion 1) ]
            [ contactDetails
            ]
        ]


introductionSection : Element msg
introductionSection =
    Atom.section []
        [ Atom.title1 [] "Introduction"
        , Atom.paragraph [] "Building software that people actually like to use is what gets me going. With 14 years experience I've delivered successful products for the Telecoms, Retail, Publishing, Energy and Charity sectors. I've led teams to build a wide variety of projects including realtime social platforms and project management tools, business Intelligence, custom content management systems, online stores and browser extensions."
        , Atom.paragraph [] "From day one I've been an agile practitioner, whether it's Scrum or Kanban, Lean, BDD, outside-in, pair-programming, you name it, I've been doing it for years. I've usually led from the front but I’m comfortable working in many different styles and value project consistency over personal preferences so am equally comfortable working alone or slotting into an existing team."
        ]


openSourceSection : Element msg
openSourceSection =
    Atom.section []
        [ Atom.title1 [] "Open Source"
        , column [ spacing 20, width fill ] (List.map openSourceProject Data.openSourceProjects)
        ]


skillsSection : Element msg
skillsSection =
    Atom.section []
        [ Atom.title1 [] "Skills"
        , let
            ( leftSkills, rightSkills ) =
                splitInTwo Data.skills
          in
          row [ spacing 30, width fill ]
            [ skillsColumn leftSkills
            , skillsColumn rightSkills
            ]
        ]


communitySection : Element msg
communitySection =
    Atom.section []
        [ Atom.title1 [] "Community"
        , Atom.paragraph [] "I love to meet other developers and hear what they’re getting up to. In Barcelona I’m a regular at the Elixir meetup and run the Elm hack night. I’m also regularly in London and Berlin so I make sure to pop into the local Elixir and Elm meetups there."
        , Atom.paragraph [] "Online you’ll regularly find me in the Elixir and Elm slacks. I’ve found both communities to be really friendly and helpful."
        ]


educationSection : Element msg
educationSection =
    Atom.section []
        [ Atom.title1 [] "Education"
        , column [ spacing 5, width fill ]
            [ row [ width fill ]
                [ el [ alignLeft ] (Atom.title3 [] "Sussex University")
                , el [ alignRight ] (Atom.title3 [] "2001-2004")
                ]
            , row [ width fill ]
                [ el [ alignLeft ] (Atom.bodyText [] "Artificial Intelligence")
                , el [ alignRight ] (Atom.bodyText [] "2/1")
                ]
            ]
        ]


experiencePage : Element msg
experiencePage =
    Atom.a4Page [] <|
        column [ width fill, height fill ]
            [ el
                [ width fill
                , paddingXY 20 10
                , Background.color Colors.grey
                ]
                (Atom.title1
                    [ Font.color Colors.white
                    , paddingEach { top = 5, right = 0, bottom = 0, left = 0 }
                    ]
                    "Experience"
                )
            , row [ width fill, height fill ]
                [ Atom.pageColumn []
                    [ positionView (Data.experience |> .twentyBn)
                    , positionView (Data.experience |> .liqid)
                    , positionView (Data.experience |> .zapnito)
                    ]
                , Atom.verticalDivider
                , Atom.pageColumn []
                    [ positionView (Data.experience |> .lytbulb)
                    , positionView (Data.experience |> .myschooldirect)
                    ]
                , Atom.verticalDivider
                , Atom.pageColumn []
                    [ positionView (Data.experience |> .informa)
                    , positionView (Data.experience |> .nutshellDevelopment)
                    ]
                ]
            ]


contactDetails : Element msg
contactDetails =
    column [ alignBottom, Font.color Colors.white, spacing 10, Font.size 14, Font.light, Atom.letterSpacing 1 ]
        [ row [ spacing 10 ] [ el [] (Icon.github 20), el [] (text "opsb") ]
        , row [ spacing 10 ] [ el [] (Icon.stackoverflow 20), el [] (text "opsb") ]
        , row [ spacing 10 ] [ el [] (Icon.twitter 20), el [] (text "ollysb") ]
        , row [ spacing 10 ] [ el [] (Icon.envelope 20), el [] (text "oliver@opsb.co.uk") ]
        ]


positionView : Position -> Element msg
positionView position =
    column [ spacing 15, width fill ]
        [ column [ spacing 3, width fill ]
            [ row [ width fill ]
                [ el [ alignLeft ] (Atom.title2 [] position.company)
                , el [ alignRight ] (Atom.title3 [ Font.italic ] <| position.dates)
                ]
            , row [ width fill ]
                [ el [ alignLeft ] (Atom.title4 [] position.title)
                , el [ alignRight ] (Atom.title4 [] position.location)
                ]
            ]
        , column [ spacing 15 ] (List.map projectView position.projects)
        ]


projectView : Project -> Element msg
projectView project =
    column [ spacing 5 ]
        [ Atom.title3 [] project.name
        , Atom.paragraph [] project.overview
        , hashTags project.stack
        ]


hashTags : List String -> Element msg
hashTags tags =
    let
        formatted =
            tags
                |> List.map (String.append "")
                |> String.join ",  "
    in
    paragraph
        [ Font.size 12
        , Font.semiBold
        , Font.color Colors.grey
        , Atom.titleFont
        , Atom.letterSpacing 0.4
        , Font.alignLeft
        ]
        [ text formatted ]


bullets : List String -> Element msg
bullets items =
    column [ spacing 15 ] <|
        List.map
            (\item ->
                row [ spacing 3 ]
                    [ Atom.bodyText [ alignTop ] "•"
                    , Atom.paragraph [ Font.size 11, Atom.lineHeight 14 ] item
                    ]
            )
            items


positionDateRange : Position -> String
positionDateRange position =
    let
        start =
            List.map .start position.projects
                |> List.minimum
                |> Maybe.map String.fromInt

        end =
            List.map .end position.projects
                |> List.maximum
                |> Maybe.map String.fromInt
    in
    Maybe.map2 (\a b -> a ++ "–" ++ b) start end
        |> Maybe.withDefault ""


skillsColumn : List Skill -> Element msg
skillsColumn skills =
    column
        [ width (fillPortion 1)
        , spacing 1
        , above <|
            el
                [ alignRight
                , Font.size 10
                , Font.color Colors.grey
                , Font.italic
                , moveRight 2
                ]
                (text "years")
        ]
    <|
        List.map
            (\{ name, years } -> tableOfContentsLine name (String.fromFloat years))
            skills


tableOfContentsLine : String -> String -> Element msg
tableOfContentsLine leftText rightText =
    row [ width fill ]
        [ el
            [ Font.color
                Colors.grey
            , paddingEach { bottom = 0, left = 0, top = 0, right = 5 }
            ]
            (Atom.title4 [] leftText)
        , el
            [ width fill
            , Border.dotted
            , Border.color Colors.lightGrey
            , Border.widthEach { bottom = 1, left = 0, top = 0, right = 0 }
            , moveUp 7
            , Font.color Colors.lightGrey
            ]
            (text " ")
        , el
            [ Font.color Colors.grey
            , Font.italic
            , Font.bold
            , paddingEach { bottom = 0, left = 5, top = 0, right = 0 }
            ]
            (Atom.title4 [] rightText)
        ]


splitInTwo : List a -> ( List a, List a )
splitInTwo list =
    let
        index =
            round (((toFloat <| List.length list) - 1) / toFloat 2)
    in
    ( List.take index list, List.drop index list )


openSourceProject : OpenSourceProject -> Element msg
openSourceProject project =
    column [ spacing 5, width fill ]
        [ row [ width fill ]
            [ el [ alignLeft ] (Atom.title3 [] project.name)
            , el [ alignRight ] (Atom.title3 [] project.shortInvolvement)
            ]
        , Atom.paragraph [] project.overview
        ]


overviewName =
    column
        [ Font.color Colors.white
        , Font.size 40
        , Atom.titleFont
        , Font.bold
        , Atom.letterSpacing 1
        ]
        [ text "Oliver", text "Searle-Barnes" ]


overviewTagline =
    el
        [ Font.color Colors.white
        , Font.light
        ]
        (text "Passionate full-stack tech leader")



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
