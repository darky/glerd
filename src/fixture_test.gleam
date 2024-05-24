import gleam/dict.{type Dict}
import gleam/option.{type Option}

pub type NestedRecord {
  NestedRecord(name: String)
}

pub type TestRecords {
  TestString(name: String)
  TestInt(age: Int)
  TestFloat(distance: Float)
  TestBool(is_exists: Bool)
  TestMultiple(name: String, age: Int)
  TestList(names: List(String))
  TestTuple2(str_or_int: #(String, Int))
  TestTuple3(str_or_int: #(String, Int, String))
  TestTuple4(str_or_int: #(String, Int, String, Int))
  TestTuple5(str_or_int: #(String, Int, String, Int, String))
  TestTuple6(str_or_int: #(String, Int, String, Int, String, Int))
  TestDict(dict: Dict(String, Int))
  TestOption(some_int: Option(Int))
  TestResult(result_field: Result(Int, String))
  TestRecord(nested: NestedRecord)
}
