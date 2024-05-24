pub type FieldType {
  IsString
  IsInt
  IsFloat
  IsBool
  IsList(FieldType)
  Unknown
}
