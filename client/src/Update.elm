module Update exposing (Msg(..), update, init, subscriptions)

import Http
import Task


--

import Model exposing (Model)
import Pastan
import Pastan.Item exposing (Item)


type Msg
    = Query
    | QueryFailure Http.Error
    | QueryResponse (List Item)
    | UpdateQuery String


init : Cmd Msg
init =
    Query
        |> Task.succeed
        |> Task.perform identity identity


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Query ->
            let
                query =
                    model.query
            in
                ( model
                , Pastan.items query
                    |> Task.perform QueryFailure QueryResponse
                )

        QueryFailure err ->
            ( model, Cmd.none )

        QueryResponse items ->
            ( { model | items = items }, Cmd.none )

        UpdateQuery query ->
            ( { model | query = query }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
