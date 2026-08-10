package phrase

import (
	"encoding/json"
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

// UnmarshalJSON used to assign to the receiver variable rather than through it,
// so every timestamp Phrase returned was silently left at the zero time while
// unmarshalling reported success.
func TestDatetimeUnmarshalJSON(t *testing.T) {
	tests := []struct {
		name string
		json string
		want time.Time
	}{
		{
			name: "Z suffix",
			json: `"2026-08-10T12:30:00Z"`,
			want: time.Date(2026, 8, 10, 12, 30, 0, 0, time.UTC),
		},
		{
			name: "numeric offset",
			json: `"2026-08-10T12:30:00+0200"`,
			want: time.Date(2026, 8, 10, 12, 30, 0, 0, time.FixedZone("", 2*60*60)),
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			var d Datetime
			require.NoError(t, json.Unmarshal([]byte(tt.json), &d))

			got := time.Time(d)
			assert.False(t, got.IsZero(), "value was left at the zero time")
			assert.True(t, got.Equal(tt.want), "got %v, want %v", got, tt.want)
		})
	}
}

func TestDatetimeUnmarshalJSONEmptyString(t *testing.T) {
	var d Datetime
	require.NoError(t, json.Unmarshal([]byte(`""`), &d))
	assert.True(t, time.Time(d).IsZero(), "an empty string should leave the zero time")
}

func TestDatetimeUnmarshalJSONRejectsUnknownLayout(t *testing.T) {
	var d Datetime
	err := json.Unmarshal([]byte(`"10/08/2026"`), &d)
	assert.Error(t, err)
}

// Round-tripping is what the API actually does with these values.
func TestDatetimeRoundTrip(t *testing.T) {
	original := Datetime(time.Date(2026, 8, 10, 12, 30, 0, 0, time.UTC))

	encoded, err := json.Marshal(original)
	require.NoError(t, err)

	var decoded Datetime
	require.NoError(t, json.Unmarshal(encoded, &decoded))

	assert.True(t, time.Time(decoded).Equal(time.Time(original)),
		"round trip lost the value: %v -> %s -> %v", time.Time(original), encoded, time.Time(decoded))
}
