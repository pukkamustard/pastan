module View exposing (view)

import Color
import Html as H exposing (Html)
import Html.Attributes as HA
import Html.Events as HE
import FontAwesome


--

import Model exposing (Model, Mode(..))
import Pastan
import Queue exposing (Queue)
import Update exposing (Msg(..))


browse : Model -> Html Msg
browse model =
    let
        search =
            H.div [ HA.class "row" ]
                [ H.a [ HA.class "u-pull-left one column", HE.onClick (SetMode Queue) ] [ FontAwesome.angle_up Color.darkBlue 30 ]
                , H.form
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
                            [ H.a [ HA.href (Pastan.fileUrl i), HA.target "_blank" ] [ FontAwesome.play Color.green 30 ]
                            , if Queue.queued model.queue i then
                                H.a [ HE.onClick (AddToQueue [ i ]) ] [ FontAwesome.plus Color.lightBlue 30 ]
                              else
                                H.a [ HE.onClick (AddToQueue [ i ]) ] [ FontAwesome.plus Color.darkBlue 30 ]
                            ]
                        ]
            in
                H.table [ HA.class "u-full-width items" ]
                    <| header
                    :: (model.items
                            |> List.map item
                       )

        expand =
            H.div [ HA.class "row" ]
                [ H.a [ HA.class "u-pull-left", HE.onClick (SetMode Browse) ] [ FontAwesome.angle_down Color.darkBlue 30 ] ]

        hide =
            H.div [ HA.class "row" ]
                [ H.a [ HA.class "u-pull-left", HE.onClick (SetMode Queue) ] [ FontAwesome.angle_up Color.darkBlue 30 ] ]
    in
        H.div
            [ HA.class "browse container"
            ]
            (if model.mode == Browse then
                [ search
                , items
                ]
             else
                [ expand
                ]
            )


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
                        :: (model.queue |> List.map item)
                    ]

        expand =
            H.div [ HA.class "row" ]
                [ H.a [ HA.class "u-pull-left", HE.onClick (SetMode Queue) ] [ FontAwesome.search Color.darkBlue 30 ] ]
    in
        H.div [ HA.class "queue container" ]
            (if model.mode == Queue then
                [ items ]
             else
                [ items ]
             -- [ expand ]
            )


view : Model -> Html Msg
view model =
    H.div []
        [ H.div [ HA.class "browse" ] [ browse model ]
        , H.hr [] []
        , H.div [ HA.class "queue" ] [ queue model ]
        ]
