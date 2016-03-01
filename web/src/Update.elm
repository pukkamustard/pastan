module Update (..) where

import Effects exposing (Effects)
import Model exposing (Model)
import Item exposing (Item)


type Action
  = NoOp
  | UpdateItems (Maybe (List Item))
  | AddToQueue Item


update : Action -> Model -> ( Model, Effects Action )
update action model =
  case action of
    UpdateItems maybeItems ->
      ( { model | items = Maybe.withDefault model.items maybeItems }, Effects.none )

    AddToQueue item ->
      ( { model | queue = item :: model.queue }, Effects.none )

    _ ->
      ( model, Effects.none )
