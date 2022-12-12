package translations

// Translation contains data for a specific translation key
type Translation struct {
	Collection string
	ID         string
	Field      string
	Value      string
	Language   string
}

//// GetCollection returns collection
//func (t Translation) GetCollection() string {
//	return t.Collection
//}
//
//// GetKey returns Key
//func (t Translation) GetKey() string {
//	return t.ID
//}
//
//// GetLanguage returns language
//func (t Translation) GetLanguage() string {
//	return t.Language
//}
//
//// GetField returns field
//func (t Translation) GetField() string {
//	return t.Field
//}
//
//// GetValue returns value
//func (t Translation) GetValue() string {
//	return t.Value
//}
