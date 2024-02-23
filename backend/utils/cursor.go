package utils

import (
	"math/rand"

	"github.com/samber/lo"
)

// Cursor contains basic cursor data
type Cursor[K comparable] struct {
	Seed         *int64  `json:"seed"`
	RandomFactor float64 `json:"randomProportion"`
	CurrentIndex int     `json:"currentIndex"`
}

// NewCursor creates a new cursor
func NewCursor[K comparable](withSeed bool, randomFactor float64) *Cursor[K] {
	cursor := &Cursor[K]{
		RandomFactor: randomFactor,
	}
	if withSeed {
		seed := rand.Int63()
		cursor.Seed = &seed
	}
	return cursor
}

// Encode marshals to json and encodes to base64
func (c Cursor[K]) Encode() (string, error) {
	return MarshalAndBase64Encode(c)
}

// ParseCursor decodes from base64 and will unmarshal from json
func ParseCursor[K comparable](cursorString string) (*Cursor[K], error) {
	return Base64DecodeAndUnmarshal[Cursor[K]](cursorString)
}

// ApplyTo applies the cursor to a collection of keys
func (c Cursor[K]) ApplyTo(keys []K) []K {
	var result []K
	for i, key := range keys {
		if i > c.CurrentIndex {
			result = append(result, key)
		}
	}
	return result
}

// ApplyToSegments applies the cursor to segments of keys
func (c Cursor[K]) ApplyToSegments(segments [][]K, minimumSegmentLength int) []K {
	var keys []K
	if c.Seed != nil {
		keys = ShuffleSegmentedArray(segments, minimumSegmentLength, c.RandomFactor, *c.Seed)
	} else {
		keys = lo.Flatten(segments)
	}

	return c.ApplyTo(keys)
}

// ItemCursor contains cursor data for pagination
type ItemCursor[K comparable] struct {
	Keys         []K `json:"keys"`
	CurrentIndex int `json:"currentIndex"`
}

// Encode encodes the cursor to a base64 string
func (c *ItemCursor[K]) Encode() (string, error) {
	return MarshalAndBase64Encode(c)
}

// ParseItemCursor parses the base64 encoded cursor into a ItemCursor struct
func ParseItemCursor[K comparable](cursorString string) (*ItemCursor[K], error) {
	cursor, err := Base64DecodeAndUnmarshal[ItemCursor[K]](cursorString)
	if err != nil {
		return nil, err
	}
	if cursor.Keys == nil {
		return nil, err
	}
	return cursor, nil
}

// CursorFor returns the cursor for the specified string
func (c *ItemCursor[K]) CursorFor(id K) *ItemCursor[K] {
	if len(c.Keys) == 0 {
		return nil
	}
	index := lo.IndexOf(c.Keys, id)
	if index < 0 {
		return nil
	}
	return &ItemCursor[K]{
		Keys:         c.Keys,
		CurrentIndex: index,
	}
}

// NextKeys returns the next keys with this specified limit
func (c *ItemCursor[K]) NextKeys(limit int) []K {
	if c.CurrentIndex >= len(c.Keys)-1 {
		return nil
	}

	from := c.CurrentIndex + 1

	to := lo.Min[int](
		[]int{
			c.CurrentIndex + 1 + limit,
			len(c.Keys),
		},
	)

	return c.Keys[from:to]
}

// ToItemCursor returns a cursor for the specified ids
func ToItemCursor[K comparable](ids []K, id K) *ItemCursor[K] {
	index := lo.IndexOf(ids, id)
	return &ItemCursor[K]{
		Keys:         ids,
		CurrentIndex: index,
	}
}
