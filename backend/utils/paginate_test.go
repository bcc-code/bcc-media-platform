package utils

import (
	"github.com/bcc-code/bcc-media-platform/backend/cursors"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestPaginate_DefaultParameters(t *testing.T) {
	collection := []int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
	result := Paginate[int, *cursors.OffsetCursor](collection, nil, nil, nil, nil)

	assert.Equal(t, 10, result.Total)
	assert.Equal(t, 20, result.First)         // default first
	assert.Equal(t, 0, result.Offset)         // default offset
	assert.Equal(t, collection, result.Items) // all items since first=20 > collection size
}

func TestPaginate_WithFirst(t *testing.T) {
	collection := []int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
	first := 5
	result := Paginate[int, *cursors.OffsetCursor](collection, &first, nil, nil, nil)

	assert.Equal(t, 10, result.Total)
	assert.Equal(t, 5, result.First)
	assert.Equal(t, 0, result.Offset)
	assert.Equal(t, []int{1, 2, 3, 4, 5}, result.Items)
}

func TestPaginate_WithOffset(t *testing.T) {
	collection := []int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
	offset := 3
	result := Paginate[int, *cursors.OffsetCursor](collection, nil, &offset, nil, nil)

	assert.Equal(t, 10, result.Total)
	assert.Equal(t, 20, result.First) // default first
	assert.Equal(t, 3, result.Offset)
	assert.Equal(t, []int{4, 5, 6, 7, 8, 9, 10}, result.Items) // items from index 3 onwards
}

func TestPaginate_WithFirstAndOffset(t *testing.T) {
	collection := []int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
	first := 3
	offset := 2
	result := Paginate[int, *cursors.OffsetCursor](collection, &first, &offset, nil, nil)

	assert.Equal(t, 10, result.Total)
	assert.Equal(t, 3, result.First)
	assert.Equal(t, 2, result.Offset)
	assert.Equal(t, []int{3, 4, 5}, result.Items) // 3 items starting from index 2
}

func TestPaginate_WithDirection_Asc(t *testing.T) {
	collection := []int{1, 2, 3, 4, 5}
	dir := "asc"
	result := Paginate[int, *cursors.OffsetCursor](collection, nil, nil, &dir, nil)

	assert.Equal(t, 5, result.Total)
	assert.Equal(t, []int{1, 2, 3, 4, 5}, result.Items) // original order
}

func TestPaginate_WithDirection_Desc(t *testing.T) {
	collection := []int{1, 2, 3, 4, 5}
	dir := "desc"
	result := Paginate[int, *cursors.OffsetCursor](collection, nil, nil, &dir, nil)

	assert.Equal(t, 5, result.Total)
	assert.Equal(t, []int{5, 4, 3, 2, 1}, result.Items) // reversed order
}

func TestPaginate_WithDirection_DescCaseInsensitive(t *testing.T) {
	collection := []string{"a", "b", "c", "d"}
	dir := "DESC"
	result := Paginate[string, *cursors.OffsetCursor](collection, nil, nil, &dir, nil)

	assert.Equal(t, 4, result.Total)
	assert.Equal(t, []string{"d", "c", "b", "a"}, result.Items) // reversed order
}

func TestPaginate_WithAllParameters(t *testing.T) {
	collection := []int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
	first := 3
	offset := 2
	dir := "desc"
	result := Paginate[int, *cursors.OffsetCursor](collection, &first, &offset, &dir, nil)

	assert.Equal(t, 10, result.Total)
	assert.Equal(t, 3, result.First)
	assert.Equal(t, 2, result.Offset)
	// Collection reversed: [10, 9, 8, 7, 6, 5, 4, 3, 2, 1]
	// Skip 2 (offset): [8, 7, 6, 5, 4, 3, 2, 1]
	// Take 3 (first): [8, 7, 6]
	assert.Equal(t, []int{8, 7, 6}, result.Items)
}

func TestPaginate_EmptyCollection(t *testing.T) {
	collection := []int{}
	result := Paginate[int, *cursors.OffsetCursor](collection, nil, nil, nil, nil)

	assert.Equal(t, 0, result.Total)
	assert.Equal(t, 20, result.First) // default first
	assert.Equal(t, 0, result.Offset)
	assert.Equal(t, []int{}, result.Items)
}

func TestPaginate_OffsetBeyondCollection(t *testing.T) {
	collection := []int{1, 2, 3}
	offset := 10
	result := Paginate[int, *cursors.OffsetCursor](collection, nil, &offset, nil, nil)

	assert.Equal(t, 3, result.Total)
	assert.Equal(t, 10, result.Offset)
	assert.Equal(t, []int{}, result.Items) // no items since offset > collection size
}

func TestPaginate_FirstZero(t *testing.T) {
	collection := []int{1, 2, 3, 4, 5}
	first := 0
	result := Paginate[int, *cursors.OffsetCursor](collection, &first, nil, nil, nil)

	assert.Equal(t, 5, result.Total)
	assert.Equal(t, 0, result.First)
	assert.Equal(t, []int{}, result.Items) // no items since first=0
}

func TestPaginate_StringCollection(t *testing.T) {
	collection := []string{"apple", "banana", "cherry", "date", "elderberry"}
	first := 3
	offset := 1
	result := Paginate[string, *cursors.OffsetCursor](collection, &first, &offset, nil, nil)

	assert.Equal(t, 5, result.Total)
	assert.Equal(t, 3, result.First)
	assert.Equal(t, 1, result.Offset)
	assert.Equal(t, []string{"banana", "cherry", "date"}, result.Items)
}

func TestPaginate_StructCollection(t *testing.T) {
	type Person struct {
		Name string
		Age  int
	}

	collection := []Person{
		{Name: "Alice", Age: 25},
		{Name: "Bob", Age: 30},
		{Name: "Charlie", Age: 35},
		{Name: "Diana", Age: 40},
	}

	first := 2
	offset := 1
	result := Paginate[Person, *cursors.OffsetCursor](collection, &first, &offset, nil, nil)

	assert.Equal(t, 4, result.Total)
	assert.Equal(t, 2, result.First)
	assert.Equal(t, 1, result.Offset)
	expected := []Person{
		{Name: "Bob", Age: 30},
		{Name: "Charlie", Age: 35},
	}
	assert.Equal(t, expected, result.Items)
}

func TestPaginate_Integration(t *testing.T) {
	// Test a realistic pagination scenario
	collection := make([]int, 100) // Create collection of 100 items
	for i := 0; i < 100; i++ {
		collection[i] = i + 1
	}

	// Page 1: first 10 items
	first := 10
	offset := 0
	result := Paginate[int, *cursors.OffsetCursor](collection, &first, &offset, nil, nil)
	assert.Equal(t, 100, result.Total)
	assert.Equal(t, 10, result.First)
	assert.Equal(t, 0, result.Offset)
	assert.Equal(t, []int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}, result.Items)

	// Page 2: next 10 items
	offset = 10
	result = Paginate[int, *cursors.OffsetCursor](collection, &first, &offset, nil, nil)
	assert.Equal(t, 100, result.Total)
	assert.Equal(t, 10, result.First)
	assert.Equal(t, 10, result.Offset)
	assert.Equal(t, []int{11, 12, 13, 14, 15, 16, 17, 18, 19, 20}, result.Items)

	// Last page: remaining items
	offset = 95
	result = Paginate[int, *cursors.OffsetCursor](collection, &first, &offset, nil, nil)
	assert.Equal(t, 100, result.Total)
	assert.Equal(t, 10, result.First)
	assert.Equal(t, 95, result.Offset)
	assert.Equal(t, []int{96, 97, 98, 99, 100}, result.Items) // only 5 items left
}

