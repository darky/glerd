// this file generated via "gleam run -m glerd"
import types

pub fn get_record_info(name) {
  case name {
    "IsString" -> []
    "IsInt" -> []
    "IsFloat" -> []
    "IsBool" -> []
    "Unknown" -> []
    "TestString" -> [#("name", types.IsString)]
    "TestInt" -> [#("age", types.IsInt)]
    "TestFloat" -> [#("distance", types.IsFloat)]
    "TestBool" -> [#("is_exists", types.IsBool)]
    "TestMultiple" -> [#("name", types.IsString), #("age", types.IsInt)]
    _ -> panic as { "Record not found " <> name }
  }
}
