package graph

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/common"
	gqlmodel "github.com/bcc-code/brunstadtv/backend/graph/model"
	"github.com/bcc-code/brunstadtv/backend/utils"
	"github.com/graph-gophers/dataloader/v7"
	"github.com/samber/lo"
	"time"
)

func getForPeriod[k comparable, t any](ctx context.Context, loader *dataloader.Loader[k, *t], factory func(ctx context.Context, from time.Time, to time.Time) ([]k, error), from time.Time, to time.Time) ([]*t, error) {
	ids, err := factory(ctx, from, to)
	if err != nil {
		return nil, err
	}
	items, err := common.GetManyFromLoader(ctx, loader, ids)
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
	}

	return lo.Map(days, func(date string, _ int) string {
		t, _ := time.ParseInLocation("2006-01-02", date, location)
		return t.Format(time.RFC3339)
	})
}

func (r *calendarResolver) periodResolver(ctx context.Context, from time.Time, to time.Time) (*gqlmodel.CalendarPeriod, error) {
	events, err := getForPeriod(ctx, r.Loaders.EventLoader, r.Queries.GetEventsForPeriod, from, to)
	if err != nil {
		return nil, err
	}
	entries, err := getForPeriod(ctx, r.Loaders.CalendarEntryLoader, r.Queries.GetCalendarEntriesForPeriod, from, to)
	if err != nil {
		return nil, err
	}

	return &gqlmodel.CalendarPeriod{
		Events:     utils.MapWithCtx(ctx, events, gqlmodel.EventFrom),
		ActiveDays: getActiveDays(entries, from),
	}, nil
}
