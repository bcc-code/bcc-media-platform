package main

import (
	"context"
	"strconv"
	"strings"
	"time"

	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
)

// liveReplayWindow is how long after a meeting ends its episode redirects to
// the Live app replay instead of playing in the app.
const liveReplayWindow = 48 * time.Hour

// liveReplayURLPrefix is the Live app replay URL without the calendar entry id.
func liveReplayURLPrefix(liveAppBaseURL string) string {
	return strings.TrimRight(liveAppBaseURL, "/") + "/replay/"
}

// handleCalendarEntryEvent keeps the episode URL override in sync with calendar
// entries: a meeting episode points to the Live app replay of its latest-ending
// published calendar entry until liveReplayWindow after the entry ends.
func (h *modelHandler) handleCalendarEntryEvent(ctx context.Context, collection string, key string) error {
	if collection != "calendarentries" {
		return nil
	}
	id, err := strconv.Atoi(key)
	if err != nil {
		return err
	}
	return h.queries.RefreshEpisodeOverridesForCalendarEntry(ctx, sqlc.RefreshEpisodeOverridesForCalendarEntryParams{
		EntryID:         int32(id),
		ReplayUrlPrefix: liveReplayURLPrefix(h.liveAppBaseURL),
		WindowHours:     int32(liveReplayWindow / time.Hour),
	})
}
