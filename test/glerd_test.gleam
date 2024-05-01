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

pub type WithResultPayload {
  WithResultPayload(res: Result(Int, String))
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
        "__record_keys",
        ["name", "num"]
          |> dynamic.from,
      ),
      #(
        "num",
        5
          |> dynamic.from,
      ),
      #(
        "name",
        "test"
          |> dynamic.from,
      ),
      #(
        "__record_name",
        "SimplePayload"
          |> dynamic.from,
      ),
    ]),
  )
}

pub fn record_to_dict_with_list_test() {
  WithListPayload([1, 2, 3])
  |> glerd.record_to_dict
  |> should.equal(
    dict.from_list([
      #(
        "__record_keys",
        ["list"]
          |> dynamic.from,
      ),
      #(
        "__record_name",
        "WithListPayload"
          |> dynamic.from,
      ),
      #(
        "list",
        [1, 2, 3]
          |> dynamic.from,
      ),
    ]),
  )
}

pub fn record_to_dict_with_nested_test() {
  NestedPayload(SimplePayload("test", 5))
  |> glerd.record_to_dict
  |> should.equal(
    dict.from_list([
      #(
        "__record_keys",
        ["nested"]
          |> dynamic.from,
      ),
      #(
        "nested",
        dict.from_list([
          #(
            "__record_keys",
            ["name", "num"]
              |> dynamic.from,
          ),
          #(
            "num",
            5
              |> dynamic.from,
          ),
          #(
            "name",
            "test"
              |> dynamic.from,
          ),
          #(
            "__record_name",
            "SimplePayload"
              |> dynamic.from,
          ),
        ])
          |> dynamic.from,
      ),
      #(
        "__record_name",
        "NestedPayload"
          |> dynamic.from,
      ),
    ]),
  )
}

pub fn record_to_dict_with_result_test() {
  WithResultPayload(Ok(1))
  |> glerd.record_to_dict
  |> should.equal(
    dict.from_list([
      #(
        "res",
        Ok(1)
          |> dynamic.from,
      ),
      #(
        "__record_keys",
        ["res"]
          |> dynamic.from,
      ),
      #(
        "__record_name",
        "WithResultPayload"
          |> dynamic.from,
      ),
    ]),
  )
}

pub fn record_to_dict_with_result_error_test() {
  WithResultPayload(Error("test"))
  |> glerd.record_to_dict
  |> should.equal(
    dict.from_list([
      #(
        "res",
        Error("test")
          |> dynamic.from,
      ),
      #(
        "__record_keys",
        ["res"]
          |> dynamic.from,
      ),
      #(
        "__record_name",
        "WithResultPayload"
          |> dynamic.from,
      ),
    ]),
  )
}
