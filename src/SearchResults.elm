module SearchResults exposing
    ( Matches
    , SearchResults(..)
    , focus
    , focusOn
    , from
    , fromList
    , isEmpty
    , length
    , map
    , mapMatchesToList
    , mapToList
    , next
    , prev
    , toList
    , toMaybe
    )

import List.Zipper as Zipper exposing (Zipper)
import Maybe.Extra exposing (unwrap)



-- SEARCH RESULT


type SearchResults a
    = Empty
    | SearchResults (Matches a)


isEmpty : SearchResults a -> Bool
isEmpty results =
    case results of
        Empty ->
            True

        SearchResults _ ->
            False


fromList : List a -> SearchResults a
fromList data =
    unwrap Empty (Matches >> SearchResults) (Zipper.fromList data)


from : List a -> a -> List a -> SearchResults a
from before focus_ after =
    SearchResults (Matches (Zipper.from before focus_ after))


length : SearchResults a -> Int
length results =
    case results of
        Empty ->
            0

        SearchResults (Matches data) ->
            data
                |> Zipper.toList
                |> List.length


map : (Matches a -> Matches a) -> SearchResults a -> SearchResults a
map f results =
    case results of
        Empty ->
            Empty

        SearchResults matches ->
            SearchResults (f matches)


mapToList : (a -> Bool -> b) -> SearchResults a -> List b
mapToList f results =
    case results of
        Empty ->
            []

        SearchResults matches ->
            mapMatchesToList f matches


toMaybe : SearchResults a -> Maybe (Matches a)
toMaybe results =
    case results of
        Empty ->
            Nothing

        SearchResults matches ->
            Just matches


toList : SearchResults a -> List a
toList results =
    case results of
        Empty ->
            []

        SearchResults (Matches data) ->
            Zipper.toList data



-- MATCHES


type Matches a
    = Matches (Zipper a)


next : Matches a -> Matches a
next ((Matches data) as matches) =
    unwrap matches Matches (Zipper.next data)


prev : Matches a -> Matches a
prev ((Matches data) as matches) =
    unwrap matches Matches (Zipper.previous data)


focus : Matches a -> a
focus (Matches data) =
    Zipper.current data


focusOn : (a -> Bool) -> Matches a -> Matches a
focusOn pred ((Matches data) as matches) =
    unwrap matches Matches (Zipper.findFirst pred data)


mapMatchesToList : (a -> Bool -> b) -> Matches a -> List b
mapMatchesToList f (Matches data) =
    let
        before =
            data
                |> Zipper.before
                |> List.map (\a -> f a False)

        focus_ =
            f (Zipper.current data) True

        after =
            data
                |> Zipper.after
                |> List.map (\a -> f a False)
    in
    before ++ (focus_ :: after)
