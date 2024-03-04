package utils

import (
	"testing"

	"github.com/davecgh/go-spew/spew"
	"github.com/samber/lo"
	"github.com/stretchr/testify/assert"
)

func Test_ShuffleSegmentedArray(t *testing.T) {
	segments := [][]string{
		{
			"1",
			"2",
			"3",
		},
		{
			"4",
			"5",
			"6",
			"7",
			"8",
		},
		{
			"9",
		},
		{
			"10",
			"11",
		},
		{
			"12",
			"13",
			"14",
		},
	}
	arr := ShuffleSegmentedArray(segments, 5, 0, 0)

	assert.Equal(t, 14, len(lo.Uniq(arr)), "Should have 14 unique keys")

	first5 := arr[0:5]
	second5 := arr[5:10]

	spew.Dump(first5)
	spew.Dump(second5)
	spew.Dump(segments[2])

	assert.Equal(t, 3, len(lo.Intersect(segments[0], first5)), "The first 3 should be in the top 5")
	assert.Equal(t, 3, len(lo.Intersect(segments[1], second5)), "3 of the 3-8 should be in 5-10")
	assert.Equal(t, 1, len(lo.Intersect(segments[2], second5)), "9 should should be in 5-10")
}

func Test_ShuffleSegmentedArrayWithRandomEntries(t *testing.T) {
	segments := [][]string{
		{
			"1",
			"2",
			"3",
		},
		{
			"4",
			"5",
			"6",
			"7",
			"8",
		},
		{
			"9",
		},
		{
			"10",
			"11",
		},
		{
			"12",
			"13",
			"14",
		},
	}

	arr := ShuffleSegmentedArray(segments, 2, 1, 0)
	assert.Equal(t, 14, len(lo.Uniq(arr)), "Should have 14 unique keys")
}
