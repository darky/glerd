// this file was generated via "gleam run -m glerd"

import glerd/types

pub type RecordKey {
  FixtureTestTestString
  FixtureTestTestInt
  FixtureTestTestFloat
  FixtureTestTestBool
  FixtureTestTestMultiple
  FixtureTestTestList
  FixtureTestTestTuple2
  FixtureTestTestTuple3
  FixtureTestTestTuple4
  FixtureTestTestTuple5
  FixtureTestTestTuple6
  FixtureTestTestDict
  FixtureTestTestOption
  FixtureTestTestResult
  FixtureTestTestRecord
  FixtureTestNestedRecord
}

pub fn get_record_info(record_key) {
  case record_key {
    FixtureTestTestString -> [#("name", types.IsString)]
    FixtureTestTestInt -> [#("age", types.IsInt)]
    FixtureTestTestFloat -> [#("distance", types.IsFloat)]
    FixtureTestTestBool -> [#("is_exists", types.IsBool)]
    FixtureTestTestMultiple -> [
      #("name", types.IsString),
      #("age", types.IsInt),
    ]
    FixtureTestTestList -> [#("names", types.IsList(types.IsString))]
    FixtureTestTestTuple2 -> [
      #("str_or_int", types.IsTuple2(types.IsString, types.IsInt)),
    ]
    FixtureTestTestTuple3 -> [
      #(
        "str_or_int",
        types.IsTuple3(types.IsString, types.IsInt, types.IsString),
      ),
    ]
    FixtureTestTestTuple4 -> [
      #(
        "str_or_int",
        types.IsTuple4(types.IsString, types.IsInt, types.IsString, types.IsInt),
      ),
    ]
    FixtureTestTestTuple5 -> [
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
    FixtureTestTestTuple6 -> [
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
    FixtureTestTestDict -> [
      #("dict", types.IsDict(types.IsString, types.IsInt)),
    ]
    FixtureTestTestOption -> [#("some_int", types.IsOption(types.IsInt))]
    FixtureTestTestResult -> [
      #("result_field", types.IsResult(types.IsInt, types.IsString)),
    ]
    FixtureTestTestRecord -> [#("nested", types.IsRecord("NestedRecord"))]
    FixtureTestNestedRecord -> [#("name", types.IsString)]
  }
}
