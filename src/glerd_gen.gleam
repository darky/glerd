// this file generated via "gleam run -m glerd"

pub type FieldType {
  IsString
  Unknown
}

pub fn get_record_info(name) {
  case name {
    "IsString" -> []
    "Unknown" -> []
    "TestString" -> [#("name", IsString)]
    _ -> panic as { "Record not found " <> name }
  }
}
