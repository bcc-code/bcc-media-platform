package gqlmodel

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"strconv"
)

// CollectionFromSQL converts sqlc.CollectionExpanded to Collection
func CollectionFromSQL(_ context.Context, item *sqlc.CollectionExpanded) *Collection {
	id := strconv.Itoa(int(item.ID))
	return &Collection{
		ID: id,
	}
}
