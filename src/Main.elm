module Main exposing (main)

import Browser
import Browser.Events exposing (onResize)
import Data exposing (..)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events exposing (onClick)
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)
import Html.Attributes exposing (src)
import Util.List exposing (splitInTwo)
import View.Atom as Atom exposing (..)
import View.Colors as Colors
import View.Icon as Icon



---- MODEL ----


type alias Flags =
    { width : Int
    , height : Int
    }


type alias Model =
    { device : Device
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { device = Element.classifyDevice flags
      }
    , Cmd.none
    )



---- UPDATE ----


type Msg
    = DeviceClassified Device


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DeviceClassified device ->
            ( { model | device = device }
            , Cmd.none
            )



---- SUBSCRIPTIONS ----


subscriptions : Model -> Sub Msg
subscriptions model =
    onResize <|
        \width height ->
            DeviceClassified (Element.classifyDevice { width = width, height = height })



---- VIEW ----


view : Model -> Browser.Document Msg
view model =
    { title = "Oliver Searle-Barnes"
    , body = deviceBody model
    }


deviceBody : Model -> List (Html Msg)
deviceBody model =
    case model.device.class of
        Phone ->
            mobileLayout

        _ ->
            a4PagesLayout



---- MOBILE LAYOUT ----


mobileLayout : List (Html Msg)
mobileLayout =
    [ layout [ Atom.bodyTextFont ]
        (column [ width fill, spacing 20 ]
            [ mobilePersonalDetailsSection
            , mobileSection "Introduction" introductionSection
            , Atom.horizontalDivider
            , mobileSection "Skills" skillsSection
            , Atom.horizontalDivider
            , mobileSection "Open Source" openSourceSection
            , Atom.horizontalDivider
            , mobileSection "Experience" <|
                column [ spacing 80 ]
                    [ mobilePositionView (Data.experience |> .twentyBn)
                    , mobilePositionView (Data.experience |> .liqid)
                    , mobilePositionView (Data.experience |> .zapnito)
                    , mobilePositionView (Data.experience |> .lytbulb)
                    , mobilePositionView (Data.experience |> .myschooldirect)
                    , mobilePositionView (Data.experience |> .informa)
                    , mobilePositionView (Data.experience |> .nutshellDevelopment)
                    ]
            , Atom.horizontalDivider
            , mobileSection "Community" communitySection
            , Atom.horizontalDivider
            , mobileSection "Education" educationSection
            ]
        )
    ]


mobileSection : String -> Element Msg -> Element Msg
mobileSection title body =
    column [ padding 20, spacing 40, width fill ] [ Atom.title1 [] title, body ]


mobilePersonalDetailsSection : Element Msg
mobilePersonalDetailsSection =
    Atom.pageColumn [ spacing 40, Background.color Colors.grey, Font.color Colors.white ]
        [ column [ height (fillPortion 1) ]
            [ column [ alignBottom, spacing 10 ] [ overviewName, overviewTagline ]
            ]
        , column [ height (fillPortion 1) ]
            [ contentDetails
            , contactDetails
            ]
        ]



---- A4 PAGES LAYOUT ----


a4PagesLayout : List (Html Msg)
a4PagesLayout =
    [ layout
        [ Atom.bodyTextFont
        , inFront
            (el
                [ alignRight
                , alignBottom
                , moveUp 10
                , moveLeft 10
                , htmlAttribute <| Html.Attributes.attribute "data-print" "false"
                ]
                downloadButton
            )
        ]
        (column
            [ width fill
            ]
            [ overviewPage
            , experiencePage
            ]
        )
    ]


downloadButton : Element Msg
downloadButton =
    link
        [ paddingXY 20 10
        , mouseOver []
        , Border.solid
        , Border.width 1
        , Border.rounded 5
        , Background.color Colors.green
        , Font.color Colors.white
        , Font.size 16
        , pointer
        , htmlAttribute <| Html.Attributes.attribute "download" "opsb.pdf"
        ]
        { url = "%PUBLIC_URL%/opsb.pdf", label = text "Download PDF" }


overviewPage : Element Msg
overviewPage =
    Atom.a4Page [] <|
        row
            [ width fill, height fill ]
            [ pagePersonalDetailsSection
            , Atom.pageColumn [ spacing 50 ]
                [ pageSection "Introduction" introductionSection
                , pageSection "Skills" skillsSection
                ]
            , Atom.verticalDivider
            , Atom.pageColumn [ spacing 50 ]
                [ pageSection "Open Source" openSourceSection
                , pageSection "Community" communitySection
                , pageSection "Education" educationSection
                ]
            ]


