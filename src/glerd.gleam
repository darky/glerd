import act
import fswalk.{Entry, Stat}
import glance.{
  CustomType, Definition, Field, Module, NamedType, TupleType, Variant,
}
import gleam/iterator
import gleam/list
import gleam/option.{Some}
import gleam/string
import justin
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
      fn(_ctx) { #(path_to_module_name("src", path), path) }
    })
    |> iterator.map(fn(action) {
      use path <- act.do(action)
      let assert Ok(content) = simplifile.read(path)
      act.return(content)
    })
    |> iterator.map(fn(action) {
      use content <- act.do(action)
      let assert Ok(module) = glance.module(content)
      act.return(module)
    })
    |> iterator.map(fn(action) {
      use module <- act.do(action)
      let Module(_, custom_types_definitions, ..) = module
      act.return(custom_types_definitions)
    })
    |> iterator.flat_map(fn(action) {
      let #(module_name, custom_type_definitions) = action("")
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
        let record_name = module_name <> record_name
        "\"" <> record_name <> "\"" <> " -> " <> "[" <> record_fields <> "]"
      }
      |> iterator.from_list
    })
    |> iterator.to_list
  let records_info = string.join(records_info, "\n")

  { "// this file was generated via \"gleam run -m glerd\"

    import glerd/types

    pub fn get_record_info(record_name) {
      case record_name {" <> records_info <> "_ -> panic as {\"Record not found \" <> record_name}}}" }
  |> simplifile.write("./src/glerd_gen.gleam", _)
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

fn path_to_module_name(dir, path) {
  path
  |> string.replace(dir <> "/", "")
  |> string.replace(".gleam", "")
  |> string.replace("/", "_")
  |> justin.pascal_case
}
