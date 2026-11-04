package main

import (
	"context"
	"strconv"
	"time"

	"github.com/bcc-code/bcc-media-platform/backend/liveapp"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
)

// handleCalendarEntryEvent keeps the episode URL override in sync with calendar
// entries: a meeting episode points to the Live app replay of its latest-ending
// published calendar entry until liveapp.ReplayWindow after the entry ends.
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
		ReplayUrlPrefix: h.liveApp.ReplayURLPrefix(),
		WindowSeconds:   int32(liveapp.ReplayWindow / time.Second),
	})
}
