module Model (..) where

import Item exposing (Item)
import Effects exposing (Effects)


type alias Model =
  { items : List Item
  , queue : List Item
  }



-- init : ( Model, Effects Action )
