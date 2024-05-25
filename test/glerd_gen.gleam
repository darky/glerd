// this file was generated via "gleam run -m glerd"

import glerd/types

pub type RecordKey {
  TestString
  TestInt
  TestFloat
  TestBool
  TestMultiple
  TestList
  TestTuple2
  TestTuple3
  TestTuple4
  TestTuple5
  TestTuple6
  TestDict
  TestOption
  TestResult
  TestRecord
  NestedRecord
}

pub fn get_record_info(record_key) {
  case record_key {
    TestString -> [#("name", types.IsString)]
    TestInt -> [#("age", types.IsInt)]
    TestFloat -> [#("distance", types.IsFloat)]
    TestBool -> [#("is_exists", types.IsBool)]
    TestMultiple -> [#("name", types.IsString), #("age", types.IsInt)]
    TestList -> [#("names", types.IsList(types.IsString))]
    TestTuple2 -> [#("str_or_int", types.IsTuple2(types.IsString, types.IsInt))]
    TestTuple3 -> [
      #(
        "str_or_int",
        types.IsTuple3(types.IsString, types.IsInt, types.IsString),
      ),
    ]
    TestTuple4 -> [
      #(
        "str_or_int",
        types.IsTuple4(types.IsString, types.IsInt, types.IsString, types.IsInt),
      ),
    ]
    TestTuple5 -> [
      #(
        "str_or_int",
        types.IsTuple5(
          types.IsString,
          types.IsInt,
          types.IsString,
          types.IsInt,
          types.IsString,
        ),
      ),
    ]
    TestTuple6 -> [
      #(
        "str_or_int",
        types.IsTuple6(
          types.IsString,
          types.IsInt,
          types.IsString,
          types.IsInt,
          types.IsString,
          types.IsInt,
        ),
      ),
    ]
    TestDict -> [#("dict", types.IsDict(types.IsString, types.IsInt))]
    TestOption -> [#("some_int", types.IsOption(types.IsInt))]
    TestResult -> [
      #("result_field", types.IsResult(types.IsInt, types.IsString)),
    ]
    TestRecord -> [#("nested", types.IsRecord(NestedRecord))]
    NestedRecord -> [#("name", types.IsString)]
  }
}
