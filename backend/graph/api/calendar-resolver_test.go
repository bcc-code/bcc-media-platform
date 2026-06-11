package graph

import (
	"context"
	"net/http/httptest"
	"testing"
	"time"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/loaders"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/bcc-code/bcc-media-platform/backend/user"
	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
	"gopkg.in/guregu/null.v4"
)

func TestBufferPlaybackWindow(t *testing.T) {
	entryStart := time.Unix(1700000000, 0)
	entryEnd := time.Unix(1700003600, 0)
	ovStart := time.Unix(1700000600, 0)
	ovEnd := time.Unix(1700002000, 0)

	// Default (entry-derived) window is padded: lead-in before start, lead-out
	// after end. Explicit overrides are used as-is, without padding.
	paddedStart := entryStart.Add(-bufferLeadIn)
	paddedEnd := entryEnd.Add(bufferLeadOut)

	tests := []struct {
		name      string
		entry     common.CalendarEntry
		wantStart time.Time
		wantEnd   time.Time
	}{
		{
			name:      "no override falls back to padded entry times",
			entry:     common.CalendarEntry{Start: entryStart, End: entryEnd},
			wantStart: paddedStart,
			wantEnd:   paddedEnd,
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
			name: "resulting end not after start falls back to padded entry times",
			entry: common.CalendarEntry{
				Start:       entryStart,
				End:         entryEnd,
				BufferStart: null.TimeFrom(ovEnd),
				BufferEnd:   null.TimeFrom(ovStart),
			},
			wantStart: paddedStart,
			wantEnd:   paddedEnd,
		},
		{
			name: "only start set overrides start, keeps padded entry end",
			entry: common.CalendarEntry{
				Start:       entryStart,
				End:         entryEnd,
				BufferStart: null.TimeFrom(ovStart),
			},
			wantStart: ovStart,
			wantEnd:   paddedEnd,
		},
		{
			name: "only end set keeps padded entry start, overrides end",
			entry: common.CalendarEntry{
				Start:     entryStart,
				End:       entryEnd,
				BufferEnd: null.TimeFrom(ovEnd),
			},
			wantStart: paddedStart,
			wantEnd:   ovEnd,
		},
		{
			name: "only start set after entry end falls back to padded entry times",
			entry: common.CalendarEntry{
				Start:       entryStart,
				End:         entryEnd,
				BufferStart: null.TimeFrom(entryEnd.Add(time.Hour)),
			},
			wantStart: paddedStart,
			wantEnd:   paddedEnd,
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

// ctxWithLanguages returns a context carrying a gin.Context with the given
// preferred languages, as the resolvers expect.
func ctxWithLanguages(t *testing.T, languages []string) context.Context {
	t.Helper()
	gin.SetMode(gin.TestMode)
	rec := httptest.NewRecorder()
	c, _ := gin.CreateTestContext(rec)
	req := httptest.NewRequest("POST", "/query", nil)
	c.Request = req
	c.Set(user.CtxLanguages, languages)
	return context.WithValue(req.Context(), "GinContextKey", c)
}

func TestEntryImageURL(t *testing.T) {
	const cdn = "cdn.example.test"
	const episodeImage = "https://cdn.example.test/episode.png"
	fallback := "https://" + cdn + "/" + defaultCalendarEntryImageFilename

	q := &sqlc.Queries{}
	q.SetImageCDNDomain(cdn)

	ctx := ctxWithLanguages(t, []string{"no"})

	// Episode 10 has an image; episode 20 has none.
	episodes := map[int]common.Episode{
		10: {ID: 10, Images: common.Images{
			common.ImageStyleDefault: common.LocaleMap[string]{"no": episodeImage},
		}},
		20: {ID: 20},
	}
	epLoader := loaders.New(ctx, func(_ context.Context, ids []int) ([]common.Episode, error) {
		var out []common.Episode
		for _, id := range ids {
			if ep, ok := episodes[id]; ok {
				out = append(out, ep)
			}
		}
		return out, nil
	})

	r := &Resolver{Queries: q, Loaders: &loaders.BatchLoaders{EpisodeLoader: epLoader}}

	width := func(w int) *int { return &w }

	tests := []struct {
		name  string
		entry *common.CalendarEntry
		width *int
		want  string
	}{
		{
			name:  "nil entry falls back, default width",
			entry: nil,
			width: nil,
			want:  fallback + "?w=100",
		},
		{
			name:  "non-episode entry falls back",
			entry: &common.CalendarEntry{Type: null.StringFrom("show"), ItemID: null.IntFrom(5)},
			width: nil,
			want:  fallback + "?w=100",
		},
		{
			name:  "episode with image",
			entry: &common.CalendarEntry{Type: null.StringFrom("episode"), ItemID: null.IntFrom(10)},
			width: nil,
			want:  episodeImage + "?w=100",
		},
		{
			name:  "episode with image, custom width",
			entry: &common.CalendarEntry{Type: null.StringFrom("episode"), ItemID: null.IntFrom(10)},
			width: width(250),
			want:  episodeImage + "?w=250",
		},
		{
			name:  "episode without image falls back",
			entry: &common.CalendarEntry{Type: null.StringFrom("episode"), ItemID: null.IntFrom(20)},
			width: nil,
			want:  fallback + "?w=100",
		},
		{
			name:  "episode link without item id falls back",
			entry: &common.CalendarEntry{Type: null.StringFrom("episode")},
			width: nil,
			want:  fallback + "?w=100",
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got := r.entryImageURL(ctx, tt.entry, tt.width)
			assert.Equal(t, tt.want, got)
		})
	}
}
