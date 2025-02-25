module Definition.AbilityConstructor exposing
    ( AbilityConstructor(..)
    , AbilityConstructorDetail
    , AbilityConstructorListing
    , AbilityConstructorSource(..)
    , AbilityConstructorSummary
    , decodeSignature
    , decodeSource
    )

import Definition.Info exposing (Info)
import Definition.Term as Term exposing (TermSignature)
import Definition.Type as Type exposing (TypeSource)
import FullyQualifiedName exposing (FQN)
import Hash exposing (Hash)
import Json.Decode as Decode
import Syntax exposing (Syntax)


type AbilityConstructorSource
    = Source Syntax
    | Builtin


type AbilityConstructor a
    = AbilityConstructor Hash a


type alias AbilityConstructorDetail =
    AbilityConstructor { info : Info, source : TypeSource }


type alias AbilityConstructorSummary =
    AbilityConstructor
        { fqn : FQN
        , name : FQN
        , namespace : Maybe String
        , signature : TermSignature
        }


type alias AbilityConstructorListing =
    AbilityConstructor FQN



-- JSON DECODERS


decodeSource : List String -> List String -> Decode.Decoder TypeSource
decodeSource =
    Type.decodeTypeSource


decodeSignature : List String -> Decode.Decoder TermSignature
decodeSignature =
    Term.decodeSignature
