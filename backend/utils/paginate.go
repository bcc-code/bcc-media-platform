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
	Cursor      Cursor
	NextCursor  Cursor
	HasNext     bool
	HasPrevious bool
}

type Cursor interface {
	Encode() string
}

type CursorWithOffset[T Cursor] interface {
	GetOffset() int
	NewWithOffset(offset int) T
	Encode() string
}

// Paginate performs pagination on a collection of items with support for both offset-based and cursor-based pagination.
// It returns a PaginationResult containing the paginated items and metadata about the pagination state.
//
// Behavior:
//   - Cursor-based pagination takes precedence over offset-based pagination when both are provided
//   - If no pagination parameters are provided, defaults to first 20 items
//   - The function is safe to use with nil slices (returns empty result)
//   - Handles out-of-bounds offsets gracefully
//
// Example (offset-based):
//
//	result := Paginate(items, ptr(10), ptr(20), nil, nil)
//	// Returns items 20-29 (inclusive) from the collection
//
// Example (cursor-based):
//
//	cursor := ParseOffsetCursor("eyJvZmZzZXQiOjIwfQ==")
//	result := Paginate(items, ptr(10), nil, nil, cursor)
//	// Returns next 10 items starting from the cursor position
func Paginate[t any, c Cursor](collection []t, first *int, offset *int, dir *string, cursor CursorWithOffset[c]) PaginationResult[t] {
	var arr []t
	for _, v := range collection {
		arr = append(arr, v)
	}
	var result PaginationResult[t]
	result.Total = len(arr)

	// Handle cursor vs offset precedence - cursor takes priority
	if cursor != nil {
		result.Offset = cursor.GetOffset()
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

	if cursor != nil {
		// Populate cursor-related fields
		result.Cursor = cursor
	} else {
		result.Cursor = NewOffsetCursor(result.Offset)
	}

	// Calculate HasNext: there are more items beyond current page
	result.HasNext = result.Offset+len(result.Items) < result.Total

	// Calculate HasPrevious: current offset is greater than 0
	result.HasPrevious = result.Offset > 0

	nextOffset := result.Offset + len(result.Items)

	if cursor != nil {
		result.NextCursor = cursor.NewWithOffset(nextOffset)
	} else {
		result.NextCursor = NewOffsetCursor(nextOffset)
	}

	return result
}