pageSection : String -> Element msg -> Element msg
pageSection title body =
    Atom.section []
        [ Atom.title1 [] title
        , body
        ]


pagePersonalDetailsSection : Element msg
pagePersonalDetailsSection =
    Atom.pageColumn [ spacing 40, Background.color Colors.grey, Font.color Colors.white ]
        [ column [ height (fillPortion 10), spacing 10 ]
            [ column [ alignBottom, moveUp 100, spacing 10 ]
                [ overviewName
                , column [ spacing 10, paddingXY 0 10 ]
                    [ el [ Font.light, Font.size 16 ] (text "Passionate full stack leader")
                    , el [ Font.light, Font.size 16 ] (text "Founder, CTO, VP Engineering, Architect")
                    , el [ Font.light, Font.size 16 ] (text "14 Years experience")
                    ]
                , contentDetails
                ]
            ]
        , column [ height (fillPortion 1), spacing 80 ]
            [ contactDetails
            ]
        ]


overviewTagline : Element msg
overviewTagline =
    el
        [ Font.color Colors.white
        , Font.light
        ]
        (text "Passionate full-stack tech leader")


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
                [ Atom.pageColumn [ spacing 25 ]
                    [ positionView (Data.experience |> .ctm)
                    , positionView (Data.experience |> .twentyBn)
                    , positionView (Data.experience |> .liqid)
                    , positionView (Data.experience |> .zapnito)
                    , positionView (Data.experience |> .lytbulb)
                    ]
                , Atom.verticalDivider
                , Atom.pageColumn []
                    [ positionView (Data.experience |> .myschooldirect)
                    , positionView (Data.experience |> .informa)
                    , positionView (Data.experience |> .nutshellDevelopment)
                    ]
                ]
            ]



---- SECTIONS ----


introductionSection : Element msg
introductionSection =
    column [ spacing 15 ]
        [ Atom.paragraph [] [ text "Building software that people actually like to use is what gets me going. With 14 years experience I've delivered successful products for the Telecoms, Retail, Publishing, Energy and Charity sectors. I've led teams to build a wide variety of projects including realtime social platforms and project management tools, business Intelligence, custom content management systems, online stores and browser extensions." ]
        , Atom.paragraph [] [ text "From day one I've been an agile practitioner, whether it's Scrum or Kanban, Lean, BDD, outside-in, pair-programming, you name it, I've been doing it for years. I've usually led from the front but I’m comfortable working in many different styles and value project consistency over personal preferences so am equally comfortable working alone or slotting into an existing team." ]
        ]


openSourceSection : Element msg
openSourceSection =
    column [ spacing 20, width fill ] (List.map openSourceProject Data.openSourceProjects)


skillsSection : Element msg
skillsSection =
    let
        ( leftSkills, rightSkills ) =
            splitInTwo Data.skills
    in
    row [ spacing 30, width fill ]
        [ skillsColumn leftSkills
        , skillsColumn rightSkills
        ]


communitySection : Element msg
communitySection =
    column [ spacing 15 ]
        [ Atom.paragraph [] [ text "I love to meet other developers and hear what they’re getting up to. In Barcelona I’m a regular at the Elixir meetup and run the Elm hack night. I’m also regularly in London and Berlin so I make sure to pop into the local Elixir and Elm meetups there." ]
        , Atom.paragraph [] [ text "Online you’ll regularly find me in the Elixir and Elm slacks. I’ve found both communities to be really friendly and helpful." ]
        ]


educationSection : Element msg
educationSection =
    column [ width fill ] (List.map institution Data.education)


institution : Institution -> Element msg
institution institution_ =
    newTabLink [ width fill ]
        { url = institution_.link
        , label =
            column [ spacing 5, width fill ]
                [ row [ width fill ]
                    [ el [ alignLeft ] (Atom.title3 [] institution_.course)
                    , el [ alignRight ] (Atom.title3 [] institution_.result)
                    ]
                , row [ width fill ]
                    [ el [ alignLeft ] (Atom.bodyText [] institution_.name)
                    , let
                        formattedDate =
                            [ institution_.startYear, institution_.endYear ]
                                |> List.map String.fromInt
                                |> String.join "-"
                      in
                      el [ alignRight ] (Atom.bodyText [] formattedDate)
                    ]
                ]
        }


