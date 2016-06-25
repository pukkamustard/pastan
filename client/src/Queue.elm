module Queue exposing (..)

import List


--

import Pastan.Item exposing (Item)


type alias Queue =
    List Item


add : Queue -> List Item -> Queue
add queue =
    List.append queue


queued : Queue -> Item -> Bool
queued queue item =
    List.member item queue
