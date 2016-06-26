module View exposing (view)

import Color
import Html as H exposing (Html)
import Html.App as HApp
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


queue : Model -> Html Msg
queue model =
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
                        :: (model.player.queue |> List.map item)
                    ]
    in
        H.div [ HA.class "queue container" ]
            [ H.div [ HA.class "row" ]
                [ items ]
            ]


player : Player.Model -> Html Player.Msg
player model =
    let
        playStop =
            case model.state of
                Player.Playing ->
                    H.a [ HE.onClick Player.Stop ] [ FontAwesome.stop Color.red 50 ]

                -- Player.Stopped ->
                _ ->
                    H.a [ HE.onClick Player.Play ] [ FontAwesome.play Color.green 50 ]

        next =
            H.a [ HE.onClick Player.Next ] [ FontAwesome.fast_forward Color.blue 50 ]

        item =
            case model.queue of
                head :: _ ->
                    H.div []
                        [ H.h4 [] [ H.text (head.artist ++ " - " ++ head.title) ] ]

                _ ->
                    H.text ""
    in
        H.div [ HA.class "container" ]
            [ H.div [ HA.class "row" ]
                [ H.div [ HA.class "three columns" ]
                    [ playStop, next ]
                , H.div [ HA.class "nine columns" ]
                    [ item ]
                ]
            ]


view : Model -> Html Msg
view model =
    H.div [ HA.class "page" ]
        [ H.div [ HA.class "content" ]
            [ H.div [ HA.class "browse" ] [ browse model ]
            , H.div [ HA.class "queue" ] [ queue model ]
            ]
        , H.div [ HA.class "footer" ]
            [ H.div [ HA.class "player" ] [ player model.player |> HApp.map PlayerMsg ]
            ]
        ]
