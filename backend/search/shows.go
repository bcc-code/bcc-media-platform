package search

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/common"
	"strconv"
)

func (service *Service) showToSearchItem(ctx context.Context, show common.Show) (searchItem, error) {
	var legacyID *int
	if show.LegacyID.Valid {
		v := int(show.LegacyID.Int64)
		legacyID = &v
	}

	var item = searchItem{
		ID:          "shows-" + strconv.Itoa(show.ID),
		LegacyID:    legacyID,
		Title:       show.Title,
		Description: show.Description,
		Header:      nil,
		Type:        "show",
	}

	err := item.assignTags(ctx, service.loaders, show)
	return item, err
}
