module Model (..) where

import Item exposing (Item)
import Page exposing (Page)


type alias Model =
  { items : List Item
  , queue : List Item
  , currentPage : Page
  }
