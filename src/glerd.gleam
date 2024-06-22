import fswalk.{Entry, Stat}
import glance.{
  CustomType, Definition, Field, Module, NamedType, TupleType, Variant,
}
import gleam/dict.{type Dict}
import gleam/iterator
import gleam/list
import gleam/option.{Some}
import gleam/result
import gleam/string
import gleamyshell
import glexer.{type Position, Position}
import glexer/token.{CommentDoc, UpperName}
import gluple
import simplifile

type FilePath {
  FilePath(String)
}

type FileContent {
  FileContent(String)
}

type ModuleName {
  ModuleName(String)
}

type RecordName {
  RecordName(String)
}

type Meta {
  Meta(String)
}

type MetaDict {
  MetaDict(Dict(RecordName, Meta))
}

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
      FilePath(path)
    })
    |> iterator.map(fn(file_path) {
      let FilePath(path) = file_path
      let assert Ok(content) = simplifile.read(path)
      #(file_path, content |> FileContent)
    })
    |> iterator.map(fn(ctx) {
      let #(_, FileContent(content)) = ctx
      content
      |> glexer.new
      |> glexer.lex
      |> list.window_by_2
      |> list.fold(dict.new(), fn(meta_dict, pair) {
        case pair {
          #(
            #(CommentDoc(meta), Position(_)),
            #(UpperName(rec_name), Position(_)),
          ) ->
            dict.insert(
              meta_dict,
              rec_name |> RecordName,
              meta |> string.trim_left |> Meta,
            )
          _ -> meta_dict
        }
      })
      |> MetaDict
      |> gluple.append2(ctx, _)
    })
    |> iterator.map(fn(ctx) {
      let #(FilePath(path), _, _) = ctx
      path
      |> string.replace(root <> "/", "")
      |> string.replace(".gleam", "")
      |> ModuleName
      |> gluple.append3(ctx, _)
    })
    |> iterator.map(fn(ctx) {
      let #(_, FileContent(content), _, _) = ctx
      let assert Ok(module) = glance.module(content)
      let Module(_, custom_types_definitions, ..) = module
      {
        use custom_type_definition <- list.flat_map(custom_types_definitions)
        let Definition(_, custom_type) = custom_type_definition
        let CustomType(_, _, _, _, variants) = custom_type
        variants
      }
      |> gluple.append4(ctx, _)
    })
    |> iterator.map(fn(ctx) {
      let #(_, _, MetaDict(meta_dict), ModuleName(module_name), variants) = ctx
      use Variant(record_name, fields) <- list.map(variants)
      let fields =
        fields
        |> list.map(fn(field) {
          let Field(field_name, typ) = field
          let assert Some(field_name) = option.or(field_name, Some("__none__"))
          "#(\"" <> field_name <> "\", " <> field_type(typ) <> ")"
        })
        |> string.join(",")
      let assert Ok(Meta(meta)) =
        dict.get(meta_dict, record_name |> RecordName)
        |> result.or(Ok(Meta("")))
      "#(\""
      <> record_name
      <> "\",\""
      <> module_name
      <> "\","
      <> "["
      <> fields
      <> "],\""
      <> meta
      <> "\")"
    })
    |> iterator.flat_map(fn(record_code) { record_code |> iterator.from_list })
    |> iterator.fold("", fn(acc, record_code) { acc <> record_code <> ",\n" })

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
