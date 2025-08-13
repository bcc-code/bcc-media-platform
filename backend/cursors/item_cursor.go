package cursors

import (
	"github.com/samber/lo"
)

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
		cursor.Keys = make([]K, 0)
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
