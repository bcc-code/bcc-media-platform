package utils

import (
	"github.com/samber/lo"
	"gopkg.in/guregu/null.v4"
	"strconv"
)

// PointerIntArrayToIntArray converts an array of int pointers to array of ints
func PointerIntArrayToIntArray(collection []*int) []int {
	return lo.Map(lo.Filter(collection, func(i *int, _ int) bool {
		return i != nil
	}), func(i *int, _ int) int {
		return *i
	})
}

// AsInt implies that the string exclusively contains an int
func AsInt(intString string) int {
	intID64, _ := strconv.ParseInt(intString, 10, 64)
	return int(intID64)
}

// MapAsInt is for usage in lo.Map
func MapAsInt(intString string, _ int) int {
	return AsInt(intString)
}

// MapAsIntegers is for usage in lo.Map
func MapAsIntegers(intStrings []string) []int {
	return lo.Map(intStrings, MapAsInt)
}

// AsIntOrNil returns an int or pointer
func AsIntOrNil(intString string) *int {
	i, err := strconv.ParseInt(intString, 10, 64)
	if err != nil {
		return nil
	}
	intI := int(i)
	return &intI
}

// AsNullInt implies that the pointer string should contain a number if not null
func AsNullInt(intString *string) null.Int {
	var i null.Int
	if intString != nil {
		if v := AsIntOrNil(*intString); v != nil {
			i.SetValid(int64(*v))
		}
	}
	return i
}
