import fswalk.{Entry, Stat}
import glance.{
  CustomType, Definition, FunctionType, LabelledVariantField, Module, NamedType,
  TupleType, UnlabelledVariantField, Variant,
}
import gleam/deque
import gleam/dict.{type Dict}
import gleam/list
import gleam/pair
import gleam/result
import gleam/string
import gleam/yielder
import gleamyshell
import glexer.{Position}
import glexer/token.{CommentDoc, UpperName}
import gluple/addition as ga
import gluple/removal as gr
import simplifile

type FilePath {
  FilePath(val: String)
}

type FileContent {
  FileContent(val: String)
}

type ModuleName {
  ModuleName(val: String)
}

type RecordName {
  RecordName(val: String)
}

type Meta {
  Meta(val: String)
}

type MetaDict {
  MetaDict(val: Dict(RecordName, Meta))
}

pub fn main() {
  generate("src")
}

pub fn generate(root) {
  let records_info =
    fswalk.builder()
    |> fswalk.with_path(root)
    |> fswalk.walk()
    |> yielder.filter(fn(entry_result) {
      case entry_result {
        Ok(Entry(path, Stat(is_dir))) ->
          is_dir == False
          && string.ends_with(path, ".gleam")
          && !string.contains(path, "glerd_gen.gleam")
        _ -> False
      }
    })
    |> yielder.map(fn(entry_result) {
      let assert Ok(Entry(path, _)) = entry_result
      FilePath(path)
    })
    |> yielder.map(fn(file_path) {
      let assert Ok(content) = file_path.val |> simplifile.read
      #(file_path, content |> FileContent)
    })
    |> yielder.map(fn(ctx) {
      use file_path, _ <- ga.with_append2(ctx)
      file_path.val
      |> string.replace(root <> "/", "")
      |> string.replace(".gleam", "")
      |> ModuleName
    })
    |> yielder.map(fn(ctx) { ctx |> gr.remove_first3 })
    |> yielder.map(fn(ctx) {
      use file_content, _ <- ga.with_append2(ctx)
      file_content.val
      |> glexer.new
      |> glexer.lex
      |> list.fold(#(deque.new(), dict.new()), fn(acc, lexem) {
        let #(meta_batch, meta_final) = acc
        let meta_batch_is_empty = deque.is_empty(meta_batch)
        case lexem {
          #(CommentDoc(meta), Position(_)) -> {
            #(meta_batch |> deque.push_back(meta |> string.trim), meta_final)
          }
          #(UpperName(rec_name), Position(_)) if !meta_batch_is_empty -> {
            #(
              deque.new(),
              dict.insert(
                meta_final,
                rec_name |> RecordName,
                meta_batch |> stringify_queue("") |> string.trim |> Meta,
              ),
            )
          }
          _ -> #(meta_batch, meta_final)
        }
      })
      |> pair.second
      |> MetaDict
    })
    |> yielder.map(fn(ctx) {
      use file_content, _, _ <- ga.with_append3(ctx)
      let assert Ok(module) = file_content.val |> glance.module
      let Module(_, custom_types_definitions, ..) = module
      use custom_type_definition <- list.flat_map(custom_types_definitions)
      let Definition(_, custom_type) = custom_type_definition
      let CustomType(_, _, _, _, _, variants) = custom_type
      variants
    })
    |> yielder.map(fn(ctx) { ctx |> gr.remove_first4 })
    |> yielder.map(fn(ctx) {
      let #(module_name, meta_dict, variants) = ctx
      use Variant(record_name, fields, _attrs) <- list.map(variants)
      let fields =
        fields
        |> list.map(fn(field) {
          let #(field_name, typ) = case field {
            LabelledVariantField(typ, field_name) -> #(field_name, typ)
            UnlabelledVariantField(typ) -> #("__none__", typ)
          }
          "#(\"" <> field_name <> "\", " <> field_type(typ) <> ")"
        })
        |> string.join(",")
      let assert Ok(Meta(meta)) =
        dict.get(meta_dict.val, record_name |> RecordName)
        |> result.or(Ok(Meta("")))
      "#(\""
      <> record_name
      <> "\",\""
      <> module_name.val
      <> "\","
      <> "["
      <> fields
      <> "],\""
      <> meta
      <> "\")"
    })
    |> yielder.flat_map(fn(record_code) { record_code |> yielder.from_list })
    |> yielder.fold("", fn(acc, record_code) { acc <> record_code <> ",\n" })

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
    NamedType(_, type_name, ..) if type_name == "String" -> "types.IsString"
    NamedType(_, type_name, ..) if type_name == "Int" -> "types.IsInt"
    NamedType(_, type_name, ..) if type_name == "Float" -> "types.IsFloat"
    NamedType(_, type_name, ..) if type_name == "Bool" -> "types.IsBool"
    NamedType(_, type_name, ..) if type_name == "Nil" -> "types.IsNil"
    NamedType(_, type_name, _, [typ]) if type_name == "List" ->
      "types.IsList(" <> field_type(typ) <> ")"
    NamedType(_, type_name, _, [key_type, val_type]) if type_name == "Dict" ->
      "types.IsDict(" <> type_args([key_type, val_type]) <> ")"
    NamedType(_, type_name, _, [typ]) if type_name == "Option" ->
      "types.IsOption(" <> field_type(typ) <> ")"
    NamedType(_, type_name, _, [typ1, typ2]) if type_name == "Result" ->
      "types.IsResult(" <> type_args([typ1, typ2]) <> ")"
    TupleType(_, [typ1, typ2]) ->
      "types.IsTuple2(" <> type_args([typ1, typ2]) <> ")"
    TupleType(_, [typ1, typ2, typ3]) ->
      "types.IsTuple3(" <> type_args([typ1, typ2, typ3]) <> ")"
    TupleType(_, [typ1, typ2, typ3, typ4]) ->
      "types.IsTuple4(" <> type_args([typ1, typ2, typ3, typ4]) <> ")"
    TupleType(_, [typ1, typ2, typ3, typ4, typ5]) ->
      "types.IsTuple5(" <> type_args([typ1, typ2, typ3, typ4, typ5]) <> ")"
    TupleType(_, [typ1, typ2, typ3, typ4, typ5, typ6]) ->
      "types.IsTuple6("
      <> type_args([typ1, typ2, typ3, typ4, typ5, typ6])
      <> ")"
    NamedType(_, record_name, ..) -> "types.IsRecord(\"" <> record_name <> "\")"
    FunctionType(_, [], return) ->
      "types.IsFunction0(" <> type_args([return]) <> ")"
    FunctionType(_, [typ1], return) ->
      "types.IsFunction1(" <> type_args([typ1, return]) <> ")"
    FunctionType(_, [typ1, typ2], return) ->
      "types.IsFunction2(" <> type_args([typ1, typ2, return]) <> ")"
    FunctionType(_, [typ1, typ2, typ3], return) ->
      "types.IsFunction3(" <> type_args([typ1, typ2, typ3, return]) <> ")"
    FunctionType(_, [typ1, typ2, typ3, typ4], return) ->
      "types.IsFunction4(" <> type_args([typ1, typ2, typ3, typ4, return]) <> ")"
    FunctionType(_, [typ1, typ2, typ3, typ4, typ5], return) ->
      "types.IsFunction5("
      <> type_args([typ1, typ2, typ3, typ4, typ5, return])
      <> ")"
    FunctionType(_, [typ1, typ2, typ3, typ4, typ5, typ6], return) ->
      "types.IsFunction6("
      <> type_args([typ1, typ2, typ3, typ4, typ5, typ6, return])
      <> ")"
    _ -> {
      "types.Unknown"
    }
  }
}

fn type_args(types) {
  types
  |> list.map(field_type)
  |> list.intersperse(",")
  |> string.join("")
}

fn stringify_queue(que, str) {
  case que |> deque.pop_front {
    Ok(#(el, que)) -> stringify_queue(que, str <> " " <> el)
    Error(Nil) -> str
  }
}
