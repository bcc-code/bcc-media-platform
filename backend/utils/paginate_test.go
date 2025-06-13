package utils

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestPaginate_DefaultParameters(t *testing.T) {
	collection := []int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
	result := Paginate(collection, nil, nil, nil)

	assert.Equal(t, 10, result.Total)
	assert.Equal(t, 20, result.First)         // default first
	assert.Equal(t, 0, result.Offset)         // default offset
	assert.Equal(t, collection, result.Items) // all items since first=20 > collection size
}

func TestPaginate_WithFirst(t *testing.T) {
	collection := []int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
	first := 5
	result := Paginate(collection, &first, nil, nil)

	assert.Equal(t, 10, result.Total)
	assert.Equal(t, 5, result.First)
	assert.Equal(t, 0, result.Offset)
	assert.Equal(t, []int{1, 2, 3, 4, 5}, result.Items)
}

func TestPaginate_WithOffset(t *testing.T) {
	collection := []int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
	offset := 3
	result := Paginate(collection, nil, &offset, nil)

	assert.Equal(t, 10, result.Total)
	assert.Equal(t, 20, result.First) // default first
	assert.Equal(t, 3, result.Offset)
	assert.Equal(t, []int{4, 5, 6, 7, 8, 9, 10}, result.Items) // items from index 3 onwards
}

func TestPaginate_WithFirstAndOffset(t *testing.T) {
	collection := []int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
	first := 3
	offset := 2
	result := Paginate(collection, &first, &offset, nil)

	assert.Equal(t, 10, result.Total)
	assert.Equal(t, 3, result.First)
	assert.Equal(t, 2, result.Offset)
	assert.Equal(t, []int{3, 4, 5}, result.Items) // 3 items starting from index 2
}

func TestPaginate_WithDirection_Asc(t *testing.T) {
	collection := []int{1, 2, 3, 4, 5}
	dir := "asc"
	result := Paginate(collection, nil, nil, &dir)

	assert.Equal(t, 5, result.Total)
	assert.Equal(t, []int{1, 2, 3, 4, 5}, result.Items) // original order
}

func TestPaginate_WithDirection_Desc(t *testing.T) {
	collection := []int{1, 2, 3, 4, 5}
	dir := "desc"
	result := Paginate(collection, nil, nil, &dir)

	assert.Equal(t, 5, result.Total)
	assert.Equal(t, []int{5, 4, 3, 2, 1}, result.Items) // reversed order
}

func TestPaginate_WithDirection_DescCaseInsensitive(t *testing.T) {
	collection := []string{"a", "b", "c", "d"}
	dir := "DESC"
	result := Paginate(collection, nil, nil, &dir)

	assert.Equal(t, 4, result.Total)
	assert.Equal(t, []string{"d", "c", "b", "a"}, result.Items) // reversed order
}

func TestPaginate_WithAllParameters(t *testing.T) {
	collection := []int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
	first := 3
	offset := 2
	dir := "desc"
	result := Paginate(collection, &first, &offset, &dir)

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
	result := Paginate(collection, nil, nil, nil)

	assert.Equal(t, 0, result.Total)
	assert.Equal(t, 20, result.First) // default first
	assert.Equal(t, 0, result.Offset)
	assert.Equal(t, []int{}, result.Items)
}

func TestPaginate_OffsetBeyondCollection(t *testing.T) {
	collection := []int{1, 2, 3}
	offset := 10
	result := Paginate(collection, nil, &offset, nil)

	assert.Equal(t, 3, result.Total)
	assert.Equal(t, 10, result.Offset)
	assert.Equal(t, []int{}, result.Items) // no items since offset > collection size
}

func TestPaginate_FirstZero(t *testing.T) {
	collection := []int{1, 2, 3, 4, 5}
	first := 0
	result := Paginate(collection, &first, nil, nil)

	assert.Equal(t, 5, result.Total)
	assert.Equal(t, 0, result.First)
	assert.Equal(t, []int{}, result.Items) // no items since first=0
}

func TestPaginate_StringCollection(t *testing.T) {
	collection := []string{"apple", "banana", "cherry", "date", "elderberry"}
	first := 3
	offset := 1
	result := Paginate(collection, &first, &offset, nil)

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
	result := Paginate(collection, &first, &offset, nil)

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
	result := Paginate(collection, &first, &offset, nil)
	assert.Equal(t, 100, result.Total)
	assert.Equal(t, 10, result.First)
	assert.Equal(t, 0, result.Offset)
	assert.Equal(t, []int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}, result.Items)

	// Page 2: next 10 items
	offset = 10
	result = Paginate(collection, &first, &offset, nil)
	assert.Equal(t, 100, result.Total)
	assert.Equal(t, 10, result.First)
	assert.Equal(t, 10, result.Offset)
	assert.Equal(t, []int{11, 12, 13, 14, 15, 16, 17, 18, 19, 20}, result.Items)

	// Last page: remaining items
	offset = 95
	result = Paginate(collection, &first, &offset, nil)
	assert.Equal(t, 100, result.Total)
	assert.Equal(t, 10, result.First)
	assert.Equal(t, 95, result.Offset)
	assert.Equal(t, []int{96, 97, 98, 99, 100}, result.Items) // only 5 items left
}
