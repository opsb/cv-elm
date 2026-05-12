module Experimental.View exposing (view)

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Experimental.Data as Data exposing (Institution, OpenSourceProject, Position, Project, SkillGroup, Variant(..))
import Html exposing (Html)
import Html.Attributes


view : Browser.Document msg
view =
    { title = "Oliver Searle-Barnes — CV"
    , body = [ Element.layout pageAttrs page ]
    }



---- TOKENS ----


primaryVariant : Variant
primaryVariant =
    Elixir


type alias Theme =
    { panelBg : Color
    , textColor : Color
    , subtleColor : Color
    , ruleColor : Color
    , accentColor : Color
    }


lightTheme : Theme
lightTheme =
    { panelBg = rgb255 255 255 255
    , textColor = rgb255 34 34 38
    , subtleColor = rgb255 130 130 138
    , ruleColor = rgb255 180 180 188
    , accentColor = rgb255 34 34 38
    }


darkTheme : Theme
darkTheme =
    { panelBg = rgb255 56 56 64
    , textColor = rgb255 240 240 244
    , subtleColor = rgb255 180 180 190
    , ruleColor = rgb255 100 100 116
    , accentColor = rgb255 240 240 244
    }


bgColor : Color
bgColor =
    rgb255 245 242 238


sans : Element.Attribute msg
sans =
    Font.family
        [ Font.typeface "DM Sans"
        , Font.typeface "Helvetica Neue"
        , Font.typeface "Helvetica"
        , Font.typeface "Arial"
        , Font.sansSerif
        ]


letterSpacing : Float -> Element.Attribute msg
letterSpacing px_ =
    htmlAttribute (Html.Attributes.style "letter-spacing" (String.fromFloat px_ ++ "px"))


lineHeight : Float -> Element.Attribute msg
lineHeight n =
    htmlAttribute (Html.Attributes.style "line-height" (String.fromFloat n))



---- LAYOUT ----


pageAttrs : List (Attribute msg)
pageAttrs =
    [ sans
    , Font.color lightTheme.textColor
    , Background.color bgColor
    , width fill
    , height fill
    , Font.size 13
    , lineHeight 1.45
    , paddingXY 0 40
    ]


page : Element msg
page =
    row
        [ width (fill |> maximum 920)
        , centerX
        , Background.color lightTheme.panelBg
        , Border.shadow
            { offset = ( 0, 4 )
            , size = 0
            , blur = 20
            , color = rgba 0 0 0 0.08
            }
        ]
        [ leftPanel
        , rightPanel
        ]



---- LEFT PANEL (dark) ----


leftPanel : Element msg
leftPanel =
    column
        [ width (fillPortion 3)
        , height fill
        , Background.color darkTheme.panelBg
        , Font.color darkTheme.textColor
        , paddingXY 32 56
        , spacing 30
        , alignTop
        ]
        [ sidebarSection darkTheme "Contact" (contactBlock darkTheme)
        , sidebarSection darkTheme "Education" (educationBlock darkTheme)
        , sidebarSection darkTheme "Open source" (openSourceBlock darkTheme)
        , sidebarSection darkTheme "Skills" (skillsBlock darkTheme)
        ]



---- RIGHT PANEL (light) ----


rightPanel : Element msg
rightPanel =
    column
        [ width (fillPortion 7)
        , height fill
        , paddingXY 44 56
        , spacing 30
        , alignTop
        ]
        [ header
        , sidebarSection lightTheme "About me" (aboutBlock lightTheme)
        , sidebarSection lightTheme "Experience" (experienceBlock lightTheme)
        ]



---- HEADER ----


header : Element msg
header =
    column [ alignLeft, spacing 10, width fill ]
        [ el
            [ Font.size 44
            , Font.light
            , letterSpacing 2
            , Font.color lightTheme.textColor
            ]
            (text (String.toUpper Data.name))
        , el
            [ Font.size 11
            , Font.light
            , letterSpacing 6
            , Font.color lightTheme.subtleColor
            ]
            (text (String.toUpper "Senior Elixir Engineer · Tech Lead · Architect"))
        ]



---- SECTION HEADERS ----


sidebarSection : Theme -> String -> Element msg -> Element msg
sidebarSection theme title body =
    column [ spacing 14, width fill, alignTop ]
        [ sectionHeader theme title
        , body
        ]


sectionHeader : Theme -> String -> Element msg
sectionHeader theme title =
    column [ spacing 8, width fill ]
        [ el
            [ Font.size 12
            , Font.light
            , letterSpacing 6
            , Font.color theme.subtleColor
            ]
            (text (String.toUpper title))
        , el
            [ width fill
            , height (px 1)
            , Background.color theme.ruleColor
            ]
            none
        ]



---- CONTACT ----


contactBlock : Theme -> Element msg
contactBlock theme =
    column [ spacing 10, width fill ]
        [ contactRow theme "Email" "oliver@opsb.co.uk"
        , contactRow theme "Location" "Barcelona, Spain"
        , contactRow theme "Right to work" "UK citizen · UK RTW"
        , contactRow theme "GitHub" "github.com/opsb"
        , contactRow theme "LinkedIn" "/in/oliversearlebarnes"
        ]


