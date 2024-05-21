import gleeunit
import gleeunit/should
import glerd

pub type RecordTest {
  RecordTest(name: String)
}

pub fn main() {
  gleeunit.main()
}

pub fn is_like_record_test() {
  glerd.is_like_record(RecordTest("test"))
  |> should.equal(True)
}

pub fn ok_not_like_record_test() {
  glerd.is_like_record(Ok("test"))
  |> should.equal(False)
}

pub fn error_not_like_record_test() {
  glerd.is_like_record(Error("test"))
  |> should.equal(False)
}
