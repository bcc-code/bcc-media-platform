package utils

import (
	"encoding/base64"
	"encoding/json"

	"github.com/samber/lo"
)

// Cursor contains cursor data for pagination
type Cursor[K comparable] struct {
	Keys         []K `json:"keys"`
	CurrentIndex int `json:"currentIndex"`
}

// Encode encodes the cursor to a base64 string
func (c *Cursor[K]) Encode() (string, error) {
	marshalled, err := json.Marshal(c)
	if err != nil {
		return "", err
	}
	// encode to base64
	return base64.StdEncoding.EncodeToString(marshalled), nil
}

// ParseCursor parses the base64 encoded cursor into a Cursor struct
func ParseCursor[K comparable](cursorString string) (*Cursor[K], error) {
	marshalled, err := base64.StdEncoding.DecodeString(cursorString)
	if err != nil {
		return nil, err
	}
	var cursor Cursor[K]
	err = json.Unmarshal(marshalled, &cursor)
	if err != nil {
		return nil, err
	}
	if cursor.Keys == nil {
		return nil, err
	}
	return &cursor, nil
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

// Current returns the current key
func (c *Cursor[K]) Current() K {
	return c.Keys[c.CurrentIndex]
}

// GetKeys returns keys starting from the current index
func (c *Cursor[K]) GetKeys(limit int) []K {
	if c.CurrentIndex >= len(c.Keys) {
		return nil
	}

	from := c.CurrentIndex

	to := lo.Min[int](
		[]int{
			c.CurrentIndex + limit,
			len(c.Keys),
		},
	)

	return c.Keys[from:to]
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

// Next returns the next key
func (c *Cursor[K]) Next() *K {
	if c.CurrentIndex >= len(c.Keys)-1 {
		return nil
	}
	return &c.Keys[c.CurrentIndex+1]
}

// NextCursor returns the next cursor
func (c *Cursor[K]) NextCursor() *Cursor[K] {
	if c.CurrentIndex >= len(c.Keys)-1 {
		return nil
	}
	return &Cursor[K]{
		Keys:         c.Keys,
		CurrentIndex: c.CurrentIndex + 1,
	}
}

// Previous returns the previous key
func (c *Cursor[K]) Previous() *K {
	if c.CurrentIndex <= 0 {
		return nil
	}
	return &c.Keys[c.CurrentIndex-1]
}

// PreviousCursor returns the previous cursor
func (c *Cursor[K]) PreviousCursor() *Cursor[K] {
	if c.CurrentIndex <= 0 {
		return nil
	}
	return &Cursor[K]{
		Keys:         c.Keys,
		CurrentIndex: c.CurrentIndex - 1,
	}
}

// Position returns the key at the position or nil
func (c *Cursor[K]) Position(index int) *K {
	if index < 0 || index >= len(c.Keys) {
		return nil
	}
	return &c.Keys[index]
}

// ToCursor returns a cursor for the specified ids
func ToCursor[K comparable](ids []K, id K) *Cursor[K] {
	index := lo.IndexOf(ids, id)
	return &Cursor[K]{
		Keys:         ids,
		CurrentIndex: index,
	}
}

// NewCursor returns a new cursor for the specified ids
func NewCursor[K comparable](ids []K) *Cursor[K] {
	return &Cursor[K]{
		Keys:         ids,
		CurrentIndex: 0,
	}
}
