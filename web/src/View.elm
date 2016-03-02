module View (..) where

import Html exposing (Html, Attribute)
import Html.Attributes as Attributes
import Html.Events as Events
import Signal
import Model exposing (Model)
import Update exposing (Action(..))
import Page exposing (Page(..))
import Page.Items
import Page.Albums
import Page.Queue


menu : Signal.Address Action -> Model -> Html
menu address model =
  Html.div
    [ Attributes.id "sidebar-wrapper" ]
    [ Html.ul
        [ Attributes.class "sidebar-nav" ]
        [ Html.li [ Attributes.class "sidebar-brand" ] [ Html.h2 [] [ Html.text "Pastan" ] ]
        , Html.li [ changePage address PageQueue ] [ Html.a [ active model PageQueue ] [ Html.text "Queue" ] ]
        , Html.li [] [ Html.h4 [] [ Html.text "Library" ] ]
        , Html.li [ changePage address PageItems ] [ Html.a [ active model PageItems ] [ Html.text "Items" ] ]
        , Html.li [ changePage address PageAlbums ] [ Html.a [ active model PageAlbums ] [ Html.text "Albums" ] ]
        ]
    ]


active : Model -> Page -> Attribute
active model page =
  Attributes.classList [ ( "active", model.currentPage == page ) ]


changePage : Signal.Address Action -> Page -> Attribute
changePage address page =
  Events.onClick address (ChangePage page)


page : Signal.Address Action -> Model -> Html
page address model =
  pageWrapper
    <| case model.currentPage of
        PageItems ->
          Page.Items.view address model

        PageAlbums ->
          [ Page.Albums.view address model ]

        PageQueue ->
          [ Page.Queue.view address model ]


pageWrapper : List Html -> Html
pageWrapper pageContent =
  Html.div
    [ Attributes.id "page-content-wrapper" ]
    [ Html.div
        [ Attributes.class "container-fluid" ]
        pageContent
    ]


view : Signal.Address Action -> Model -> Html
view address model =
  Html.div
    []
    [ menu address model
    , page address model
    ]
