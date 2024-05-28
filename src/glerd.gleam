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
  generate("src")
}

pub fn generate(root) {
  let records_info =
    fswalk.builder()
    |> fswalk.with_path(root)
    |> fswalk.walk()
    |> iterator.filter(fn(entry_result) {
      case entry_result {
        Ok(Entry(path, Stat(is_dir))) ->
          is_dir == False
          && string.ends_with(path, ".gleam")
          && !string.contains(path, "glerd_gen.gleam")
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
    |> iterator.map(fn(module) {
      let Module(_, custom_types_definitions, ..) = module
      custom_types_definitions
    })
    |> iterator.flat_map(fn(custom_type_definitions) {
      {
        use custom_type_definition <- list.flat_map(custom_type_definitions)
        let Definition(_, custom_type) = custom_type_definition
        let CustomType(_, _, _, _, variants) = custom_type
        use variant <- list.map(variants)
        let Variant(record_name, fields) = variant
        let record_description =
          list.map(fields, fn(field) {
            let Field(field_name, typ) = field
            let assert Some(field_name) =
              option.or(field_name, Some("__none__"))
            "#(\"" <> field_name <> "\", " <> field_type(typ) <> ")"
          })
        let record_fields = string.join(record_description, ",")
        "#(\"" <> record_name <> "\"," <> "[" <> record_fields <> "])"
      }
      |> iterator.from_list
    })
    |> iterator.to_list

  simplifile.write(
    "./" <> root <> "/glerd_gen.gleam",
    "// this file was generated via \"gleam run -m glerd\"

    import glerd/types

    pub const record_info = [" <> string.join(records_info, ",\n") <> "]",
  )
}

fn field_type(typ) {
  case typ {
    NamedType(type_name, ..) if type_name == "String" -> "types.IsString"
    NamedType(type_name, ..) if type_name == "Int" -> "types.IsInt"
    NamedType(type_name, ..) if type_name == "Float" -> "types.IsFloat"
    NamedType(type_name, ..) if type_name == "Bool" -> "types.IsBool"
    NamedType(type_name, _, [typ]) if type_name == "List" ->
      "types.IsList(" <> field_type(typ) <> ")"
    NamedType(type_name, _, [key_type, val_type]) if type_name == "Dict" ->
      "types.IsDict("
      <> field_type(key_type)
      <> ","
      <> field_type(val_type)
      <> ")"
    NamedType(type_name, _, [typ]) if type_name == "Option" ->
      "types.IsOption(" <> field_type(typ) <> ")"
    NamedType(type_name, _, [typ1, typ2]) if type_name == "Result" ->
      "types.IsResult(" <> field_type(typ1) <> "," <> field_type(typ2) <> ")"
    TupleType([typ1, typ2]) ->
      "types.IsTuple2(" <> field_type(typ1) <> "," <> field_type(typ2) <> ")"
    TupleType([typ1, typ2, typ3]) ->
      "types.IsTuple3("
      <> field_type(typ1)
      <> ","
      <> field_type(typ2)
      <> ","
      <> field_type(typ3)
      <> ")"
    TupleType([typ1, typ2, typ3, typ4]) ->
      "types.IsTuple4("
      <> field_type(typ1)
      <> ","
      <> field_type(typ2)
      <> ","
      <> field_type(typ3)
      <> ","
      <> field_type(typ4)
      <> ")"
    TupleType([typ1, typ2, typ3, typ4, typ5]) ->
      "types.IsTuple5("
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
      "types.IsTuple6("
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
    NamedType(record_name, ..) -> "types.IsRecord(\"" <> record_name <> "\")"
    _ -> "types.Unknown"
  }
}
