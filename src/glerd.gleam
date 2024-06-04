import act
import fswalk.{Entry, Stat}
import glance.{
  CustomType, Definition, Field, Module, NamedType, TupleType, Variant,
}
import gleam/iterator
import gleam/list
import gleam/option.{Some}
import gleam/string
import gleamyshell
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
    |> it_act_map(fn(path) {
      let assert Ok(content) = simplifile.read(path)
      content
    })
    |> it_act_map(fn(content) {
      let assert Ok(module) = glance.module(content)
      module
    })
    |> it_act_map(fn(module) {
      let Module(_, custom_types_definitions, ..) = module
      iterator.from_list(custom_types_definitions)
    })
    |> it_act_map(fn(it) {
      use custom_type_definition <- iterator.flat_map(it)
      let Definition(_, custom_type) = custom_type_definition
      let CustomType(_, _, _, _, variants) = custom_type
      iterator.from_list(variants)
    })
    |> iterator.flat_map(fn(action) {
      let #(m_name, it) = action("")
      use variant <- iterator.map(it)
      let Variant(r_name, fields) = variant
      let fields =
        fields
        |> list.map(fn(field) {
          let Field(field_name, typ) = field
          let assert Some(field_name) = option.or(field_name, Some("__none__"))
          "#(\"" <> field_name <> "\", " <> field_type(typ) <> ")"
        })
        |> string.join(",")
      "#(\"" <> r_name <> "\",\"" <> m_name <> "\"," <> "[" <> fields <> "])"
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

  let assert Ok(_) =
    gleamyshell.execute("gleam", ".", ["format", gen_file_path])

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
      "types.IsDict(" <> type_args([key_type, val_type]) <> ")"
    NamedType(type_name, _, [typ]) if type_name == "Option" ->
      "types.IsOption(" <> field_type(typ) <> ")"
    NamedType(type_name, _, [typ1, typ2]) if type_name == "Result" ->
      "types.IsResult(" <> type_args([typ1, typ2]) <> ")"
    TupleType([typ1, typ2]) ->
      "types.IsTuple2(" <> type_args([typ1, typ2]) <> ")"
    TupleType([typ1, typ2, typ3]) ->
      "types.IsTuple3(" <> type_args([typ1, typ2, typ3]) <> ")"
    TupleType([typ1, typ2, typ3, typ4]) ->
      "types.IsTuple4(" <> type_args([typ1, typ2, typ3, typ4]) <> ")"
    TupleType([typ1, typ2, typ3, typ4, typ5]) ->
      "types.IsTuple5(" <> type_args([typ1, typ2, typ3, typ4, typ5]) <> ")"
    TupleType([typ1, typ2, typ3, typ4, typ5, typ6]) ->
      "types.IsTuple6("
      <> type_args([typ1, typ2, typ3, typ4, typ5, typ6])
      <> ")"
    NamedType(record_name, ..) -> "types.IsRecord(\"" <> record_name <> "\")"
    _ -> "types.Unknown"
  }
}

fn type_args(types) {
  types
  |> list.map(field_type)
  |> list.intersperse(",")
  |> string.join("")
}

fn path_to_module_name(dir, path) {
  path
  |> string.replace(dir <> "/", "")
  |> string.replace(".gleam", "")
}

fn it_act_map(it, f) {
  use action <- iterator.map(it)
  use data <- act.map(action)
  data |> f
}
