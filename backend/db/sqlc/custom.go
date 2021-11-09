package db

import "reflect"

func (q AdminMedia) GetFields() []reflect.StructField {
	val := reflect.ValueOf(q)
	var result []reflect.StructField
	for i := 0; i < val.Type().NumField(); i++ {
		result = append(result, val.Type().Field(i))
	}
	return result
}

func (q Asset) GetFields() []reflect.StructField {
	val := reflect.ValueOf(q)
	var result []reflect.StructField
	for i := 0; i < val.Type().NumField(); i++ {
		result = append(result, val.Type().Field(i))
	}
	return result
}

func GetFields(t reflect.Type) []reflect.StructField {
	var result []reflect.StructField
	for i := 0; i < t.NumField(); i++ {
		result = append(result, t.Field(i))
	}
	return result
}
