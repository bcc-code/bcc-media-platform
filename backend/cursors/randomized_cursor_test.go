package cursors

import (
	"testing"

	"github.com/google/uuid"
	"github.com/stretchr/testify/assert"
)

func TestApplyCursor(t *testing.T) {

	data := []uuid.UUID{
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-000000000001"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-000000000002"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-000000000003"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-000000000004"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-000000000005"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-000000000006"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-000000000007"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-000000000008"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-000000000009"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-000000000010"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-000000000011"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-000000000012"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-000000000013"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-000000000014"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-000000000015"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-000000000016"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-000000000017"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-000000000018"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-000000000019"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-000000000020"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-100000000001"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-100000000002"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-100000000003"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-100000000004"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-100000000005"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-100000000006"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-100000000007"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-100000000008"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-100000000009"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-100000000010"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-100000000011"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-100000000012"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-100000000013"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-100000000014"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-100000000015"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-100000000016"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-100000000017"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-100000000018"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-100000000019"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-100000000020"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-200000000001"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-200000000002"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-200000000003"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-200000000004"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-200000000005"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-200000000006"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-200000000007"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-200000000008"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-200000000009"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-200000000010"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-200000000011"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-200000000012"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-200000000013"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-200000000014"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-200000000015"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-200000000016"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-200000000017"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-200000000018"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-200000000019"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-200000000020"),
	}

	seed := int64(999999999999999999)
	c := RandomizedCursor{
		CurrentIndex: 5,
		Seed:         &seed,
	}

	data2 := ApplyRandomizedCursorToSegments(c, data, 5)
	assert.Len(t, data2, 60-c.CurrentIndex)

	for i := 0; i < c.CurrentIndex; i++ {
		assert.NotContains(t, data2, data[i])
	}
}

func TestApplyCursorWithRandomness(t *testing.T) {

	data := []uuid.UUID{
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-000000000001"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-000000000002"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-000000000003"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-000000000004"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-000000000005"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-000000000006"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-000000000007"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-000000000008"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-000000000009"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-000000000010"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-000000000011"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-000000000012"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-000000000013"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-000000000014"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-000000000015"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-000000000016"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-000000000017"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-000000000018"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-000000000019"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-000000000020"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-100000000001"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-100000000002"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-100000000003"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-100000000004"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-100000000005"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-100000000006"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-100000000007"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-100000000008"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-100000000009"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-100000000010"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-100000000011"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-100000000012"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-100000000013"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-100000000014"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-100000000015"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-100000000016"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-100000000017"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-100000000018"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-100000000019"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-100000000020"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-200000000001"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-200000000002"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-200000000003"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-200000000004"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-200000000005"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-200000000006"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-200000000007"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-200000000008"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-200000000009"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-200000000010"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-200000000011"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-200000000012"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-200000000013"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-200000000014"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-200000000015"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-200000000016"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-200000000017"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-200000000018"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-200000000019"),
		uuid.MustParse("622ce6e6-1cf4-44ed-b506-200000000020"),
	}

	seed := int64(999999999999999999)
	randomFactor := 1.0
	segmentSize := 20

	c := RandomizedCursor{
		CurrentIndex: segmentSize,
		Seed:         &seed,
		RandomFactor: randomFactor,
	}

	data2 := ApplyRandomizedCursorToSegments(c, data, segmentSize)
	assert.Len(t, data2, 60-c.CurrentIndex)

	for i := 0; i < c.CurrentIndex; i++ {
		assert.NotContains(t, data2, data[i])
	}
}
