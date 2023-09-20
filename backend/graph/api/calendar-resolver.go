package graph

import (
	"context"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/graph/api/model"
	"github.com/bcc-code/bcc-media-platform/backend/loaders"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"github.com/samber/lo"
	"time"
)

func getForPeriod[k comparable, t any](ctx context.Context, loader *loaders.Loader[k, *t], factory func(ctx context.Context, from time.Time, to time.Time) ([]k, error), from time.Time, to time.Time) ([]*t, error) {
	ids, err := factory(ctx, from, to)
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
