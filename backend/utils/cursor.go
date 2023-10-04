package utils

import (
	"encoding/base64"
	"encoding/json"
	"github.com/samber/lo"
)

// Cursor contains cursor data for pagination
type Cursor struct {
	IDs          []string `json:"ids"`
	CurrentIndex int      `json:"currentIndex"`
}

// Encode encodes the cursor to a base64 string
func (c *Cursor) Encode() (string, error) {
	marshalled, err := json.Marshal(c)
	if err != nil {
		return "", err
	}
	// encode to base64
	return base64.StdEncoding.EncodeToString(marshalled), nil
}

// ParseCursor parses the base64 encoded cursor into a Cursor struct
func ParseCursor(cursorString string) (*Cursor, error) {
	marshalled, err := base64.StdEncoding.DecodeString(cursorString)
	if err != nil {
		return nil, err
	}
	var cursor Cursor
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
func (c *Cursor) CursorFor(id string) *Cursor {
	index := lo.IndexOf(c.IDs, id)
	if index < 0 {
		return nil
	}
	return &Cursor{
		IDs:          c.IDs,
		CurrentIndex: index,
	}
}

func (c *Cursor) Next() *Cursor {
	if c.CurrentIndex >= len(c.IDs)-1 {
		return nil
	}
	return &Cursor{
		IDs:          c.IDs,
		CurrentIndex: c.CurrentIndex + 1,
	}
}

// ToCursor returns a cursor for the specified ids
func ToCursor(ids []string, id string) *Cursor {
	index := lo.IndexOf(ids, id)
	return &Cursor{
		IDs:          ids,
		CurrentIndex: index,
	}
}
