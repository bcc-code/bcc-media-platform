package utils

import (
	"github.com/samber/lo"
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
func AsInt(idString string) int {
	intID64, _ := strconv.ParseInt(idString, 10, 64)
	return int(intID64)
}
