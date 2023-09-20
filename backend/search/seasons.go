package search

import (
	"context"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"strconv"
)

func (service *Service) seasonToSearchItem(ctx context.Context, season common.Season) (searchItem, error) {
	show, err := service.loaders.ShowLoader.Load(ctx, season.ShowID)()
	if err != nil {
		return searchItem{}, err
	}

	var legacyID *int
	if season.LegacyID.Valid {
		v := int(season.LegacyID.Int64)
		legacyID = &v
	}

	var image *string
	if season.Image.Valid {
		image = &season.Image.String
	}

	var item = searchItem{
		ID:          "seasons-" + strconv.Itoa(season.ID),
		LegacyID:    legacyID,
		Title:       season.Title,
		Description: season.Description,
		Header:      nil,
		ShowID:      &season.ShowID,
		ShowTitle:   &show.Title,
		Type:        "season",
		AgeRating:   &season.AgeRating,
		Image:       image,
	}
	err = item.assignTags(ctx, service.loaders, season)
	return item, err
}
