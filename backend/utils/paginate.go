package utils

import "github.com/samber/lo"

var defaultFirst = 20

// PaginationResult contains the result of the pagination and the effective first & offset
type PaginationResult[t any] struct {
	Items  []t
	Total  int
	First  int
	Offset int
}

// Paginate a collection with specified parameters
func Paginate[t any](collection []t, first *int, offset *int) PaginationResult[t] {
	var result PaginationResult[t]
	result.Total = len(collection)
	if offset != nil {
		result.Offset = *offset
	}
	if first != nil {
		result.First = *first
	} else {
		result.First = defaultFirst
	}

	collection = lo.Filter(collection, func(_ t, index int) bool {
		return index >= result.Offset
	})
	collection = lo.Filter(collection, func(_ t, index int) bool {
		return index < result.First
	})
	result.Items = collection

	return result
}
