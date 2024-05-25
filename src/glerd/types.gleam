pub type FieldType(r) {
  IsString
  IsInt
  IsFloat
  IsBool
  IsList(FieldType(r))
  IsTuple2(FieldType(r), FieldType(r))
  IsTuple3(FieldType(r), FieldType(r), FieldType(r))
  IsTuple4(FieldType(r), FieldType(r), FieldType(r), FieldType(r))
  IsTuple5(FieldType(r), FieldType(r), FieldType(r), FieldType(r), FieldType(r))
  IsTuple6(
    FieldType(r),
    FieldType(r),
    FieldType(r),
    FieldType(r),
    FieldType(r),
    FieldType(r),
  )
  IsDict(FieldType(r), FieldType(r))
  IsOption(FieldType(r))
  IsResult(FieldType(r), FieldType(r))
  IsRecord(r)
}
