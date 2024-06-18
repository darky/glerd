import fswalk.{Entry, Stat}
import functx
import glance.{
  CustomType, Definition, Field, Module, NamedType, TupleType, Variant,
}
import gleam/iterator
import gleam/list
import gleam/option.{Some}
import gleam/pair
import gleam/result
import gleam/string
import gleamyshell
import glexer.{type Position, Position}
import glexer/token.{CommentDoc, UpperName}
import simplifile

type Context {
  Context(root: String, path: String)
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
    |> iterator.flat_map(fn(entry_result) {
      let assert Ok(Entry(path, _)) = entry_result
      Context(root, path)
      |> functx.make_ctx
      |> ast_to_code
      |> pair.first
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

fn ast_to_code(ctx) {
  use lexems, ctx <- functx.call(ctx, lexems_from_content)
  use m, ctx <- functx.call(ctx, module_name_from_path)
  use variants, ctx <- functx.call(ctx, ast_from_content)
  let code = {
    use Variant(r, fields) <- list.map(variants)
    let f = normalize_fields(fields)
    let mt = lexems_to_meta(r, lexems)
    "#(\"" <> r <> "\",\"" <> m <> "\"," <> "[" <> f <> "],\"" <> mt <> "\")"
  }
  #(code, ctx)
}

fn lexems_from_content(ctx) {
  use content, ctx <- functx.call(ctx, content_from_path)
  let lexems = content |> glexer.new |> glexer.lex
  #(lexems, ctx)
}

fn module_name_from_path(ctx) {
  let #(Context(dir, path), _) = ctx
  let module_name =
    path
    |> string.replace(dir <> "/", "")
    |> string.replace(".gleam", "")
  #(module_name, ctx)
}

fn ast_from_content(ctx) {
  use content, ctx <- functx.call(ctx, content_from_path)
  let assert Ok(module) = glance.module(content)
  let Module(_, custom_types_definitions, ..) = module
  let variants = {
    use custom_type_definition <- list.flat_map(custom_types_definitions)
    let Definition(_, custom_type) = custom_type_definition
    let CustomType(_, _, _, _, variants) = custom_type
    variants
  }
  #(variants, ctx)
}

fn content_from_path(ctx) {
  let #(Context(_, path), _) = ctx
  let assert Ok(content) = simplifile.read(path)
  #(content, ctx)
}

fn lexems_to_meta(record_name, lexems) {
  let assert Ok(meta) =
    lexems
    |> list.window_by_2
    |> list.find_map(fn(pair) {
      case pair {
        #(#(CommentDoc(meta), Position(_)), #(UpperName(rec_name), Position(_)))
          if rec_name == record_name
        -> Ok(meta)
        _ -> Error(Nil)
      }
    })
    |> result.or(Ok(""))
    |> result.map(fn(s) { s |> string.trim_left })
  meta
}

fn normalize_fields(fields) {
  fields
  |> list.map(fn(field) {
    let Field(field_name, typ) = field
    let assert Some(field_name) = option.or(field_name, Some("__none__"))
    "#(\"" <> field_name <> "\", " <> field_type(typ) <> ")"
  })
  |> string.join(",")
}
