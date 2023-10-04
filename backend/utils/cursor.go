package utils

import (
	"encoding/base64"
	"encoding/json"
	"github.com/samber/lo"
)

// Cursor contains cursor data for pagination
type Cursor[K comparable] struct {
	IDs          []K `json:"ids"`
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
	if cursor.IDs == nil {
		return nil, err
	}
	return &cursor, nil
}

// CursorFor returns the cursor for the specified string
func (c *Cursor[K]) CursorFor(id K) *Cursor[K] {
	index := lo.IndexOf(c.IDs, id)
	if index < 0 {
		return nil
	}
	return &Cursor[K]{
		IDs:          c.IDs,
		CurrentIndex: index,
	}
}

// Current returns the current key
func (c *Cursor[K]) Current() K {
	return c.IDs[c.CurrentIndex]
}

// Next returns the next key
func (c *Cursor[K]) Next() *K {
	if c.CurrentIndex >= len(c.IDs)-1 {
		return nil
	}
	return &c.IDs[c.CurrentIndex+1]
}

// NextCursor returns the next cursor
func (c *Cursor[K]) NextCursor() *Cursor[K] {
	if c.CurrentIndex >= len(c.IDs)-1 {
		return nil
	}
	return &Cursor[K]{
		IDs:          c.IDs,
		CurrentIndex: c.CurrentIndex + 1,
	}
}

// Previous returns the previous key
func (c *Cursor[K]) Previous() *K {
	if c.CurrentIndex <= 0 {
		return nil
	}
	return &c.IDs[c.CurrentIndex-1]
}

// PreviousCursor returns the previous cursor
func (c *Cursor[K]) PreviousCursor() *Cursor[K] {
	if c.CurrentIndex <= 0 {
		return nil
	}
	return &Cursor[K]{
		IDs:          c.IDs,
		CurrentIndex: c.CurrentIndex - 1,
	}
}

// ToCursor returns a cursor for the specified ids
func ToCursor[K comparable](ids []K, id K) *Cursor[K] {
	index := lo.IndexOf(ids, id)
	return &Cursor[K]{
		IDs:          ids,
		CurrentIndex: index,
	}
}
