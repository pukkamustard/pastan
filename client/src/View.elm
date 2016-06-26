module View exposing (view)

import Color
import Html as H exposing (Html)
import Html.Attributes as HA
import Html.Events as HE
import FontAwesome


--

import Model exposing (Model)
import Update exposing (Msg(..))
import Player


browse : Model -> Html Msg
browse model =
    let
        search =
            H.div [ HA.class "row" ]
                [ -- H.a [ HA.class "u-pull-left one column", HE.onClick (SetMode Queue) ] [ FontAwesome.angle_up Color.darkBlue 30 ]
                  H.form
                    [ HA.class "search"
                    , HA.action "#"
                    , HE.onSubmit Query
                    ]
                    [ H.input
                        [ HA.class "nine columns"
                        , HA.placeholder "Search"
                        , HA.type' "text"
                        , HE.onInput UpdateQuery
                        ]
                        []
                    , H.button [ HA.class "two columns", HA.type' "submit" ] [ H.text "Search" ]
                    ]
                ]

        items =
            let
                header =
                    H.thead []
                        [ H.tr []
                            [ H.th [] [ H.text "Artist" ]
                            , H.th [] [ H.text "Album" ]
                            , H.th [] [ H.text "Title" ]
                            , H.th [] [ H.text "" ]
                            ]
                        ]

                item i =
                    H.tr [ HA.class "item" ]
                        [ H.td [] [ H.text i.artist ]
                        , H.td [] [ H.text i.album ]
                        , H.td [] [ H.text i.title ]
                        , H.td []
                            [ -- H.a [ HA.href (Pastan.fileUrl i), HA.target "_blank" ] [ FontAwesome.play Color.green 30 ]
                              H.a [ HE.onClick (Queue [ i ]) ] [ FontAwesome.plus Color.blue 30 ]
                            ]
                        ]
            in
                H.table [ HA.class "u-full-width items" ]
                    <| header
                    :: (model.items
                            |> List.map item
                       )
    in
        H.div
            [ HA.class "browse container"
            ]
            [ search
            , items
            ]


player : Model -> Html Msg
player model =
    let
        items =
            let
                header =
                    H.thead []
                        [ H.tr []
                            [ H.th [] [ H.text "Artist" ]
                            , H.th [] [ H.text "Album" ]
                            , H.th [] [ H.text "Title" ]
                            ]
                        ]

                item i =
                    H.tr [ HA.class "item" ]
                        [ H.td [] [ H.text i.artist ]
                        , H.td [] [ H.text i.album ]
                        , H.td [] [ H.text i.title ]
                        ]
            in
                H.div [ HA.class "row" ]
                    [ H.table [ HA.class "u-full-width items" ]
                        <| header
                        :: (model.player.queue |> List.map (Player.toItem >> item))
                    ]
    in
        H.div [ HA.class "player container" ]
            [ H.div [ HA.class "row" ]
                [ case model.player.state of
                    Player.Playing ->
                        H.a [ HE.onClick Stop ] [ FontAwesome.stop Color.red 50 ]

                    Player.Stopped ->
                        H.a [ HE.onClick Play ] [ FontAwesome.play Color.green 50 ]

                    Player.Stopping ->
                        H.a [] [ FontAwesome.stop Color.lightRed 50 ]
                , H.a [ HE.onClick Next ] [ FontAwesome.fast_forward Color.blue 50 ]
                ]
            , items
            ]


view : Model -> Html Msg
view model =
    H.div []
        [ H.div [ HA.class "browse" ] [ browse model ]
        , H.hr [] []
        , H.div [ HA.class "queue" ] [ player model ]
        , H.text (toString model.player.state)
        ]
