# Glerd

[![Package Version](https://img.shields.io/hexpm/v/glerd)](https://hex.pm/packages/glerd)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/glerd/)

Glerd is tooling, written in [Gleam](https://gleam.run/), that generates
metadata that describes Gleam [Records](https://tour.gleam.run/data-types/records/).
This metadata can be used to generate Gleam code that works with those records,
as a substitute for runtime reflection, which does not exist in Gleam.

## Installing

```sh
gleam add --dev glerd
```

## Usage

Run:

```sh
gleam run -m glerd
```

This reads Gleam source files in the `src` directory of a project and creates
a `glerd_gen.gleam` output file containing metadata for each of the Records in
those files.

## Example output

If this record exists in a source file:

###### src/user.gleam

```gleam
pub type User {
  /// some metadata
  User(id: Int, name: String, email: String)
}
```

the output will be:

###### src/glerd_gen.gleam

```gleam
import glerd/types

pub const record_info = [
  #(
    "User", // record name
    "user", // module name
    [
      #("id", types.IsInt), #("name", types.IsString),
      #("email", types.IsString),
    ],
    "some metadata",
  ),
]
```

This metadata can then be used to generate Gleam code that works with the `User`
record (see [glerd_json](https://github.com/darky/glerd-json) for an example of
reading this metadata and generating Gleam boilerplate code for
encoding/decoding records to/from [JSON](https://www.json.org/json-en.html)).

## Sample project

If you'd like to try out Glerd, there is a
[sample Gleam project](https://github.com/jasonprogrammer/glerd_example) with
instructions and a source file for quick testing.

## Development

Run:

```sh
gleam test # and then commit generated file
```

## See also

* [Codegen for JSON encoders/decoders using Glerd](https://github.com/darky/glerd-json)
