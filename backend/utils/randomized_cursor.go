package utils

import "math/rand"

// RandomizedCursor contains basic cursor data
type RandomizedCursor[K comparable] struct {
	Seed         *int64  `json:"seed"`
	RandomFactor float64 `json:"randomProportion"`
	CurrentIndex int     `json:"currentIndex"`
}

// NewRandomizedCursor creates a new cursor
func NewRandomizedCursor[K comparable](withSeed bool, randomFactor float64) *RandomizedCursor[K] {
	cursor := &RandomizedCursor[K]{
		RandomFactor: randomFactor,
	}
	if withSeed {
		seed := rand.Int63()
		cursor.Seed = &seed
	}
	return cursor
}

// Encode marshals to json and encodes to base64
func (c RandomizedCursor[K]) Encode() (string, error) {
	return MarshalAndBase64Encode(c)
}

// ParseRandomizedCursor decodes from base64 and will unmarshal from json
func ParseRandomizedCursor[K comparable](cursorString string) (*RandomizedCursor[K], error) {
	return Base64DecodeAndUnmarshal[RandomizedCursor[K]](cursorString)
}

// ApplyTo applies the cursor to a collection of keys
func (c RandomizedCursor[K]) ApplyTo(keys []K) []K {
	if len(keys) < c.CurrentIndex {
		return nil
	}

	slice := keys[c.CurrentIndex:]

	out := make([]K, 0, len(slice))
	for i := 0; i < len(slice); i++ {
		out = append(out, slice[i])
	}
	return out
}

// ApplyToSegments applies the cursor to segments of keys
func (c RandomizedCursor[K]) ApplyToSegments(segments []K, segmentLength int) []K {
	keys := c.ApplyTo(segments)
	if c.Seed != nil {
		keys = ShuffleSegmentedArray(keys, segmentLength, c.RandomFactor, *c.Seed)
	}
	return keys
}
