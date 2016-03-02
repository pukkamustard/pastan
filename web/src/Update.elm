module Update (..) where

import List
import Effects exposing (Effects)
import Model exposing (Model)
import Item exposing (Item)
import Page exposing (Page)


type Action
  = NoOp
  | UpdateItems (Maybe (List Item))
  | AddToQueue Item
  | ChangePage Page


update : Action -> Model -> ( Model, Effects Action )
update action model =
  case action of
    UpdateItems maybeItems ->
      ( { model | items = Maybe.withDefault model.items maybeItems }, Effects.none )

    AddToQueue item ->
      ( { model | queue = List.append model.queue [ item ] }, Effects.none )

    ChangePage page ->
      ( { model | currentPage = page }, Effects.none )

    _ ->
      ( model, Effects.none )
