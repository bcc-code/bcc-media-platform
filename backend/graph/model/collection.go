package gqlmodel

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"strconv"
)

// CollectionFromSQL converts sqlc.CollectionExpanded to Collection
func CollectionFromSQL(_ context.Context, item *sqlc.CollectionExpanded) Collection {
	id := strconv.Itoa(int(item.ID))
	collection := item.Collection.ValueOrZero()
	switch collection {
	case "pages":
		return &PageCollection{
			ID: id,
		}
	case "shows":
		return &ShowCollection{
			ID: id,
		}
	case "seasons":
		return &SeasonCollection{
			ID: id,
		}
	case "episodes":
		return &EpisodeCollection{
			ID: id,
		}
	}
	return nil
}
