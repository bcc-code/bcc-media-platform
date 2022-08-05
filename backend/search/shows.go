package search

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/common"
	"strconv"
)

func (service *Service) showToSearchItem(_ context.Context, show common.Show) (searchItem, error) {

	var item = searchItem{
		ID:          "shows-" + strconv.Itoa(show.ID),
		Title:       show.Title,
		Description: show.Description,
		Header:      nil,
		Type:        "show",
	}
	return item, nil
}
