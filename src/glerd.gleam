import gleam/dict.{type Dict}

@external(javascript, "./glerd_ffi.mjs", "recordToDict")
pub fn record_to_dict(record: r) -> Dict(k, v)
