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
                        [ HA.class "eight columns"
                        , HA.placeholder "Search"
                        , HA.type' "text"
                        , HE.onInput UpdateQuery
                        ]
                        []
                    , H.button [ HA.class "two columns", HA.type' "submit" ] [ H.text "Search" ]
                    , H.button [ HE.onClick (Queue model.items), HA.class "two columns", HA.type' "button" ] [ H.text "Queue all" ]
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
                        , H.td [] [ H.a [ HE.onClick (SelectAlbum i) ] [ H.text i.album ] ]
                        , H.td [] [ H.text i.title ]
                        , H.td []
                            [ H.a [ HE.onClick (Queue [ i ]) ]
                                [ if Player.inQueue model.player i then
                                    FontAwesome.check Color.green 30
                                  else
                                    FontAwesome.plus Color.blue 30
                                ]
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


view : Model -> Html Msg
view model =
    H.div [ HA.class "page" ]
        [ H.div [ HA.class "content" ]
            [ H.div [ HA.class "browse" ] [ browse model ]
            , H.div [ HA.class "queue" ] [ queue model ]
            ]
        , H.div [ HA.class "footer" ]
            [ H.div [ HA.class "player" ] [ Player.view model.player |> HApp.map PlayerMsg ]
            ]
        ]