contactRow : Theme -> String -> String -> Element msg
contactRow theme label value =
    column [ spacing 1, width fill ]
        [ el
            [ Font.size 9
            , letterSpacing 1.4
            , Font.color theme.subtleColor
            ]
            (text (String.toUpper label))
        , el [ Font.size 12, Font.color theme.textColor ] (text value)
        ]



---- EDUCATION ----


educationBlock : Theme -> Element msg
educationBlock theme =
    column [ spacing 14, width fill ]
        (List.map (institutionItem theme) Data.education)


institutionItem : Theme -> Institution -> Element msg
institutionItem theme inst =
    column [ spacing 2, width fill ]
        [ el
            [ Font.size 12
            , Font.bold
            , letterSpacing 1.5
            , Font.color theme.textColor
            ]
            (text (String.toUpper inst.name))
        , el [ Font.size 12, Font.color theme.textColor ] (text inst.course)
        , el [ Font.size 11, Font.color theme.subtleColor ]
            (text (String.fromInt inst.startYear ++ " – " ++ String.fromInt inst.endYear))
        ]



---- OPEN SOURCE ----


openSourceBlock : Theme -> Element msg
openSourceBlock theme =
    column [ spacing 14, width fill ]
        (List.map (openSourceItem theme) Data.openSourceProjects)


openSourceItem : Theme -> OpenSourceProject -> Element msg
openSourceItem theme proj =
    column [ spacing 2, width fill ]
        [ el
            [ Font.size 12
            , Font.bold
            , letterSpacing 1.2
            , Font.color theme.textColor
            ]
            (text (String.toUpper proj.name))
        , Element.paragraph [ Font.size 11, Font.color theme.subtleColor, lineHeight 1.4 ]
            [ text proj.shortInvolvement
            , text " · "
            , text proj.language
            ]
        ]



---- SKILLS ----


skillsBlock : Theme -> Element msg
skillsBlock theme =
    column [ spacing 16, width fill ]
        (List.map (skillGroupItem theme) (Data.skillGroupsFor primaryVariant))


skillGroupItem : Theme -> SkillGroup -> Element msg
skillGroupItem theme group =
    column [ spacing 6, width fill ]
        [ el
            [ Font.size 11
            , Font.bold
            , letterSpacing 1.5
            , Font.color theme.textColor
            ]
            (text (String.toUpper group.name))
        , column [ spacing 3 ]
            (group.skills
                |> List.map
                    (\s ->
                        Element.paragraph
                            [ Font.size 11
                            , Font.color theme.textColor
                            , lineHeight 1.4
                            ]
                            [ text "• "
                            , text s.name
                            ]
                    )
            )
        ]



---- ABOUT ----


aboutBlock : Theme -> Element msg
aboutBlock theme =
    column [ spacing 10, width fill ]
        (Data.introductionParagraphsFor primaryVariant
            |> List.map
                (\p ->
                    Element.paragraph
                        [ Font.size 13
                        , lineHeight 1.55
                        , Font.color theme.textColor
                        ]
                        [ text p ]
                )
        )



---- EXPERIENCE ----


experienceBlock : Theme -> Element msg
experienceBlock theme =
    column [ spacing 26, width fill ]
        (Data.experiencePositionsFor primaryVariant
            |> List.map (positionBlock theme)
        )


positionBlock : Theme -> Position -> Element msg
positionBlock theme position =
    column [ spacing 8, width fill ]
        [ el
            [ Font.size 12
            , Font.bold
            , letterSpacing 2
            , alignLeft
            , Font.color theme.textColor
            ]
            (text (String.toUpper (positionCompanyLine position)))
        , el
            [ Font.size 13
            , Font.italic
            , Font.color theme.textColor
            ]
            (text (Data.positionTitle primaryVariant position))
        , companyStackLine theme position.companyStack
        , column [ spacing 10, width fill ]
            (List.map (projectBlock theme) position.projects)
        ]


positionCompanyLine : Position -> String
positionCompanyLine position =
    let
        company =
            position.company |> String.replace "\n" ""
    in
    company ++ "  ·  " ++ position.dates


companyStackLine : Theme -> List String -> Element msg
companyStackLine theme stack =
    case stack of
        [] ->
            none

        _ ->
            el
                [ Font.size 11
                , Font.color theme.subtleColor
                , letterSpacing 0.5
                ]
                (text (String.join " / " stack))


projectBlock : Theme -> Project -> Element msg
projectBlock theme project =
    column [ spacing 6, width fill ]
        [ el
            [ Font.size 13
            , Font.bold
            , Font.color theme.textColor
            ]
            (text project.name)
        , Element.paragraph
            [ Font.size 12
            , lineHeight 1.5
            , Font.color theme.textColor
            ]
            [ text project.overview ]
        , talkingPointsBlock theme project.talkingPoints
        ]


talkingPointsBlock : Theme -> List String -> Element msg
talkingPointsBlock theme points =
    case points of
        [] ->
            none

        _ ->
            column [ spacing 4, paddingEach { top = 4, right = 0, bottom = 0, left = 14 }, width fill ]
                (List.map (bulletItem theme) points)


bulletItem : Theme -> String -> Element msg
bulletItem theme t =
    row [ spacing 8, alignTop, width fill ]
        [ el [ Font.size 11, Font.color theme.subtleColor, alignTop ] (text "•")
        , Element.paragraph
            [ Font.size 11
            , lineHeight 1.5
            , Font.color theme.textColor
            ]
            [ text t ]
        ]
