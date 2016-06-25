module View exposing (view)

import Color
import Html as H exposing (Html)
import Html.Attributes as HA
import Html.Events as HE
import FontAwesome


--

import Model exposing (Model)
import Pastan
import Queue exposing (Queue)
import Update exposing (Msg(..))


search : Model -> Html Msg
search model =
    H.form
        [ HA.class "search u-full-width"
        , HA.action "#"
        , HE.onSubmit Query
        ]
        [ H.input
            [ HA.class "ten columns"
            , HA.placeholder "Search"
            , HA.type' "text"
            , HE.onInput UpdateQuery
            ]
            []
        , H.button [ HA.class "two columns", HA.type' "submit" ] [ H.text "Search" ]
        ]


items : Model -> Html Msg
items model =
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
                    [ H.a [ HA.href (Pastan.fileUrl i), HA.target "_blank" ] [ FontAwesome.play_circle Color.green 30 ]
                    , if Queue.queued model.queue i then
                        H.a [ HE.onClick (AddToQueue [ i ]) ] [ FontAwesome.plus_circle Color.lightBlue 30 ]
                      else
                        H.a [ HE.onClick (AddToQueue [ i ]) ] [ FontAwesome.plus_circle Color.darkBlue 30 ]
                    ]
                ]
    in
        H.table [ HA.class "u-full-width items" ]
            <| header
            :: (model.items
                    |> List.map item
               )


queue : Queue -> Html Msg
queue queue =
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
        H.table [ HA.class "u-full-width items" ]
            <| header
            :: (queue |> List.map item)


view : Model -> Html Msg
view model =
    H.div [ HA.class "container" ]
        [ H.div [ HA.class "row" ] [ search model ]
          -- , H.div [ HA.class "row" ] [ H.text (toString model) ]
        , H.div [ HA.class "row" ] [ items model ]
        , H.div [ HA.class "row" ] [ queue model.queue ]
        ]