// OffsetCursor-specific tests
func TestPaginate_WithOffsetCursor(t *testing.T) {
	collection := []int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
	cursor := cursors.NewOffsetCursor(3)
	result := Paginate[int, *cursors.OffsetCursor](collection, nil, nil, nil, cursor)

	assert.Equal(t, 10, result.Total)
	assert.Equal(t, 20, result.First)                          // default first
	assert.Equal(t, 3, result.Offset)                          // from cursor
	assert.Equal(t, []int{4, 5, 6, 7, 8, 9, 10}, result.Items) // items from cursor offset
}

func TestPaginate_WithOffsetCursorAndFirst(t *testing.T) {
	collection := []int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
	cursor := cursors.NewOffsetCursor(2)
	first := 4
	result := Paginate[int, *cursors.OffsetCursor](collection, &first, nil, nil, cursor)

	assert.Equal(t, 10, result.Total)
	assert.Equal(t, 4, result.First)
	assert.Equal(t, 2, result.Offset)                // from cursor
	assert.Equal(t, []int{3, 4, 5, 6}, result.Items) // 4 items starting from cursor offset
}

func TestPaginate_CursorAndOffset(t *testing.T) {
	collection := []int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
	cursor := cursors.NewOffsetCursor(5)
	offset := 2 // this should be ignored
	first := 3
	result := Paginate[int, *cursors.OffsetCursor](collection, &first, &offset, nil, cursor)

	assert.Equal(t, 10, result.Total)
	assert.Equal(t, 3, result.First)
	assert.Equal(t, 2, result.Offset)             // cursor takes precedence over offset
	assert.Equal(t, []int{3, 4, 5}, result.Items) // uses cursor offset, not offset param
}

