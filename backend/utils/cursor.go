package utils

import (
	"github.com/samber/lo"
)

// Cursor contains cursor data for pagination
type Cursor[K comparable] struct {
	Keys         []K `json:"keys"`
	CurrentIndex int `json:"currentIndex"`
}

// Encode encodes the cursor to a base64 string
func (c *Cursor[K]) Encode() (string, error) {
	return MarshalAndBase64Encode(c)
}

// ParseCursor parses the base64 encoded cursor into a Cursor struct
func ParseCursor[K comparable](cursorString string) (*Cursor[K], error) {
	cursor, err := Base64DecodeAndUnmarshal[Cursor[K]](cursorString)
	if err != nil {
		return nil, err
	}
	if cursor.Keys == nil {
		return nil, err
	}
	return cursor, nil
}

// CursorFor returns the cursor for the specified string
func (c *Cursor[K]) CursorFor(id K) *Cursor[K] {
	if len(c.Keys) == 0 {
		return nil
	}
	index := lo.IndexOf(c.Keys, id)
	if index < 0 {
		return nil
	}
	return &Cursor[K]{
		Keys:         c.Keys,
		CurrentIndex: index,
	}
}

// NextKeys returns the next keys with this specified limit
func (c *Cursor[K]) NextKeys(limit int) []K {
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

// ToCursor returns a cursor for the specified ids
func ToCursor[K comparable](ids []K, id K) *Cursor[K] {
	index := lo.IndexOf(ids, id)
	return &Cursor[K]{
		Keys:         ids,
		CurrentIndex: index,
	}
}
