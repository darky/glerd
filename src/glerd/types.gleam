pub type FieldType {
  IsString
  IsInt
  IsFloat
  IsBool
  IsNil
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
  IsFunction0(FieldType)
  IsFunction1(FieldType, FieldType)
  IsFunction2(FieldType, FieldType, FieldType)
  IsFunction3(FieldType, FieldType, FieldType, FieldType)
  IsFunction4(FieldType, FieldType, FieldType, FieldType, FieldType)
  IsFunction5(FieldType, FieldType, FieldType, FieldType, FieldType, FieldType)
  IsFunction6(
    FieldType,
    FieldType,
    FieldType,
    FieldType,
    FieldType,
    FieldType,
    FieldType,
  )
}
