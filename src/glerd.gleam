import fswalk.{Entry, Stat}
import glance.{
  CustomType, Definition, Field, Module, NamedType, TupleType, Variant,
}
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
            let Field(field_name, typ) = field
            let assert Some(field_name) = option.or(field_name, Some("unknown"))
            "#(\"" <> field_name <> "\", " <> field_type(typ) <> ")"
          })
        let record_fields = string.join(record_description, ",")
        "\"" <> record_name <> "\"" <> " -> " <> "[" <> record_fields <> "]"
      })
      |> iterator.from_list
    })
    |> iterator.to_list

  { "// this file generated via \"gleam run -m glerd\"

    import glerd_types

    pub fn get_record_info(record_name) {
      case record_name {" <> string.join(records_info, "\n") <> "_ -> panic as {\"Record not found \" <> record_name}}}" }
  |> simplifile.write("./src/glerd_gen.gleam", _)
}

fn field_type(typ) {
  case typ {
    NamedType(type_name, ..) if type_name == "String" -> "glerd_types.IsString"
    NamedType(type_name, ..) if type_name == "Int" -> "glerd_types.IsInt"
    NamedType(type_name, ..) if type_name == "Float" -> "glerd_types.IsFloat"
    NamedType(type_name, ..) if type_name == "Bool" -> "glerd_types.IsBool"
    NamedType(type_name, _, [typ]) if type_name == "List" ->
      "glerd_types.IsList(" <> field_type(typ) <> ")"
    TupleType([typ1, typ2]) ->
      "glerd_types.IsTuple2("
      <> field_type(typ1)
      <> ","
      <> field_type(typ2)
      <> ")"
    TupleType([typ1, typ2, typ3]) ->
      "glerd_types.IsTuple3("
      <> field_type(typ1)
      <> ","
      <> field_type(typ2)
      <> ","
      <> field_type(typ3)
      <> ")"
    TupleType([typ1, typ2, typ3, typ4]) ->
      "glerd_types.IsTuple4("
      <> field_type(typ1)
      <> ","
      <> field_type(typ2)
      <> ","
      <> field_type(typ3)
      <> ","
      <> field_type(typ4)
      <> ")"
    TupleType([typ1, typ2, typ3, typ4, typ5]) ->
      "glerd_types.IsTuple5("
      <> field_type(typ1)
      <> ","
      <> field_type(typ2)
      <> ","
      <> field_type(typ3)
      <> ","
      <> field_type(typ4)
      <> ","
      <> field_type(typ5)
      <> ")"
    TupleType([typ1, typ2, typ3, typ4, typ5, typ6]) ->
      "glerd_types.IsTuple6("
      <> field_type(typ1)
      <> ","
      <> field_type(typ2)
      <> ","
      <> field_type(typ3)
      <> ","
      <> field_type(typ4)
      <> ","
      <> field_type(typ5)
      <> ","
      <> field_type(typ6)
      <> ")"
    _ -> "glerd_types.Unknown"
  }
}
