package search

import (
	"context"
	"encoding/json"
	"github.com/bcc-code/brunstadtv/backend/common"
	"strconv"

	"github.com/bcc-code/brunstadtv/backend/sqlc"
)

func (service *Service) seasonToSearchItem(ctx context.Context, season sqlc.SeasonExpanded) (searchItem, error) {
	var title common.LocaleString
	var description common.LocaleString
	_ = json.Unmarshal(season.Title, &title)
	_ = json.Unmarshal(season.Description, &description)

	showID := int(season.ShowID)
	show, err := service.loaders.ShowLoader.Load(ctx, showID)()
	if err != nil {
		return searchItem{}, err
	}

	var showTitle common.LocaleString
	_ = json.Unmarshal(show.Title, &showTitle)

	var item = searchItem{
		ID:          "seasons-" + strconv.Itoa(int(season.ID)),
		Title:       title,
		Description: description,
		Header:      nil,
		ShowID:      &showID,
		ShowTitle:   &showTitle,
		Type:        "season",
	}
	return item, nil
}
