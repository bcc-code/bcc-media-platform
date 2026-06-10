package graph

import (
	"context"
	"fmt"
	"strconv"
	"time"

	cache "github.com/Code-Hex/go-generics-cache"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/graph/api/model"
	"github.com/bcc-code/bcc-media-platform/backend/loaders"
	"github.com/bcc-code/bcc-media-platform/backend/memorycache"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"github.com/samber/lo"
)

// defaultBufferAvailableHours is used when a calendar entry has no explicit
// buffer_available_hours set (NULL). An explicit 0 means "never available".
const defaultBufferAvailableHours = 48

// maxBufferAvailableHours caps how long after an entry ends its buffer URL may
// stay available — 7 days. A larger configured buffer_available_hours is clamped
// to this.
const maxBufferAvailableHours = 7 * 24

// bufferWindow holds the data needed to expose a calendar entry's buffer
// (start-over) playback: the configured livestream manifest, the entry whose
// [start, end] window scopes it, and the absolute time until which it stays
// available (entry.end + buffer_available_hours).
type bufferWindow struct {
	entry         *common.CalendarEntry
	livestreamURL string
	until         time.Time
}

// bufferWindowForEntry resolves the buffer playback window for the calendar entry
// with the given id, or nil when no buffer should be offered to the caller. It is
// the single gate shared by the bufferUrl and bufferAvailableUntil fields, so the
// two are always consistent. A buffer is offered only when: a livestream signing
// key and URL are configured; the caller passes the permission-group gate
// (BufferAllowed — empty groups → all BCC members, else intersected with the
// caller's roles in SQL); the linked episode is not published (the published
// episode is then the canonical way to watch); buffer_available_hours > 0; and
// now is within [entry.start, entry.end + hours] (hours capped at
// maxBufferAvailableHours).
func (r *Resolver) bufferWindowForEntry(ctx context.Context, id string) (*bufferWindow, error) {
	if r.LivestreamSigner == nil {
		return nil, nil
	}

	conf, err := withCacheAndTimestamp(ctx, "global_config", r.Queries.GetGlobalConfig, time.Second*30, nil)
	if err != nil {
		return nil, err
	}
	if conf.LivestreamURL == "" {
		return nil, nil
	}

	entryID, err := strconv.Atoi(id)
	if err != nil {
		return nil, nil
	}
	entry, err := r.GetFilteredLoaders(ctx).CalendarEntryLoader.Get(ctx, entryID)
	if err != nil {
		return nil, err
	}
	if entry == nil {
		return nil, nil
	}

	if !entry.BufferAllowed || entry.EpisodePublished {
		return nil, nil
	}

	hours := int64(defaultBufferAvailableHours)
	if entry.BufferAvailableHours.Valid {
		hours = entry.BufferAvailableHours.Int64
	}
	if hours <= 0 {
		return nil, nil
	}
	if hours > maxBufferAvailableHours {
		hours = maxBufferAvailableHours
	}

	now := time.Now()
	until := entry.End.Add(time.Duration(hours) * time.Hour)
	if now.Before(entry.Start) || !now.Before(until) {
		return nil, nil
	}

	return &bufferWindow{entry: entry, livestreamURL: conf.LivestreamURL, until: until}, nil
}

// bufferPlaybackWindow returns the [start, end] window the buffer (start-over)
// playback URL should be scoped to. The optional buffer_start and buffer_end
// overrides are applied independently — either, both, or neither may be set —
// letting editors trim the replay to the actual program window; each unset side
// falls back to the entry's corresponding time. If the resulting window is invalid
// (end not after start) the override is ignored entirely and the entry's own times
// are used. This only affects the URL's time-shift tags — availability gating still
// keys off the entry's times (see bufferWindowForEntry).
func bufferPlaybackWindow(entry *common.CalendarEntry) (start, end time.Time) {
	start, end = entry.Start, entry.End
	if entry.BufferStart.Valid {
		start = entry.BufferStart.Time
	}
	if entry.BufferEnd.Valid {
		end = entry.BufferEnd.Time
	}
	if !end.After(start) {
		return entry.Start, entry.End
	}
	return start, end
}

// bufferForEntry returns the signed buffer (start-over) playback for the calendar
// entry — the URL scoped to its [start, end] window plus the absolute time until
// which it stays available — or nil when no buffer is offered to the caller.
func (r *Resolver) bufferForEntry(ctx context.Context, id string) (*model.CalendarEntryBuffer, error) {
	w, err := r.bufferWindowForEntry(ctx, id)
	if err != nil || w == nil {
		return nil, err
	}
	start, end := bufferPlaybackWindow(w.entry)
	url, err := r.signedBufferURL(w.livestreamURL, start, end, w.until)
	if err != nil {
		return nil, err
	}
	return &model.CalendarEntryBuffer{
		URL:            url,
		AvailableUntil: w.until.Format(time.RFC3339),
	}, nil
}

func getForPeriod[k comparable, t any](ctx context.Context, loader *loaders.Loader[k, *t], factory func(ctx context.Context, from time.Time, to time.Time) ([]k, error), from time.Time, to time.Time) ([]*t, error) {
	fromTrunc := from.Truncate(time.Hour * 1)
	toTrunc := to.Truncate(time.Hour * 1)
	ids, err := memorycache.GetOrSet(ctx, fmt.Sprintf("period-%s-%s", fromTrunc.Format(time.RFC3339), toTrunc.Format(time.RFC3339)), func(ctx context.Context) ([]k, error) {
		return factory(ctx, from, to)
	}, cache.WithExpiration(time.Minute*5))
	if err != nil {
		return nil, err
	}
	items, err := loader.GetMany(ctx, ids)
	if err != nil {
		return nil, err
	}
	return items, nil
}

func getActiveDays(entries []*common.CalendarEntry, sourceTime time.Time) []string {
	zone, offset := sourceTime.Zone()
	location := time.FixedZone(zone, offset)

	var days []string
	for _, entry := range entries {
		date := entry.Start.In(location)
		dateString := date.Format("2006-01-02")
		if !lo.Contains(days, dateString) {
			days = append(days, dateString)
		}
		//endDate := entry.End.In(location)
		//endDateString := endDate.Format("2006-01-02")
		//if !endDate.After(date) {
		//	continue
		//}
		//for endDateString != dateString {
		//	if !lo.Contains(days, endDateString) {
		//		days = append(days, endDateString)
		//	}
		//	endDate = endDate.Add(time.Hour * -24)
		//	endDateString = endDate.Format("2006-01-02")
		//}
	}

	return lo.Map(days, func(date string, _ int) string {
		t, _ := time.ParseInLocation("2006-01-02", date, location)
		return t.Format(time.RFC3339)
	})
}

func (r *calendarResolver) periodResolver(ctx context.Context, from time.Time, to time.Time) (*model.CalendarPeriod, error) {
	events, err := getForPeriod(ctx, r.Loaders.EventLoader, r.Queries.GetEventsForPeriod, from, to)
	if err != nil {
		return nil, err
	}
	entries, err := getForPeriod(ctx, r.GetFilteredLoaders(ctx).CalendarEntryLoader, r.Queries.GetCalendarEntriesForPeriod, from, to)
	if err != nil {
		return nil, err
	}
	return &model.CalendarPeriod{
		Events:     utils.MapWithCtx(ctx, events, model.EventFrom),
		ActiveDays: getActiveDays(entries, from),
	}, nil
}
