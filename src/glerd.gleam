import gleam/bool
import gleam/erlang/atom
import gluple

@external(javascript, "./glerd_ffi.mjs", "isLikeRecord")
pub fn is_like_record(x: x) -> Bool {
  use <- bool.guard(gluple.is_tuple(x) == False, False)
  let assert Ok(size) = gluple.tuple_size(x)
  use <- bool.guard(size == 0, False)
  let assert Ok(el) = gluple.tuple_element(x, 0)
  case atom.from_dynamic(el) {
    Ok(atom) -> {
      let atom_name = atom.to_string(atom)
      !{ atom_name == "ok" || atom_name == "error" }
    }
    Error(_) -> False
  }
}
