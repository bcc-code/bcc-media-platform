package graph

import (
	"testing"

	"github.com/bcc-code/bcc-media-platform/backend/graph/api/model"
	"github.com/stretchr/testify/assert"
)

func TestMessageVariantFromString(t *testing.T) {
	tests := []struct {
		style    string
		expected model.MessageStyleVariant
	}{
		{"info", model.MessageStyleVariantInfo},
		{"warning", model.MessageStyleVariantWarning},
		{"error", model.MessageStyleVariantError},
		{"", model.MessageStyleVariantInfo},
		{"notavariant", model.MessageStyleVariantInfo},
		{"Error", model.MessageStyleVariantInfo}, // the column is lowercase; casing is not coerced
	}

	for _, test := range tests {
		t.Run(test.style, func(t *testing.T) {
			assert.Equal(t, test.expected, messageVariantFromString(test.style))
		})
	}
}

// The deprecated hex fields must keep serving the same colors as before.
func TestMessageStyleFromStringUnchanged(t *testing.T) {
	assert.Equal(t, "#bf3b32", messageStyleFromString("error").Background)
	assert.Equal(t, "#6EB0E6", messageStyleFromString("info").Background)
	assert.Equal(t, "#633800", messageStyleFromString("warning").Background)
	assert.Equal(t, "#133747", messageStyleFromString("notavariant").Background)
}
