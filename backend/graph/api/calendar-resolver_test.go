package graph

import (
	"testing"
	"time"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/stretchr/testify/assert"
	"gopkg.in/guregu/null.v4"
)

func TestBufferPlaybackWindow(t *testing.T) {
	entryStart := time.Unix(1700000000, 0)
	entryEnd := time.Unix(1700003600, 0)
	ovStart := time.Unix(1700000600, 0)
	ovEnd := time.Unix(1700002000, 0)

	tests := []struct {
		name      string
		entry     common.CalendarEntry
		wantStart time.Time
		wantEnd   time.Time
	}{
		{
			name:      "no override falls back to entry times",
			entry:     common.CalendarEntry{Start: entryStart, End: entryEnd},
			wantStart: entryStart,
			wantEnd:   entryEnd,
		},
		{
			name: "valid override takes precedence",
			entry: common.CalendarEntry{
				Start:       entryStart,
				End:         entryEnd,
				BufferStart: null.TimeFrom(ovStart),
				BufferEnd:   null.TimeFrom(ovEnd),
			},
			wantStart: ovStart,
			wantEnd:   ovEnd,
		},
		{
			name: "resulting end not after start falls back to entry times",
			entry: common.CalendarEntry{
				Start:       entryStart,
				End:         entryEnd,
				BufferStart: null.TimeFrom(ovEnd),
				BufferEnd:   null.TimeFrom(ovStart),
			},
			wantStart: entryStart,
			wantEnd:   entryEnd,
		},
		{
			name: "only start set overrides start, keeps entry end",
			entry: common.CalendarEntry{
				Start:       entryStart,
				End:         entryEnd,
				BufferStart: null.TimeFrom(ovStart),
			},
			wantStart: ovStart,
			wantEnd:   entryEnd,
		},
		{
			name: "only end set keeps entry start, overrides end",
			entry: common.CalendarEntry{
				Start:     entryStart,
				End:       entryEnd,
				BufferEnd: null.TimeFrom(ovEnd),
			},
			wantStart: entryStart,
			wantEnd:   ovEnd,
		},
		{
			name: "only start set after entry end falls back to entry times",
			entry: common.CalendarEntry{
				Start:       entryStart,
				End:         entryEnd,
				BufferStart: null.TimeFrom(entryEnd.Add(time.Hour)),
			},
			wantStart: entryStart,
			wantEnd:   entryEnd,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			start, end := bufferPlaybackWindow(&tt.entry)
			assert.Equal(t, tt.wantStart, start)
			assert.Equal(t, tt.wantEnd, end)
		})
	}
}
