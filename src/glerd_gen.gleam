// this file generated via "gleam run -m glerd"

import glerd_types

pub fn get_record_info(record_name) {
  case record_name {
    "IsString" -> []
    "IsInt" -> []
    "IsFloat" -> []
    "IsBool" -> []
    "IsList" -> [#("__none__", glerd_types.IsRecord("FieldType"))]
    "IsTuple2" -> [
      #("__none__", glerd_types.IsRecord("FieldType")),
      #("__none__", glerd_types.IsRecord("FieldType")),
    ]
    "IsTuple3" -> [
      #("__none__", glerd_types.IsRecord("FieldType")),
      #("__none__", glerd_types.IsRecord("FieldType")),
      #("__none__", glerd_types.IsRecord("FieldType")),
    ]
    "IsTuple4" -> [
      #("__none__", glerd_types.IsRecord("FieldType")),
      #("__none__", glerd_types.IsRecord("FieldType")),
      #("__none__", glerd_types.IsRecord("FieldType")),
      #("__none__", glerd_types.IsRecord("FieldType")),
    ]
    "IsTuple5" -> [
      #("__none__", glerd_types.IsRecord("FieldType")),
      #("__none__", glerd_types.IsRecord("FieldType")),
      #("__none__", glerd_types.IsRecord("FieldType")),
      #("__none__", glerd_types.IsRecord("FieldType")),
      #("__none__", glerd_types.IsRecord("FieldType")),
    ]
    "IsTuple6" -> [
      #("__none__", glerd_types.IsRecord("FieldType")),
      #("__none__", glerd_types.IsRecord("FieldType")),
      #("__none__", glerd_types.IsRecord("FieldType")),
      #("__none__", glerd_types.IsRecord("FieldType")),
      #("__none__", glerd_types.IsRecord("FieldType")),
      #("__none__", glerd_types.IsRecord("FieldType")),
    ]
    "IsDict" -> [
      #("__none__", glerd_types.IsRecord("FieldType")),
      #("__none__", glerd_types.IsRecord("FieldType")),
    ]
    "IsOption" -> [#("__none__", glerd_types.IsRecord("FieldType"))]
    "IsResult" -> [
      #("__none__", glerd_types.IsRecord("FieldType")),
      #("__none__", glerd_types.IsRecord("FieldType")),
    ]
    "IsRecord" -> [#("__none__", glerd_types.IsString)]
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
      #("dict", glerd_types.IsDict(glerd_types.IsString, glerd_types.IsInt)),
    ]
    "TestOption" -> [#("some_int", glerd_types.IsOption(glerd_types.IsInt))]
    "TestResult" -> [
      #(
        "result_field",
        glerd_types.IsResult(glerd_types.IsInt, glerd_types.IsString),
      ),
    ]
    "TestRecord" -> [#("nested", glerd_types.IsRecord("NestedRecord"))]
    "NestedRecord" -> [#("name", glerd_types.IsString)]
    _ -> panic as { "Record not found " <> record_name }
  }
}
