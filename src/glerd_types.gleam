pub type FieldType {
  IsString
  IsInt
  IsFloat
  IsBool
  IsList(FieldType)
  IsTuple2(FieldType, FieldType)
  IsTuple3(FieldType, FieldType, FieldType)
  IsTuple4(FieldType, FieldType, FieldType, FieldType)
  IsTuple5(FieldType, FieldType, FieldType, FieldType, FieldType)
  IsTuple6(FieldType, FieldType, FieldType, FieldType, FieldType, FieldType)
  IsDict(FieldType, FieldType)
  IsOption(FieldType)
  IsResult(FieldType, FieldType)
  IsRecord(String)
  Unknown
}
