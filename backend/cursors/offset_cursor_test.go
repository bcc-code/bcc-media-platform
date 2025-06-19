package cursors

import (
	"github.com/bcc-code/bcc-media-platform/backend/log"
	"github.com/rs/zerolog"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestOffsetCursor_Encode(t *testing.T) {
	cursor := &OffsetCursor{Offset: 10}
	encoded := cursor.Encode()
	assert.NotEmpty(t, encoded)
}

func TestOffsetCursor_EncodeDecode(t *testing.T) {
	cursor := &OffsetCursor{Offset: 25}

	encoded := cursor.Encode()
	assert.NotEmpty(t, encoded)

	decoded, err := ParseOffsetCursor(encoded)
	require.NoError(t, err)
	assert.Equal(t, cursor.Offset, decoded.Offset)
}

func TestOffsetCursor_EncodeDecodeZero(t *testing.T) {
	cursor := &OffsetCursor{Offset: 0}

	encoded := cursor.Encode()
	assert.NotEmpty(t, encoded)

	decoded, err := ParseOffsetCursor(encoded)
	require.NoError(t, err)
	assert.Equal(t, cursor.Offset, decoded.Offset)
}

func TestParseOffsetCursor_Invalid(t *testing.T) {
	tests := []struct {
		name        string
		cursor      string
		expectError bool
		errMsg      string
	}{
		{
			name:        "empty string",
			cursor:      "",
			expectError: true,
			errMsg:      "unexpected end of JSON input",
		},
		{
			name:        "invalid base64",
			cursor:      "not-valid-base64",
			expectError: true,
			errMsg:      "illegal base64 data",
		},
		{
			name:        "invalid offset type",
			cursor:      "eyJvZmZzZXQiOiJpbnZhbGlkIn0=", // {"offset":"invalid"}
			expectError: true,
			errMsg:      "cannot unmarshal string into Go struct field OffsetCursor.offset of type int",
		},
		{
			name:        "empty json",
			cursor:      "e30=", // {}
			expectError: false,  // Defaults to offset 0
		},
		{
			name:        "invalid json",
			cursor:      "not-json",
			expectError: true,
			errMsg:      "illegal base64 data",
		},
		{
			name:        "negative offset",
			cursor:      "eyJvZmZzZXQiOi0xfQ==", // {"offset":-1}
			expectError: false,                  // Negative offset is actually allowed in the implementation
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			result, err := ParseOffsetCursor(tt.cursor)
			if tt.expectError {
				if assert.Error(t, err, "expected error for cursor: %s", tt.cursor) {
					assert.Contains(t, err.Error(), tt.errMsg, "unexpected error message")
				}
			} else {
				if assert.NoError(t, err, "unexpected error for cursor: %s", tt.cursor) {
					assert.NotNil(t, result, "expected non-nil result")
				}
			}
		})
	}
}

func TestParseOrDefaultOffsetCursor(t *testing.T) {
	// Needed in some of the tests:W
	log.ConfigureGlobalLogger(zerolog.DebugLevel)

	tests := []struct {
		name       string
		cursor     *string
		expectZero bool
	}{
		{
			name:       "nil cursor",
			cursor:     nil,
			expectZero: true,
		},
		{
			name:       "empty cursor",
			cursor:     ptr(""),
			expectZero: true,
		},
		{
			name:       "valid cursor",
			cursor:     ptr("eyJvZmZzZXQiOjEwfQ=="), // {"offset":10}
			expectZero: false,
		},
		{
			name:       "invalid cursor",
			cursor:     ptr("invalid"),
			expectZero: true, // Should default to zero on error
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			result := ParseOrDefaultOffsetCursor(tt.cursor)
			if tt.expectZero {
				assert.Equal(t, 0, result.Offset, "expected zero offset")
			} else {
				assert.Equal(t, 10, result.Offset, "expected offset 10")
			}
		})
	}
}

// Helper function to create a string pointer
func ptr(s string) *string {
	return &s
}

func TestNewOffsetCursor(t *testing.T) {
	cursor := NewOffsetCursor(50)
	assert.Equal(t, 50, cursor.Offset)
}

func TestOffsetCursor_Integration(t *testing.T) {
	// Create cursor
	cursor := NewOffsetCursor(100)
	assert.Equal(t, 100, cursor.Offset)

	// Encode
	encoded := cursor.Encode()
	assert.NotEmpty(t, encoded)

	// Decode
	decoded, err := ParseOffsetCursor(encoded)
	require.NoError(t, err)
	assert.Equal(t, cursor.Offset, decoded.Offset)
}
