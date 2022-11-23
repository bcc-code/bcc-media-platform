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

// AsNullInt implies that the pointer string should contain a number if not null
func AsNullInt(intString *string) null.Int {
	var i null.Int
	if intString != nil {
		i.SetValid(int64(AsInt(*intString)))
	}
	return i
}
