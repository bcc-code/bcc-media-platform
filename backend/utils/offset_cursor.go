package utils

import "github.com/bcc-code/bcc-media-platform/backend/log"

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

// ParseOffsetCursor parses a base64 encoded cursor string back to an OffsetCursor
func ParseOffsetCursor(cursorString string) (*OffsetCursor, error) {
	cursor, err := Base64DecodeAndUnmarshal[OffsetCursor](cursorString)
	if err != nil {
		return nil, err
	}
	return cursor, nil
}

// NewOffsetCursor creates a new OffsetCursor with the given offset
func NewOffsetCursor(offset int) *OffsetCursor {
	return &OffsetCursor{
		Offset: offset,
	}
}
