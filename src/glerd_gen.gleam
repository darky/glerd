// this file generated via "gleam run -m glerd"

import glerd_types

pub fn get_record_info(record_name) {
  case record_name {
    "IsString" -> []
    "IsInt" -> []
    "IsFloat" -> []
    "IsBool" -> []
    "IsList" -> [#("unknown", glerd_types.Unknown)]
    "Unknown" -> []
    "TestString" -> [#("name", glerd_types.IsString)]
    "TestInt" -> [#("age", glerd_types.IsInt)]
    "TestFloat" -> [#("distance", glerd_types.IsFloat)]
    "TestBool" -> [#("is_exists", glerd_types.IsBool)]
    "TestMultiple" -> [
      #("name", glerd_types.IsString),
      #("age", glerd_types.IsInt),
    ]
    "TestList" -> [#("names", glerd_types.IsList(glerd_types.IsString))]
    _ -> panic as { "Record not found " <> record_name }
  }
}
