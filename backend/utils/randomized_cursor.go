package utils

import (
	"github.com/bcc-code/bcc-media-platform/backend/log"
	"math/rand"
)

// RandomizedCursor contains basic cursor data
type RandomizedCursor struct {
	Seed         *int64  `json:"seed"`
	RandomFactor float64 `json:"randomProportion"`
	CurrentIndex int     `json:"currentIndex"`
}

// NewRandomizedCursor creates a new cursor
func NewRandomizedCursor(withSeed bool, randomFactor float64) *RandomizedCursor {
	cursor := &RandomizedCursor{
		RandomFactor: randomFactor,
	}
	if withSeed {
		seed := rand.Int63()
		cursor.Seed = &seed
	}
	return cursor
}

// Encode marshals to json and encodes to base64
func (c RandomizedCursor) Encode() string {
	str, err := MarshalAndBase64Encode(c)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to encode randomized cursor")
		return ""
	}
	return str
}

// ParseRandomizedCursor decodes from base64 and will unmarshal from json
func ParseRandomizedCursor(cursorString string) (*RandomizedCursor, error) {
	return Base64DecodeAndUnmarshal[RandomizedCursor](cursorString)
}

// ApplyRandomizedCursorTo applies the cursor to a collection of keys
func ApplyRandomizedCursorTo[K comparable](cursor RandomizedCursor, keys []K) []K {
	if len(keys) < cursor.CurrentIndex {
		return nil
	}

	slice := keys[cursor.CurrentIndex:]

	out := make([]K, 0, len(slice))
	for i := 0; i < len(slice); i++ {
		out = append(out, slice[i])
	}
	return out
}

// ApplyRandomizedCursorToSegments applies the cursor to segments of keys
func ApplyRandomizedCursorToSegments[K comparable](cursor RandomizedCursor, segments []K, segmentLength int) []K {
	keys := ApplyRandomizedCursorTo(cursor, segments)
	if cursor.Seed != nil {
		keys = ShuffleSegmentedArray(keys, segmentLength, cursor.RandomFactor, *cursor.Seed)
	}
	return keys
}
