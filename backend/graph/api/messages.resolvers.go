package graph

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.

import (
	"context"
	"time"

	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/graph/api/generated"
	"github.com/bcc-code/brunstadtv/backend/graph/api/model"
	"github.com/bcc-code/brunstadtv/backend/user"
	"github.com/bcc-code/brunstadtv/backend/utils"
	"github.com/samber/lo"
)

// Maintenance is the resolver for the maintenance field.
func (r *messagesResolver) Maintenance(ctx context.Context, obj *model.Messages, timestamp *string) ([]*model.MaintenanceMessage, error) {
	messages, err := withCacheAndTimestamp(ctx, "maintenance_messages", r.Queries.GetMaintenanceMessages, time.Second*30, timestamp)
	if err != nil {
		return nil, err
	}
	return lo.Map(messages, func(m common.MaintenanceMessage, _ int) *model.MaintenanceMessage {
		ginCtx, _ := utils.GinCtx(ctx)
		languages := user.GetLanguagesFromCtx(ginCtx)

		return &model.MaintenanceMessage{
			Message: m.Message.Get(languages),
			Details: m.Details.GetValueOrNil(languages),
		}
	}), nil
}

// Messages returns generated.MessagesResolver implementation.
func (r *Resolver) Messages() generated.MessagesResolver { return &messagesResolver{r} }

type messagesResolver struct{ *Resolver }
