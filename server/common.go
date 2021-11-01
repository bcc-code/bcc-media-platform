package main

import "reflect"

type GetListQuery struct {
	Ids   []int  `form:"id"`
	Sort  string `form:"_sort"`
	Order string `form:"_order"`
}

func (q GetListQuery) GetFieldNames() []string {
	val := reflect.ValueOf(q)
	var result []string
	for i := 0; i < val.Type().NumField(); i++ {
		result = append(result, val.Type().Field(i).Tag.Get("form"))
	}
	return result
}