contentDetails : Element msg
contentDetails =
    column
        [ paddingXY 0 80
        , alignBottom
        , Font.color Colors.white
        , spacing 10
        , Font.size 14
        , Font.light
        , Atom.letterSpacing 1
        ]
        [ row [ spacing 10 ] [ el [] (Icon.youtube 20), newTabLink [] { label = text "FnCasts - watch me code on youtube", url = "https://www.youtube.com/channel/UCEVIBi0jFVXrCvd7CdVYxvw" } ]
        , row [ spacing 10 ] [ el [] (Icon.github 20), newTabLink [] { label = text "opsb - 200+ repos", url = "https://github.com/opsb" } ]
        , row [ spacing 10 ] [ el [] (Icon.slack 20), el [] (text "opsb - 14 communities") ]
        , row [ spacing 10 ] [ el [] (Icon.stackoverflow 20), newTabLink [] { label = text "opsb - top 2%", url = "https://stackoverflow.com/users/162337/opsb" } ]
        ]


contactDetails : Element msg
contactDetails =
    column [ alignBottom, Font.color Colors.white, spacing 10, Font.size 14, Font.light, Atom.letterSpacing 1 ]
        [ row [ spacing 10 ] [ el [] (Icon.twitter 20), newTabLink [] { label = text "ollysb", url = "https://twitter.com/ollysb" } ]
        , row [ spacing 10 ] [ el [] (Icon.envelope 20), link [] { label = text "oliver@opsb.co.uk", url = "mailto:oliver@opsb.co.uk" } ]
        ]


mobilePositionView : Position -> Element msg
mobilePositionView position =
    column
        [ spacing 45
        , width fill
        , paddingEach { top = 0, right = 0, bottom = 5, left = 0 }
        ]
        [ column [ spacing 40, width fill ]
            [ column [ width fill, spacing 30 ]
                [ column [ width (fillPortion 11), spacing 5, alignTop ]
                    [ el [ alignLeft ]
                        (Atom.title2 [] position.company)
                    , el [ alignLeft ] (Atom.title3 [ Font.color Colors.red ] <| position.title)
                    , el [ alignLeft ] (Atom.bodyText [] position.dates)
                    , el [ alignLeft ] (Atom.bodyText [] position.location)
                    ]
                , row [ spacing 20, width (fillPortion 20), alignTop ]
                    [ column [ spacing 15, width (fillPortion 20) ] (List.map projectView position.projects)
                    ]
                ]
            ]
        ]


positionView : Position -> Element msg
positionView position =
    row [ width fill, spacing 0 ]
        [ column [ width (fillPortion 7), spacing 5, alignTop ]
            [ Atom.title3 [ Font.size 16, paddingEach { top = 0, right = 0, bottom = 5, left = 0 } ] position.company
            , Atom.title5 [ Font.size 12, Font.color Colors.red ] <| position.title
            , Atom.bodyText [Font.size 10] position.dates
            , Atom.bodyText [Font.size 10] position.location
            ]
        , column [ spacing 15, width (fillPortion 20) ]
            (List.map projectView position.projects)
        ]


projectView : Project -> Element msg
projectView project =
    column [ spacing 5 ]
        [ Atom.title3 [ Font.size 14, Font.medium, paddingEach { top = 0, right = 0, bottom = 2, left = 0 }, centerY ] project.name
        , Atom.paragraph [ Font.size 12 ] [ text <| projectSummary <| project ]
        , hashTags project.stack
        ]


projectSummary : Project -> String
projectSummary project =
    project.overview


hashTags : List String -> Element msg
hashTags tags =
    let
        formatted =
            tags
                |> List.map (String.append "")
                |> String.join ",  "
    in
    Atom.paragraph
        [ Font.size 9
        , Font.color Colors.grey

        --, Font.italic
        --, Atom.titleFont
        , Font.alignLeft
        , Font.medium
        , Font.family []
        ]
        [ text formatted ]


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
                , moveRight 2
                ]
                (text "years")
        ]
    <|
        List.map
            (\{ name, years } -> Atom.tableOfContentsLine name (String.fromFloat years))
            skills


openSourceProject : OpenSourceProject -> Element msg
openSourceProject project =
    column [ spacing 5, width fill ]
        [ newTabLink [ width fill ]
            { url = project.repo
            , label =
                row [ width fill ]
                    [ el [ alignLeft ] (Atom.title4 [Font.size 14, Font.medium] project.name)
                    ]
            }
        , Atom.autolink project.overview
        ]


overviewName : Element msg
overviewName =
    column
        [ Font.color Colors.white
        , Font.size 40
        , Atom.titleFont
        , Font.bold
        , Atom.letterSpacing 1
        ]
        [ text "Oliver", text "Searle-Barnes" ]



---- PROGRAM ----


main : Program Flags Model Msg
main =
    Browser.document
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
