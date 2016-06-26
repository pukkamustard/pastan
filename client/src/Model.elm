module Model exposing (Model, init)

import Pastan.Item exposing (Item)
import Player


type alias Model =
    { items : List Item
    , query : String
    , player : Player.Model
    }



init : Model
init =
    { items = []
    , query = "id is 8115"
    , player = Player.init
    }
