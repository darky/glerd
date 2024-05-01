import gleam/dict
import gleam/dynamic
import gleeunit
import gleeunit/should
import glerd

pub type SimplePayload {
  SimplePayload(name: String, num: Int)
}

pub type WithListPayload {
  WithListPayload(list: List(Int))
}

pub type NestedPayload {
  NestedPayload(nested: SimplePayload)
}

pub fn main() {
  gleeunit.main()
}

pub fn record_to_dict_simple_test() {
  SimplePayload("test", 5)
  |> glerd.record_to_dict
  |> should.equal(
    dict.from_list([
      #(
        "name",
        "test"
          |> dynamic.from,
      ),
      #(
        "num",
        5
          |> dynamic.from,
      ),
    ]),
  )
}

pub fn record_to_dict_with_list_test() {
  WithListPayload([1, 2, 3])
  |> glerd.record_to_dict
  |> should.equal(dict.from_list([#("list", [1, 2, 3])]))
}

pub fn record_to_dict_with_nested_test() {
  NestedPayload(SimplePayload("test", 5))
  |> glerd.record_to_dict
  |> should.equal(
    dict.from_list([
      #(
        "nested",
        dict.from_list([
          #(
            "name",
            "test"
              |> dynamic.from,
          ),
          #(
            "num",
            5
              |> dynamic.from,
          ),
        ]),
      ),
    ]),
  )
}
