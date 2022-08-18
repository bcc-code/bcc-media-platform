package graph

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.

import (
	"context"
	"time"

	"github.com/bcc-code/brunstadtv/backend/graph/generated"
	gqlmodel "github.com/bcc-code/brunstadtv/backend/graph/model"
	"github.com/bcc-code/brunstadtv/backend/utils"
)

// Period is the resolver for the period field.
func (r *calendarResolver) Period(ctx context.Context, obj *gqlmodel.Calendar, from string, to string) (*gqlmodel.CalendarPeriod, error) {
	fromTime, err := time.Parse(time.RFC3339, from)
	if err != nil {
		return nil, err
	}
	toTime, err := time.Parse(time.RFC3339, to)
	if err != nil {
		return nil, err
	}
	return r.periodResolver(ctx, fromTime, toTime)
}

// Day is the resolver for the day field.
func (r *calendarResolver) Day(ctx context.Context, obj *gqlmodel.Calendar, day string) (*gqlmodel.CalendarDay, error) {
	source, err := time.Parse(time.RFC3339, day)
	if err != nil {
		return nil, err
	}

	yy, mm, dd := source.Date()
	zone, offset := source.Zone()
	location := time.FixedZone(zone, offset)
	midnight := time.Date(yy, mm, dd, 0, 0, 0, 0, location)
	nextMidnight := midnight.Add(time.Hour * 24)

	events, err := getForPeriod(ctx, r.Loaders.EventLoader, r.Queries.GetEventsForPeriod, midnight, nextMidnight)
	if err != nil {
		return nil, err
	}
	entries, err := getForPeriod(ctx, r.Loaders.CalendarEntryLoader, r.Queries.GetCalendarEntriesForPeriod, midnight, nextMidnight)
	if err != nil {
		return nil, err
	}
	return &gqlmodel.CalendarDay{
		Events:  utils.MapWithCtx(ctx, events, gqlmodel.EventFrom),
		Entries: utils.MapWithCtx(ctx, entries, gqlmodel.CalendarEntryFrom),
	}, nil
}

// Event is the resolver for the event field.
func (r *episodeCalendarEntryResolver) Event(ctx context.Context, obj *gqlmodel.EpisodeCalendarEntry) (*gqlmodel.Event, error) {
	if obj.Event == nil {
		return nil, nil
	}
	return r.QueryRoot().Event(ctx, obj.Event.ID)
}

// Episode is the resolver for the episode field.
func (r *episodeCalendarEntryResolver) Episode(ctx context.Context, obj *gqlmodel.EpisodeCalendarEntry) (*gqlmodel.Episode, error) {
	return r.QueryRoot().Episode(ctx, obj.Episode.ID)
}

// Event is the resolver for the event field.
func (r *seasonCalendarEntryResolver) Event(ctx context.Context, obj *gqlmodel.SeasonCalendarEntry) (*gqlmodel.Event, error) {
	if obj.Event == nil {
		return nil, nil
	}
	return r.QueryRoot().Event(ctx, obj.Event.ID)
}

// Season is the resolver for the season field.
func (r *seasonCalendarEntryResolver) Season(ctx context.Context, obj *gqlmodel.SeasonCalendarEntry) (*gqlmodel.Season, error) {
	return r.QueryRoot().Season(ctx, obj.Season.ID)
}

// Event is the resolver for the event field.
func (r *showCalendarEntryResolver) Event(ctx context.Context, obj *gqlmodel.ShowCalendarEntry) (*gqlmodel.Event, error) {
	if obj.Event == nil {
		return nil, nil
	}
	return r.QueryRoot().Event(ctx, obj.Event.ID)
}

// Show is the resolver for the show field.
func (r *showCalendarEntryResolver) Show(ctx context.Context, obj *gqlmodel.ShowCalendarEntry) (*gqlmodel.Show, error) {
	return r.QueryRoot().Show(ctx, obj.Show.ID)
}

// Event is the resolver for the event field.
func (r *simpleCalendarEntryResolver) Event(ctx context.Context, obj *gqlmodel.SimpleCalendarEntry) (*gqlmodel.Event, error) {
	if obj.Event == nil {
		return nil, nil
	}
	return r.QueryRoot().Event(ctx, obj.Event.ID)
}

// Calendar returns generated.CalendarResolver implementation.
func (r *Resolver) Calendar() generated.CalendarResolver { return &calendarResolver{r} }

// EpisodeCalendarEntry returns generated.EpisodeCalendarEntryResolver implementation.
func (r *Resolver) EpisodeCalendarEntry() generated.EpisodeCalendarEntryResolver {
	return &episodeCalendarEntryResolver{r}
}

// SeasonCalendarEntry returns generated.SeasonCalendarEntryResolver implementation.
func (r *Resolver) SeasonCalendarEntry() generated.SeasonCalendarEntryResolver {
	return &seasonCalendarEntryResolver{r}
}

// ShowCalendarEntry returns generated.ShowCalendarEntryResolver implementation.
func (r *Resolver) ShowCalendarEntry() generated.ShowCalendarEntryResolver {
	return &showCalendarEntryResolver{r}
}

// SimpleCalendarEntry returns generated.SimpleCalendarEntryResolver implementation.
func (r *Resolver) SimpleCalendarEntry() generated.SimpleCalendarEntryResolver {
	return &simpleCalendarEntryResolver{r}
}

type calendarResolver struct{ *Resolver }
type episodeCalendarEntryResolver struct{ *Resolver }
type seasonCalendarEntryResolver struct{ *Resolver }
type showCalendarEntryResolver struct{ *Resolver }
type simpleCalendarEntryResolver struct{ *Resolver }
