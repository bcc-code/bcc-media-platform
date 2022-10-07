package utils

import "github.com/samber/lo"

// PointerIntArrayToIntArray converts an array of int pointers to array of ints
func PointerIntArrayToIntArray(collection []*int) []int {
	return lo.Map(lo.Filter(collection, func(i *int, _ int) bool {
		return i != nil
	}), func(i *int, _ int) int {
		return *i
	})
}
