package cursors

import (
	"github.com/bcc-code/bcc-media-platform/backend/log"
)

// OffsetCursor represents a cursor that stores an offset position for pagination
type OffsetCursor struct {
	Offset int `json:"offset"`
}

// Encode encodes the OffsetCursor to a base64 JSON string
func (c *OffsetCursor) Encode() string {
	result, err := MarshalAndBase64Encode(c)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to encode OffsetCursor")
		return ""
	}
	return result
}

// GetOffset returns the offset of the OffsetCursor
func (c *OffsetCursor) GetOffset() int {
	return c.Offset
}

// NewWithOffset creates a new OffsetCursor with the given offset
func (c *OffsetCursor) NewWithOffset(offset int) *OffsetCursor {
	return &OffsetCursor{
		Offset: offset,
	}
}

// ParseOffsetCursor parses a base64 encoded cursor string back to an OffsetCursor
func ParseOffsetCursor(cursorString string) (*OffsetCursor, error) {
	cursor, err := Base64DecodeAndUnmarshal[OffsetCursor](cursorString)
	if err != nil {
		return nil, err
	}
	return cursor, nil
}

// ParseOrDefaultOffsetCursor parses a base64 encoded cursor string back to an OffsetCursor
// If the cursorString is nil or empty, it returns a new OffsetCursor with offset 0
func ParseOrDefaultOffsetCursor(cursorString *string) *OffsetCursor {
	if cursorString == nil || *cursorString == "" {
		return NewOffsetCursor(0)
	}
	c, err := ParseOffsetCursor(*cursorString)
	if err != nil {
		log.L.Error().Err(err).Str("cursorString", *cursorString).Msg("Failed to parse OffsetCursor")
		return NewOffsetCursor(0)
	}
	return c
}

// NewOffsetCursor creates a new OffsetCursor with the given offset
func NewOffsetCursor(offset int) *OffsetCursor {
	return &OffsetCursor{
		Offset: offset,
	}
}
