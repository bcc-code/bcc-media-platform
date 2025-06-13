package utils

import (
	"github.com/samber/lo"
	"strings"
)

var defaultFirst = 20

// PaginationResult contains the result of the pagination and the effective first & offset
type PaginationResult[t any] struct {
	Items       []t
	Total       int
	First       int
	Offset      int
	Cursor      *OffsetCursor
	NextCursor  *OffsetCursor
	HasNext     bool
	HasPrevious bool
}

// Paginate a collection with specified parameters
func Paginate[t any](collection []t, first *int, offset *int, dir *string, cursor *OffsetCursor) PaginationResult[t] {
	var arr []t
	for _, v := range collection {
		arr = append(arr, v)
	}
	var result PaginationResult[t]
	result.Total = len(arr)

	// Handle cursor vs offset precedence - cursor takes priority
	if cursor != nil {
		result.Offset = cursor.Offset
	} else if offset != nil {
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

	// Apply pagination with slice
	result.Items = arr[min(result.Offset, len(arr)):min(result.Offset+result.First, len(arr))]
	if result.Items == nil {
		result.Items = []t{}
	}

	// Populate cursor-related fields
	result.Cursor = NewOffsetCursor(result.Offset)

	// Calculate HasNext: there are more items beyond current page
	result.HasNext = result.Offset+len(result.Items) < result.Total

	// Calculate HasPrevious: current offset is greater than 0
	result.HasPrevious = result.Offset > 0

	nextOffset := result.Offset + len(result.Items)
	result.NextCursor = NewOffsetCursor(nextOffset)

	return result
}
