module Main exposing (main)

import Browser
import Browser.Events exposing (onResize)
import Browser.Navigation as Nav
import Data exposing (..)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events exposing (onClick)
import Element.Font as Font
import Html exposing (Html)
import Html.Attributes exposing (src)
import Url exposing (Url)
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
    , variant : Variant
    , key : Nav.Key
    }


init : Flags -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( { device = Element.classifyDevice flags
      , variant = Data.variantFromPath url.path
      , key = key
      }
    , Cmd.none
    )



---- UPDATE ----


type Msg
    = DeviceClassified Device
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DeviceClassified device ->
            ( { model | device = device }
            , Cmd.none
            )

        LinkClicked (Browser.Internal url) ->
            ( model, Nav.pushUrl model.key (Url.toString url) )

        LinkClicked (Browser.External href) ->
            ( model, Nav.load href )

        UrlChanged url ->
            ( { model | variant = Data.variantFromPath url.path }
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
            mobileLayout model.variant

        _ ->
            a4PagesLayout model.variant



---- MOBILE LAYOUT ----


mobileLayout : Variant -> List (Html Msg)
mobileLayout variant =
    [ layout [ Atom.bodyTextFont ]
        (column [ width fill, spacing 20 ]
            [ mobilePersonalDetailsSection variant
            , mobileSection "Introduction" introductionSection
            , Atom.horizontalDivider
            , mobileSection "Skills" (skillsSection variant)
            , Atom.horizontalDivider
            , mobileSection "Open Source" openSourceSection
            , Atom.horizontalDivider
            , mobileSection "Experience" <|
                column [ spacing 80 ]
                    (Data.experiencePositionsFor variant
                        |> List.map (mobilePositionView variant)
                    )
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


mobilePersonalDetailsSection : Variant -> Element Msg
mobilePersonalDetailsSection variant =
    Atom.pageColumn [ spacing 40, Background.color Colors.grey, Font.color Colors.white ]
        [ column [ height (fillPortion 1) ]
            [ column [ alignBottom, spacing 10 ] [ overviewName, overviewTagline variant ]
            ]
        , column [ height (fillPortion 1) ]
            [ contentDetails
            , contactDetails
            ]
        ]



---- A4 PAGES LAYOUT ----


a4PagesLayout : Variant -> List (Html Msg)
a4PagesLayout variant =
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
                (downloadButton variant)
            )
        ]
        (column
            [ width fill
            ]
            [ overviewPage variant
            , experiencePage variant
            ]
        )
    ]


downloadButton : Variant -> Element Msg
downloadButton variant =
    let
        file =
            Data.pdfFileFor variant
    in
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
        , htmlAttribute <| Html.Attributes.attribute "download" file
        ]
        { url = "./" ++ file, label = text "Download PDF" }


overviewPage : Variant -> Element Msg
overviewPage variant =
    Atom.a4Page [] <|
        row
            [ width fill, height fill ]
            [ pagePersonalDetailsSection variant
            , Atom.pageColumn [ spacing 25 ]
                [ pageSection "Introduction" introductionSection
                , pageSection "Skills" (skillsSection variant)
                ]
            , Atom.verticalDivider
            , Atom.pageColumn [ spacing 35 ]
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


pagePersonalDetailsSection : Variant -> Element msg
pagePersonalDetailsSection variant =
    Atom.pageColumn [ spacing 40, Background.color Colors.grey, Font.color Colors.white ]
        [ column [ height (fillPortion 10), spacing 10 ]
            [ column [ alignBottom, moveUp 100, spacing 10 ]
                [ overviewName
                , column [ spacing 10, paddingXY 0 10 ]
                    (Data.sidePanelLabels variant
                        |> List.map (\label -> el [ Font.light, Font.size 16 ] (text label))
                    )
                , contentDetails
                ]
            ]
        , column [ height (fillPortion 1), spacing 80 ]
            [ contactDetails
            ]
        ]


overviewTagline : Variant -> Element msg
overviewTagline variant =
    el
        [ Font.color Colors.white
        , Font.light
        ]
        (text (Data.taglineFor variant))


experiencePage : Variant -> Element msg
experiencePage variant =
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
            , let
                columns =
                    Data.experienceColumnsFor variant
              in
              row [ width fill, height fill ]
                [ Atom.pageColumn []
                    (List.map (positionView variant) columns.left)
                , Atom.verticalDivider
                , Atom.pageColumn []
                    (List.map (positionView variant) columns.right)
                ]
            ]



---- SECTIONS ----


introductionSection : Element msg
introductionSection =
    column [ spacing 15 ]
        [ Atom.paragraph [] [ text "Building software that people actually love to use is what gets me going. With 22 years experience I've delivered successful products for the AI, Fintech, SaaS, Telecoms, Retail, Publishing, Energy, Charity, Health and Beauty, and Domestic appliance sectors." ]
        , Atom.paragraph [] [ text "I've led teams building computer vision training pipelines at TwentyBN, Open Banking integration across UK high street banks at CompareTheMarket, IoT cloud services for commercial robot vacuums at Vorwerk, an event-sourced real-time community platform at Zapnito, and a WebDAV-based CMS that let Informa's journalists edit articles directly in Microsoft Word." ]
        , Atom.paragraph [] [ text "Most recently founding engineer at xpflow; previously co-founded a school e-commerce business later taken in-house by Marks & Spencer." ]
        , Atom.paragraph [] [ text "Agile from day one; comfortable owning the engineering function or contributing within an established team." ]
        ]


