module View exposing (view)

import Html as H exposing (Html)
import Html.Attributes as HA
import Html.Events as HE


--

import Model exposing (Model)
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
                    ]
                ]
    in
        H.table [ HA.class "u-full-width items" ]
            <| header
            :: (model.items
                    |> List.map
                        (\i ->
                            H.tr [HA.class "item"]
                                [ H.td [] [ H.text i.artist ]
                                , H.td [] [ H.text i.album ]
                                , H.td [] [ H.text i.title ]
                                ]
                        )
               )


view : Model -> Html Msg
view model =
    H.div [ HA.class "container" ]
        [ H.div [ HA.class "row" ] [ search model ]
          -- , H.div [ HA.class "row" ] [ H.text (toString model) ]
        , H.div [ HA.class "row" ] [ items model ]
        ]
