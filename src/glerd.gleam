import fswalk.{Entry, Stat}
import glance.{CustomType, Definition, Field, Module, NamedType, Variant}
import gleam/iterator
import gleam/list
import gleam/option.{Some}
import gleam/string
import simplifile

pub fn main() {
  let records_info =
    fswalk.builder()
    |> fswalk.with_path("src")
    |> fswalk.walk()
    |> iterator.filter(fn(entry_result) {
      case entry_result {
        Ok(Entry(path, Stat(is_dir))) ->
          is_dir == False && string.ends_with(path, ".gleam")
        _ -> False
      }
    })
    |> iterator.map(fn(entry_result) {
      let assert Ok(Entry(path, _)) = entry_result
      path
    })
    |> iterator.map(fn(path) {
      let assert Ok(content) = simplifile.read(path)
      content
    })
    |> iterator.map(fn(content) {
      let assert Ok(module) = glance.module(content)
      module
    })
    |> iterator.flat_map(fn(module) {
      let Module(_, custom_types_definitions, ..) = module
      iterator.from_list(custom_types_definitions)
    })
    |> iterator.map(fn(custom_type_definition) {
      let Definition(_, custom_type) = custom_type_definition
      custom_type
    })
    |> iterator.flat_map(fn(custom_type) {
      let CustomType(_, _, _, _, variants) = custom_type
      list.map(variants, fn(variant) {
        let Variant(record_name, fields) = variant
        let record_description =
          list.map(fields, fn(field) {
            let Field(name, typ) = field
            let assert Some(name) = name
            "#(\""
            <> name
            <> "\", "
            <> case typ {
              NamedType(type_name, ..) if type_name == "String" ->
                "types.IsString"
              NamedType(type_name, ..) if type_name == "Int" -> "types.IsInt"
              _ -> "Unknown"
            }
            <> ")"
          })
        "\""
        <> record_name
        <> "\""
        <> " -> "
        <> "["
        <> string.join(record_description, ",")
        <> "]"
      })
      |> iterator.from_list
    })
    |> iterator.to_list

  { "// this file generated via \"gleam run -m glerd\"
    import types

    pub fn get_record_info(name) {
      case name {" <> records_info
    |> string.join("\n") <> "_ -> panic as {\"Record not found \" <> name}}}" }
  |> simplifile.write("./src/glerd_gen.gleam", _)
}
