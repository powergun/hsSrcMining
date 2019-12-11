# Visual Studio Code Workspace Organizer

features:

- sort workspace entries
- ??

## pretty print json (Aeson-pretty package)

<https://hackage.haskell.org/package/aeson-pretty-0.8.7/docs/Data-Aeson-Encode-Pretty.html>

## how to partially edit a json document

see `hsDataMuning/jsonmuning/DataTypes/SimpleDecompose` example

## how to sort the project directory paths by basename

see: <https://stackoverflow.com/questions/23257915/sorting-a-list-of-custom-data-types-by-certain-attribute-in-haskell>

get basename: <http://hackage.haskell.org/package/filepath-1.4.2.1/docs/System-FilePath-Posix.html>

## how to support optional field(s)

use `.:?` and Data.Maybe.fromMaybe (short form for `maybe l r x`)

the field type must NOT be `Maybe a` because encoder will generate
`null` value instead of a default empty object `{}`;

my test showed that `null` will corrupt the workspace setting
