// this file generated via "gleam run -m glerd"
import types

pub fn get_record_info(name) {
  case name {
    "IsString" -> []
    "IsInt" -> []
    "Unknown" -> []
    "TestString" -> [#("name", types.IsString)]
    "TestInt" -> [#("age", types.IsInt)]
    _ -> panic as { "Record not found " <> name }
  }
}
