package main

import (
	"net/url"
	"reflect"
	"strings"

	"gopkg.in/guregu/null.v4"

	db "go.bcc.media/brunstadtv/db/sqlc"
)

type GetListQuery struct {
	Ids     []int    `form:"id"`
	SearchQ string   `form:"q"`
	Sort    string   `form:"_sort"`
	Order   string   `form:"_order"`
	Start   null.Int `form:"_start"`
	End     null.Int `form:"_end"`
}

func (q GetListQuery) GetFieldNames() []string {
	val := reflect.ValueOf(q)
	var result []string
	for i := 0; i < val.Type().NumField(); i++ {
		result = append(result, val.Type().Field(i).Tag.Get("form"))
	}
	return result
}

func GetUnhandledParams(q url.Values) (result []string) {
	fieldNames := GetListQuery{}.GetFieldNames()
outerLoop:
	for key := range q {
		for _, fieldName := range fieldNames {
			if key[0] == '_' || strings.EqualFold(fieldName, key) {
				continue outerLoop
			}
		}
		result = append(result, key)
	}
	return result
}

func JsonToDbName(t reflect.Type, json string) string {
	fields := db.GetFields(t)
	for _, field := range fields {
		if !strings.EqualFold(json, field.Tag.Get("json")) {
			continue
		}
		col := field.Tag.Get("db")
		if col != "" {
			return col
		}
	}
	return ""
}
