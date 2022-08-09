package search

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/common"
	"strconv"
)

func (service *Service) seasonToSearchItem(ctx context.Context, season common.Season) (searchItem, error) {
	show, err := service.loaders.ShowLoader.Load(ctx, season.ShowID)()
	if err != nil {
		return searchItem{}, err
	}

	var item = searchItem{
		ID:          "seasons-" + strconv.Itoa(season.ID),
		Title:       season.Title,
		Description: season.Description,
		Header:      nil,
		ShowID:      &season.ShowID,
		ShowTitle:   &show.Title,
		Type:        "season",
	}
	return item, nil
}