func TestPaginate_WithOffsetCursorAndDirection(t *testing.T) {
	collection := []int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
	cursor := cursors.NewOffsetCursor(2)
	first := 3
	dir := "desc"
	result := Paginate[int, *cursors.OffsetCursor](collection, &first, nil, &dir, cursor)

	assert.Equal(t, 10, result.Total)
	assert.Equal(t, 3, result.First)
	assert.Equal(t, 2, result.Offset)
	assert.Equal(t, []int{8, 7, 6}, result.Items)
}

func TestPaginate_WithZeroOffsetCursor(t *testing.T) {
	collection := []int{1, 2, 3, 4, 5}
	cursor := cursors.NewOffsetCursor(0)
	first := 3
	result := Paginate[int, *cursors.OffsetCursor](collection, &first, nil, nil, cursor)

	assert.Equal(t, 5, result.Total)
	assert.Equal(t, 3, result.First)
	assert.Equal(t, 0, result.Offset) // from cursor
	assert.Equal(t, []int{1, 2, 3}, result.Items)
}

func TestPaginate_WithOffsetCursorBeyondCollection(t *testing.T) {
	collection := []int{1, 2, 3}
	cursor := cursors.NewOffsetCursor(10)
	result := Paginate[int, *cursors.OffsetCursor](collection, nil, nil, nil, cursor)

	assert.Equal(t, 3, result.Total)
	assert.Equal(t, 10, result.Offset)     // from cursor
	assert.Equal(t, []int{}, result.Items) // no items since cursor offset > collection size
}

func TestPaginate_OffsetCursorStringCollection(t *testing.T) {
	collection := []string{"apple", "banana", "cherry", "date", "elderberry"}
	cursor := cursors.NewOffsetCursor(1)
	first := 3
	result := Paginate[string, *cursors.OffsetCursor](collection, &first, nil, nil, cursor)

	assert.Equal(t, 5, result.Total)
	assert.Equal(t, 3, result.First)
	assert.Equal(t, 1, result.Offset) // from cursor
	assert.Equal(t, []string{"banana", "cherry", "date"}, result.Items)
}

func TestPaginate_WithTypedNilCursor(t *testing.T) {
	collection := []int{1, 2, 3, 4, 5}

	// Create a typed nil cursor - this is different from a nil interface
	var typedNilCursor *cursors.OffsetCursor = nil

	assert.Panics(t, func() {
		Paginate[int, *cursors.OffsetCursor](collection, nil, nil, nil, typedNilCursor)
	})
}

func TestPaginate_OffsetCursorIntegration(t *testing.T) {
	// Test realistic cursor-based pagination workflow
	collection := make([]int, 50) // Create collection of 50 items
	for i := 0; i < 50; i++ {
		collection[i] = i + 1
	}

	// Page 1: first 10 items using cursor
	cursor := cursors.NewOffsetCursor(0)
	first := 10
	result := Paginate[int, *cursors.OffsetCursor](collection, &first, nil, nil, cursor)
	assert.Equal(t, 50, result.Total)
	assert.Equal(t, 10, result.First)
	assert.Equal(t, 0, result.Offset)
	assert.Equal(t, []int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}, result.Items)

	// Page 2: next 10 items using cursor
	cursor = cursors.NewOffsetCursor(10)
	result = Paginate[int, *cursors.OffsetCursor](collection, &first, nil, nil, cursor)
	assert.Equal(t, 50, result.Total)
	assert.Equal(t, 10, result.First)
	assert.Equal(t, 10, result.Offset)
	assert.Equal(t, []int{11, 12, 13, 14, 15, 16, 17, 18, 19, 20}, result.Items)

	// Page 3: next 10 items using cursor
	cursor = cursors.NewOffsetCursor(20)
	result = Paginate[int, *cursors.OffsetCursor](collection, &first, nil, nil, cursor)
	assert.Equal(t, 50, result.Total)
	assert.Equal(t, 10, result.First)
	assert.Equal(t, 20, result.Offset)
	assert.Equal(t, []int{21, 22, 23, 24, 25, 26, 27, 28, 29, 30}, result.Items)

	// Last page: remaining items using cursor
	cursor = cursors.NewOffsetCursor(45)
	result = Paginate[int, *cursors.OffsetCursor](collection, &first, nil, nil, cursor)
	assert.Equal(t, 50, result.Total)
	assert.Equal(t, 10, result.First)
	assert.Equal(t, 45, result.Offset)
	assert.Equal(t, []int{46, 47, 48, 49, 50}, result.Items) // only 5 items left
}

