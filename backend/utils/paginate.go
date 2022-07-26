package utils

import "github.com/samber/lo"

// Paginate a collection with specified parameters
func Paginate[t any](collection []t, first *int, offset *int) []t {
	if offset != nil {
		collection = lo.Filter(collection, func(_ t, index int) bool {
			return index >= *offset
		})
	}
	if first != nil {
		collection = lo.Filter(collection, func(_ t, index int) bool {
			return index < *first
		})
	}
	return collection
}
