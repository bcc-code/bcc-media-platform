package sqlc

import (
	"context"
	"encoding/json"
	"time"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/loaders"
	"github.com/samber/lo"
	"gopkg.in/guregu/null.v4"
)

func mapToEvents(items []getEventsRow) []common.Event {
	return lo.Map(items, func(i getEventsRow, _ int) common.Event {
		var title common.LocaleString

		_ = json.Unmarshal(i.Title.RawMessage, &title)

		return common.Event{
			ID:    int(i.ID),
			Title: title,
			End:   i.End,
			Start: i.Start,
		}
	})
}

// GetEvents returns specific calendar events
func (q *Queries) GetEvents(ctx context.Context, ids []int) ([]common.Event, error) {
	items, err := q.getEvents(ctx, intToInt32(ids))
	if err != nil {
		return nil, err
	}
	return mapToEvents(items), nil
}

// ListEvents returns all CalendarEvents
func (q *Queries) ListEvents(ctx context.Context) ([]common.Event, error) {
	items, err := q.listEvents(ctx)
	if err != nil {
		return nil, err
	}
	return mapToEvents(lo.Map(items, func(i listEventsRow, _ int) getEventsRow {
		return getEventsRow(i)
	})), nil
}

// GetEntryIDsForEventIDs returns the calendar entry ids for the specified event ids
func (q *Queries) GetEntryIDsForEventIDs(ctx context.Context, ids []int) ([]loaders.Relation[int, int], error) {
	rows, err := q.getCalendarEntryIDsForEvents(ctx, intToInt32(ids))
	if err != nil {
		return nil, nil
	}
	return lo.Map(rows, func(r getCalendarEntryIDsForEventsRow, _ int) loaders.Relation[int, int] {
		return relation[int, int]{
			ID:       int(r.ID),
			ParentID: int(r.ParentID.Int64),
		}
	}), nil
}

// GetEventsForPeriod returns events for the specific period
func (q *Queries) GetEventsForPeriod(ctx context.Context, from time.Time, to time.Time) ([]int, error) {
	ids, err := q.getEventIDsForPeriod(ctx, getEventIDsForPeriodParams{
		from,
		to,
	})
	if err != nil {
		return nil, err
	}
	return int32ToInt(ids), nil
}

func mapToCalendarEntries(items []getCalendarEntriesRow) []common.CalendarEntry {
	return lo.Map(items, func(i getCalendarEntriesRow, _ int) common.CalendarEntry {
		var title common.LocaleString
		var description common.LocaleString

		_ = json.Unmarshal(i.Title, &title)
		_ = json.Unmarshal(i.Description, &description)

		var itemID null.Int
		switch i.LinkType.ValueOrZero() {
		case "episode":
			itemID = i.EpisodeID
		case "show":
			itemID = i.ShowID
		case "season":
			itemID = i.SeasonID
		}

		return common.CalendarEntry{
			ID:          int(i.ID),
			EventID:     i.EventID,
			Title:       title,
			Description: description,
			Start:       i.Start,
			End:         i.End,
			Type:        i.LinkType,
			IsReplay:    i.IsReplay,
			ItemID:      itemID,
		}
	})
}

// GetCalendarEntries returns the specified entries
func (rq *RoleQueries) GetCalendarEntries(ctx context.Context, ids []int) ([]common.CalendarEntry, error) {
	items, err := rq.queries.getCalendarEntries(ctx, getCalendarEntriesParams{
		Column1: intToInt32(ids),
		Column2: rq.roles,
	})
	if err != nil {
		return nil, err
	}
	return mapToCalendarEntries(items), nil
}

// GetCalendarEntriesForPeriod returns events for the specific period
func (q *Queries) GetCalendarEntriesForPeriod(ctx context.Context, from time.Time, to time.Time) ([]int, error) {
	ids, err := q.getCalendarEntryIDsForPeriod(ctx, getCalendarEntryIDsForPeriodParams{
		from,
		to,
	})
	if err != nil {
		return nil, err
	}
	return int32ToInt(ids), err
}

// GetCalendarEntriesByID returns the calendar entries for the specified ids
func (q *Queries) GetCalendarEntriesByID(ctx context.Context, ids []int) ([]common.CalendarEntry, error) {
	items, err := q.getCalendarEntriesByID(ctx, intToInt32(ids))
	if err != nil {
		return nil, err
	}

	return mapToCalendarEntries(lo.Map(items, func(i getCalendarEntriesByIDRow, _ int) getCalendarEntriesRow {
		return getCalendarEntriesRow(i)
	})), nil
}
