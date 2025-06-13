package utils

import (
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
	_, err := ParseOffsetCursor("invalid-base64")
	assert.Error(t, err)
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
