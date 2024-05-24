// this file generated via "gleam run -m glerd"

import glerd_types

pub fn get_record_info(record_name) {
  case record_name {
    "IsString" -> []
    "IsInt" -> []
    "IsFloat" -> []
    "IsBool" -> []
    "IsList" -> [#("unknown", glerd_types.Unknown)]
    "IsTuple2" -> [
      #("unknown", glerd_types.Unknown),
      #("unknown", glerd_types.Unknown),
    ]
    "IsTuple3" -> [
      #("unknown", glerd_types.Unknown),
      #("unknown", glerd_types.Unknown),
      #("unknown", glerd_types.Unknown),
    ]
    "IsTuple4" -> [
      #("unknown", glerd_types.Unknown),
      #("unknown", glerd_types.Unknown),
      #("unknown", glerd_types.Unknown),
      #("unknown", glerd_types.Unknown),
    ]
    "IsTuple5" -> [
      #("unknown", glerd_types.Unknown),
      #("unknown", glerd_types.Unknown),
      #("unknown", glerd_types.Unknown),
      #("unknown", glerd_types.Unknown),
      #("unknown", glerd_types.Unknown),
    ]
    "IsTuple6" -> [
      #("unknown", glerd_types.Unknown),
      #("unknown", glerd_types.Unknown),
      #("unknown", glerd_types.Unknown),
      #("unknown", glerd_types.Unknown),
      #("unknown", glerd_types.Unknown),
      #("unknown", glerd_types.Unknown),
    ]
    "IsDict" -> [
      #("unknown", glerd_types.Unknown),
      #("unknown", glerd_types.Unknown),
    ]
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
    "TestTuple2" -> [
      #(
        "str_or_int",
        glerd_types.IsTuple2(glerd_types.IsString, glerd_types.IsInt),
      ),
    ]
    "TestTuple3" -> [
      #(
        "str_or_int",
        glerd_types.IsTuple3(
          glerd_types.IsString,
          glerd_types.IsInt,
          glerd_types.IsString,
        ),
      ),
    ]
    "TestTuple4" -> [
      #(
        "str_or_int",
        glerd_types.IsTuple4(
          glerd_types.IsString,
          glerd_types.IsInt,
          glerd_types.IsString,
          glerd_types.IsInt,
        ),
      ),
    ]
    "TestTuple5" -> [
      #(
        "str_or_int",
        glerd_types.IsTuple5(
          glerd_types.IsString,
          glerd_types.IsInt,
          glerd_types.IsString,
          glerd_types.IsInt,
          glerd_types.IsString,
        ),
      ),
    ]
    "TestTuple6" -> [
      #(
        "str_or_int",
        glerd_types.IsTuple6(
          glerd_types.IsString,
          glerd_types.IsInt,
          glerd_types.IsString,
          glerd_types.IsInt,
          glerd_types.IsString,
          glerd_types.IsInt,
        ),
      ),
    ]
    "TestDict" -> [
      #(
        "some_dict",
        glerd_types.IsDict(glerd_types.IsString, glerd_types.IsInt),
      ),
    ]
    _ -> panic as { "Record not found " <> record_name }
  }
}
