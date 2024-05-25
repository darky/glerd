# glerd

[![Package Version](https://img.shields.io/hexpm/v/glerd)](https://hex.pm/packages/glerd)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/glerd/)

Generate metadata of Gleam Records for runtime reflection

```sh
gleam add --dev glerd
```
```sh
gleam run -m glerd && gleam format ./src/glerd_gen.gleam
```

## Development

```sh
gleam test
gleam format ./test/glerd_gen.gleam
# then commit generated file
```
