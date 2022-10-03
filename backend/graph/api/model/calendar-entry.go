package model

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/user"
	"github.com/bcc-code/brunstadtv/backend/utils"
	"github.com/bcc-code/mediabank-bridge/log"
	"strconv"
	"time"
)

// CalendarEntryFrom returns a gql entry from entry
func CalendarEntryFrom(ctx context.Context, i *common.CalendarEntry) CalendarEntry {
	ginCtx, _ := utils.GinCtx(ctx)
	languages := user.GetLanguagesFromCtx(ginCtx)

	id := strconv.Itoa(i.ID)
	var event *Event
	if i.EventID.Valid {
		event = &Event{
			ID: strconv.Itoa(int(i.EventID.Int64)),
		}
	}
	title := i.Title.Get(languages)
	description := i.Description.Get(languages)
	start := i.Start.Format(time.RFC3339)
	end := i.End.Format(time.RFC3339)

	if !i.Type.Valid {
		return &SimpleCalendarEntry{
			ID:          id,
			Event:       event,
			Title:       title,
			Description: description,
			Start:       start,
			End:         end,
		}
	}

	itemID := strconv.Itoa(int(i.ItemID.ValueOrZero()))

	switch i.Type.String {
	case "episode":
		return &EpisodeCalendarEntry{
			ID:          id,
			Event:       event,
			Title:       title,
			Description: description,
			Start:       start,
			End:         end,
			Episode: &Episode{
				ID: itemID,
			},
		}
	case "season":
		return &SeasonCalendarEntry{
			ID:          id,
			Event:       event,
			Title:       title,
			Description: description,
			Start:       start,
			End:         end,
			Season: &Season{
				ID: itemID,
			},
		}
	case "show":
		return &ShowCalendarEntry{
			ID:          id,
			Event:       event,
			Title:       title,
			Description: description,
			Start:       start,
			End:         end,
			Show: &Show{
				ID: itemID,
			},
		}
	}
	log.L.Error().Str("type", i.Type.ValueOrZero()).Msg("Invalid type for CalendarEntry")
	return SimpleCalendarEntry{}
}
