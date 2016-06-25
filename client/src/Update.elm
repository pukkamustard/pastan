module Update exposing (Msg(..), update, init, subscriptions)

import Http
import Task


--

import Model exposing (Model)
import Pastan
import Pastan.Item exposing (Item)


--

import Player


type Msg
    = Query
    | QueryFailure Http.Error
    | QueryResponse (List Item)
    | UpdateQuery String
    | Queue (List Item)
    | Play
    | Stop
    | PlayerMsg Player.Msg


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

        Queue items ->
            ( model, PlayerMsg (Player.Queue items) |> Task.succeed |> Task.perform identity identity )

        Play ->
            ( model
            , PlayerMsg Player.Play
                |> Task.succeed
                |> Task.perform identity identity
            )

        Stop ->
            ( model
            , PlayerMsg Player.Stop
                |> Task.succeed
                |> Task.perform identity identity
            )

        PlayerMsg subMsg ->
            let
                ( player', playerCmd ) =
                    Player.update subMsg model.player
            in
                ( { model | player = player' }, playerCmd |> Cmd.map PlayerMsg )


subscriptions : Model -> Sub Msg
subscriptions model =
    Player.subscriptions model.player
        |> Sub.map PlayerMsg