openSourceSection : Element msg
openSourceSection =
    column [ spacing 20, width fill ] (List.map openSourceProject Data.openSourceProjects)


communitySection : Element msg
communitySection =
    column [ spacing 15 ]
        [ Atom.paragraph [] [ text "A regular at Elixir meetups in Barcelona, London, and Berlin, and active in the Elixir and Elm slacks. Previously ran the Elm hack night in Barcelona. I've found both communities friendly and helpful." ]
        ]


skillsSection : Variant -> Element msg
skillsSection variant =
    let
        ( leftGroups, rightGroups ) =
            splitInTwo (Data.skillGroupsFor variant)
    in
    row [ spacing 30, width fill ]
        [ skillGroupsColumn leftGroups
        , skillGroupsColumn rightGroups
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
        , row [ spacing 10 ] [ el [] (Icon.stackoverflow 20), newTabLink [] { label = text "opsb - top 1%", url = "https://stackoverflow.com/users/162337/opsb" } ]
        ]


contactDetails : Element msg
contactDetails =
    column [ alignBottom, Font.color Colors.white, spacing 10, Font.size 14, Font.light, Atom.letterSpacing 1 ]
        [ row [ spacing 10 ] [ el [] (Icon.twitter 20), newTabLink [] { label = text "ollysb", url = "https://twitter.com/ollysb" } ]
        , row [ spacing 10 ] [ el [] (Icon.envelope 20), link [] { label = text "oliver@opsb.co.uk", url = "mailto:oliver@opsb.co.uk" } ]
        ]


mobilePositionView : Variant -> Position -> Element msg
mobilePositionView variant position =
    column
        [ spacing 45
        , width fill
        , paddingEach { top = 0, right = 0, bottom = 5, left = 0 }
        ]
        [ column [ spacing 40, width fill ]
            [ column [ width fill, spacing 30 ]
                [ column [ width (fillPortion 11), spacing 5, alignTop ]
                    [ column [] []
                    , el [ alignLeft ]
                        (Atom.title2 [] position.company)
                    , Element.paragraph [ alignLeft, titleFont, Font.size 16, Font.semiBold, letterSpacing -0.2, Font.color Colors.red ] [ text (Data.positionTitle variant position) ]
                    , el [ alignLeft ] (Atom.bodyText [] position.dates)
                    , el [ alignLeft ] (Atom.bodyText [] position.location)
                    ]
                , row [ spacing 20, width (fillPortion 20), alignTop ]
                    [ column [ spacing 15, width (fillPortion 20) ] (List.map projectView position.projects)
                    ]
                ]
            ]
        ]


positionView : Variant -> Position -> Element msg
positionView variant position =
    row [ width fill, spacing 0 ]
        [ column [ width (fillPortion 7), spacing 3, alignTop ]
            [ Atom.title3 [ Font.size 16, paddingEach { top = 0, right = 0, bottom = 5, left = 0 } ] position.company
            , Element.paragraph [ titleFont, Font.size 12, Font.color Colors.red ] [ text (Data.positionTitle variant position) ]
            , Atom.bodyText [ Font.size 10, Font.regular ] position.dates
            , Atom.bodyText [ Font.size 10, Font.regular ] position.location
            ]
        , column [ spacing 15, width (fillPortion 22) ]
            (List.map projectView position.projects)
        ]


projectView : Project -> Element msg
projectView project =
    column [ spacing 3 ]
        [ Atom.title3 [ Font.size 14, Font.medium, paddingEach { top = 0, right = 0, bottom = 0, left = 0 }, centerY ] project.name
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


skillGroupsColumn : List SkillGroup -> Element msg
skillGroupsColumn groups =
    column [ width (fillPortion 1), spacing 6, alignTop ] (List.map skillGroupView groups)


skillGroupView : SkillGroup -> Element msg
skillGroupView group =
    column [ width fill, spacing 3 ]
        [ Atom.title5 [ Font.size 11, Font.color Colors.red, Font.bold ] group.name
        , column [ width fill, spacing 1 ]
            (List.map
                (\{ name, years } -> Atom.tableOfContentsLine name (String.fromFloat years))
                group.skills
            )
        ]


openSourceProject : OpenSourceProject -> Element msg
openSourceProject project =
    column [ spacing 5, width fill ]
        [ newTabLink [ width fill ]
            { url = project.repo
            , label =
                row [ width fill ]
                    [ el [ alignLeft ] (Atom.title4 [ Font.size 14, Font.medium ] project.name)
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
    Browser.application
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }
