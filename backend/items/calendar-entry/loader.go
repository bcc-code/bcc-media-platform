package calendar_entry

import (
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/graph-gophers/dataloader/v7"
)

// NewBatchLoader returns a configured batch loader for calendarentries
func NewBatchLoader(queries sqlc.Queries) *dataloader.Loader[int, *common.CalendarEntry] {
	return common.NewBatchLoader(queries.GetCalendarEntries)
}
