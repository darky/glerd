// this file was generated via "gleam run -m glerd"

import glerd/types

pub const record_info = [
  #("TestString", "fixture_test", [#("name", types.IsString)]),
  #("TestInt", "fixture_test", [#("age", types.IsInt)]),
  #("TestFloat", "fixture_test", [#("distance", types.IsFloat)]),
  #("TestBool", "fixture_test", [#("is_exists", types.IsBool)]),
  #(
    "TestMultiple",
    "fixture_test",
    [#("name", types.IsString), #("age", types.IsInt)],
  ), #("TestList", "fixture_test", [#("names", types.IsList(types.IsString))]),
  #(
    "TestTuple2",
    "fixture_test",
    [#("str_or_int", types.IsTuple2(types.IsString, types.IsInt))],
  ),
  #(
    "TestTuple3",
    "fixture_test",
    [
      #(
        "str_or_int",
        types.IsTuple3(types.IsString, types.IsInt, types.IsString),
      ),
    ],
  ),
  #(
    "TestTuple4",
    "fixture_test",
    [
      #(
        "str_or_int",
        types.IsTuple4(types.IsString, types.IsInt, types.IsString, types.IsInt),
      ),
    ],
  ),
  #(
    "TestTuple5",
    "fixture_test",
    [
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
    ],
  ),
  #(
    "TestTuple6",
    "fixture_test",
    [
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
    ],
  ),
  #(
    "TestDict",
    "fixture_test",
    [#("dict", types.IsDict(types.IsString, types.IsInt))],
  ),
  #("TestOption", "fixture_test", [#("some_int", types.IsOption(types.IsInt))]),
  #(
    "TestResult",
    "fixture_test",
    [#("result_field", types.IsResult(types.IsInt, types.IsString))],
  ),
  #("TestRecord", "fixture_test", [#("nested", types.IsRecord("NestedRecord"))]),
  #("TestWithoutFieldName", "fixture_test", [#("__none__", types.IsString)]),
  #("NestedRecord", "fixture_test", [#("name", types.IsString)]),
]
