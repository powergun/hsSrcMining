# Visual Studio Code Workspace Organizer

features:

- sort workspace entries
- ??

## how to partially edit a json document

inspired by:

<https://tech.fpcomplete.com/haskell/library/aeson>

I can not find a way to define a "generic" type that also remembers
the original json data;

### make sure all the non-stock data types are instances os JSON

meaning that I need to write

```haskell
instance ToJSONKey Id
instance FromJSONKey Id
```

I also have to provide the instances for a few other types (but they
might not be neccessary)

I learned that I could use aeson's `Value` type to decode a nested
json structure using an adhoc Map `fromList` format; this could help
me to implement the partial-editing functionality.

### other articles I read (but were not quite helpful)

<https://hackernoon.com/flexible-data-with-aeson-d8a23ba2169e>

see also: (this article helps me to update shellast to dump the position-map structure): <https://artyom.me/aeson>

<https://guide.aelve.com/haskell/aeson-cookbook-amra6lk6#item-rnh7aque>

the guy who posted this seemed to be have similar problem:

<https://stackoverflow.com/questions/53466541/haskell-aeson-parsing-nested-json-with-part-unnecessary-values>

(but he didn't need to implement a **round-trip**, meaning that he didn't care if the original json data was lost due to the use of
generic, "opaque" data type)
