import act
import fswalk.{Entry, Stat}
import glance.{
  CustomType, Definition, Field, Module, NamedType, TupleType, Variant,
}
import gleam/erlang/charlist.{type Charlist}
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
      fn(_ctx) { #(path_to_module_name(root, path), path) }
    })
    |> iterator.map(fn(action) {
      use path <- act.map(action)
      let assert Ok(content) = simplifile.read(path)
      content
    })
    |> iterator.map(fn(action) {
      use content <- act.map(action)
      let assert Ok(module) = glance.module(content)
      module
    })
    |> iterator.map(fn(action) {
      use module <- act.map(action)
      let Module(_, custom_types_definitions, ..) = module
      custom_types_definitions
    })
    |> iterator.flat_map(fn(action) {
      {
        let #(m_name, custom_type_definitions) = action("")
        use custom_type_definition <- list.flat_map(custom_type_definitions)
        let Definition(_, custom_type) = custom_type_definition
        let CustomType(_, _, _, _, variants) = custom_type
        use variant <- list.map(variants)
        let Variant(r_name, fields) = variant
        let record_description =
          list.map(fields, fn(field) {
            let Field(field_name, typ) = field
            let assert Some(field_name) =
              option.or(field_name, Some("__none__"))
            "#(\"" <> field_name <> "\", " <> field_type(typ) <> ")"
          })
        let fields = string.join(record_description, ",")
        "#(\"" <> r_name <> "\",\"" <> m_name <> "\"," <> "[" <> fields <> "])"
      }
      |> iterator.from_list
    })
    |> iterator.fold("", fn(acc, el) { acc <> el <> ",\n" })

  let gen_file_path = "./" <> root <> "/glerd_gen.gleam"

  let assert Ok(_) =
    simplifile.write(
      gen_file_path,
      "// this file was generated via \"gleam run -m glerd\"

      import glerd/types

      pub const record_info = [" <> records_info <> "]",
    )

  charlist.from_string("gleam format " <> gen_file_path)
  |> run_shell

  Nil
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
}

@external(erlang, "os", "cmd")
fn run_shell(command: Charlist) -> Charlist
