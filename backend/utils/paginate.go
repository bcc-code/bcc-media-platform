package utils

import (
	"github.com/samber/lo"
	"strings"
)

var defaultFirst = 20

// PaginationResult contains the result of the pagination and the effective first & offset
type PaginationResult[t any] struct {
	Items  []t
	Total  int
	First  int
	Offset int
}

// Paginate a collection with specified parameters
func Paginate[t any](collection []t, first *int, offset *int, dir *string) PaginationResult[t] {
	arr := collection
	var result PaginationResult[t]
	result.Total = len(arr)
	if offset != nil {
		result.Offset = *offset
	}
	if first != nil {
		result.First = *first
	} else {
		result.First = defaultFirst
	}

	if dir != nil {
		if strings.ToLower(*dir) == "desc" {
			arr = lo.Reverse(arr)
		}
	}

	arr = lo.Filter(arr, func(_ t, index int) bool {
		return index >= result.Offset
	})
	arr = lo.Filter(arr, func(_ t, index int) bool {
		return index < result.First
	})
	result.Items = arr

	return result
}