// Tests for new cursor-related fields
func TestPaginate_CursorFields_FirstPage(t *testing.T) {
	collection := []int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
	first := 3
	result := Paginate[int, *cursors.OffsetCursor](collection, &first, nil, nil, nil)

	// Verify cursor fields for first page
	assert.NotNil(t, result.Cursor)
	assert.Equal(t, 0, result.Cursor.(*cursors.OffsetCursor).GetOffset())
	assert.False(t, result.HasPrevious) // first page has no previous
	assert.True(t, result.HasNext)      // more items available
	assert.NotNil(t, result.NextCursor)
	assert.Equal(t, 3, result.NextCursor.(*cursors.OffsetCursor).GetOffset()) // next page starts at offset 3
}

func TestPaginate_CursorFields_MiddlePage(t *testing.T) {
	collection := []int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
	first := 3
	offset := 3
	result := Paginate[int, *cursors.OffsetCursor](collection, &first, &offset, nil, nil)

	// Verify cursor fields for middle page
	assert.NotNil(t, result.Cursor)
	assert.Equal(t, 3, result.Cursor.(*cursors.OffsetCursor).GetOffset())
	assert.True(t, result.HasPrevious) // has previous pages
	assert.True(t, result.HasNext)     // has next pages
	assert.NotNil(t, result.NextCursor)
	assert.Equal(t, "eyJvZmZzZXQiOjZ9", result.NextCursor.Encode()) // next page starts at offset 6
}

func TestPaginate_CursorFields_LastPage(t *testing.T) {
	collection := []int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
	first := 3
	offset := 8 // last page with only 2 items
	result := Paginate[int, *cursors.OffsetCursor](collection, &first, &offset, nil, nil)

	// Verify cursor fields for last page
	assert.NotNil(t, result.Cursor)
	assert.Equal(t, "eyJvZmZzZXQiOjh9", result.Cursor.Encode())
	assert.True(t, result.HasPrevious) // has previous pages
	assert.False(t, result.HasNext)    // no more items available
	assert.Equal(t, "eyJvZmZzZXQiOjEwfQ==", result.NextCursor.Encode())
}

func TestPaginate_CursorFields_SinglePage(t *testing.T) {
	collection := []int{1, 2, 3}
	first := 10 // more than collection size
	result := Paginate[int, *cursors.OffsetCursor](collection, &first, nil, nil, nil)

	// Verify cursor fields for single page (all items fit)
	assert.NotNil(t, result.Cursor)
	assert.Equal(t, "eyJvZmZzZXQiOjB9", result.Cursor.Encode())
	assert.False(t, result.HasPrevious)                             // no previous pages
	assert.False(t, result.HasNext)                                 // no next pages
	assert.Equal(t, "eyJvZmZzZXQiOjN9", result.NextCursor.Encode()) // no next cursor
}

func TestPaginate_CursorFields_EmptyResult(t *testing.T) {
	collection := []int{1, 2, 3}
	offset := 10 // beyond collection
	result := Paginate[int, *cursors.OffsetCursor](collection, nil, &offset, nil, nil)

	// Verify cursor fields for empty result
	assert.NotNil(t, result.Cursor)
	assert.Equal(t, "eyJvZmZzZXQiOjEwfQ==", result.Cursor.Encode())
	assert.True(t, result.HasPrevious)                                    // offset > 0 means has previous
	assert.False(t, result.HasNext)                                       // no items returned, no next
	assert.Equal(t, &cursors.OffsetCursor{Offset: 10}, result.NextCursor) // no next cursor
}

func TestPaginate_CursorFields_WithOffsetCursor(t *testing.T) {
	collection := []int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
	cursor := cursors.NewOffsetCursor(4)
	first := 3
	result := Paginate[int, *cursors.OffsetCursor](collection, &first, nil, nil, cursor)

	// Verify cursor fields when using OffsetCursor
	assert.NotNil(t, result.Cursor)
	assert.Equal(t, "eyJvZmZzZXQiOjR9", result.Cursor.Encode()) // matches input cursor
	assert.True(t, result.HasPrevious)                          // offset > 0
	assert.True(t, result.HasNext)                              // more items available
	assert.NotNil(t, result.NextCursor)
	assert.Equal(t, "eyJvZmZzZXQiOjd9", result.NextCursor.Encode()) // next page starts at offset 7
}
