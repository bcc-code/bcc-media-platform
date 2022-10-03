package model

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/user"
	"github.com/bcc-code/brunstadtv/backend/utils"
	"strconv"
	"time"
)

// EventFrom returns a gql event from event
func EventFrom(ctx context.Context, i *common.Event) *Event {
	ginCtx, _ := utils.GinCtx(ctx)
	languages := user.GetLanguagesFromCtx(ginCtx)

	return &Event{
		ID:    strconv.Itoa(i.ID),
		Title: i.Title.Get(languages),
		Start: i.Start.UTC().Format(time.RFC3339),
		End:   i.End.UTC().Format(time.RFC3339),
	}
}
