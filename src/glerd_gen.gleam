// this file was generated via "gleam run -m glerd"

import glerd_types

pub fn get_record_info(record_name) {
  case record_name {
    "GlerdTypesIsString" -> []
    "GlerdTypesIsInt" -> []
    "GlerdTypesIsFloat" -> []
    "GlerdTypesIsBool" -> []
    "GlerdTypesIsList" -> [#("__none__", glerd_types.IsRecord("FieldType"))]
    "GlerdTypesIsTuple2" -> [
      #("__none__", glerd_types.IsRecord("FieldType")),
      #("__none__", glerd_types.IsRecord("FieldType")),
    ]
    "GlerdTypesIsTuple3" -> [
      #("__none__", glerd_types.IsRecord("FieldType")),
      #("__none__", glerd_types.IsRecord("FieldType")),
      #("__none__", glerd_types.IsRecord("FieldType")),
    ]
    "GlerdTypesIsTuple4" -> [
      #("__none__", glerd_types.IsRecord("FieldType")),
      #("__none__", glerd_types.IsRecord("FieldType")),
      #("__none__", glerd_types.IsRecord("FieldType")),
      #("__none__", glerd_types.IsRecord("FieldType")),
    ]
    "GlerdTypesIsTuple5" -> [
      #("__none__", glerd_types.IsRecord("FieldType")),
      #("__none__", glerd_types.IsRecord("FieldType")),
      #("__none__", glerd_types.IsRecord("FieldType")),
      #("__none__", glerd_types.IsRecord("FieldType")),
      #("__none__", glerd_types.IsRecord("FieldType")),
    ]
    "GlerdTypesIsTuple6" -> [
      #("__none__", glerd_types.IsRecord("FieldType")),
      #("__none__", glerd_types.IsRecord("FieldType")),
      #("__none__", glerd_types.IsRecord("FieldType")),
      #("__none__", glerd_types.IsRecord("FieldType")),
      #("__none__", glerd_types.IsRecord("FieldType")),
      #("__none__", glerd_types.IsRecord("FieldType")),
    ]
    "GlerdTypesIsDict" -> [
      #("__none__", glerd_types.IsRecord("FieldType")),
      #("__none__", glerd_types.IsRecord("FieldType")),
    ]
    "GlerdTypesIsOption" -> [#("__none__", glerd_types.IsRecord("FieldType"))]
    "GlerdTypesIsResult" -> [
      #("__none__", glerd_types.IsRecord("FieldType")),
      #("__none__", glerd_types.IsRecord("FieldType")),
    ]
    "GlerdTypesIsRecord" -> [#("__none__", glerd_types.IsString)]
    "GlerdTypesUnknown" -> []
    "FixtureTestTestString" -> [#("name", glerd_types.IsString)]
    "FixtureTestTestInt" -> [#("age", glerd_types.IsInt)]
    "FixtureTestTestFloat" -> [#("distance", glerd_types.IsFloat)]
    "FixtureTestTestBool" -> [#("is_exists", glerd_types.IsBool)]
    "FixtureTestTestMultiple" -> [
      #("name", glerd_types.IsString),
      #("age", glerd_types.IsInt),
    ]
    "FixtureTestTestList" -> [
      #("names", glerd_types.IsList(glerd_types.IsString)),
    ]
    "FixtureTestTestTuple2" -> [
      #(
        "str_or_int",
        glerd_types.IsTuple2(glerd_types.IsString, glerd_types.IsInt),
      ),
    ]
    "FixtureTestTestTuple3" -> [
      #(
        "str_or_int",
        glerd_types.IsTuple3(
          glerd_types.IsString,
          glerd_types.IsInt,
          glerd_types.IsString,
        ),
      ),
    ]
    "FixtureTestTestTuple4" -> [
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
    "FixtureTestTestTuple5" -> [
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
    "FixtureTestTestTuple6" -> [
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
    "FixtureTestTestDict" -> [
      #("dict", glerd_types.IsDict(glerd_types.IsString, glerd_types.IsInt)),
    ]
    "FixtureTestTestOption" -> [
      #("some_int", glerd_types.IsOption(glerd_types.IsInt)),
    ]
    "FixtureTestTestResult" -> [
      #(
        "result_field",
        glerd_types.IsResult(glerd_types.IsInt, glerd_types.IsString),
      ),
    ]
    "FixtureTestTestRecord" -> [
      #("nested", glerd_types.IsRecord("NestedRecord")),
    ]
    "FixtureTestNestedRecord" -> [#("name", glerd_types.IsString)]
    _ -> panic as { "Record not found " <> record_name }
  }
}
