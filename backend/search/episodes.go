package search

import (
	"context"
	"fmt"
	"strconv"

	"github.com/bcc-code/bcc-media-platform/backend/common"
)

func (service *Service) episodeToSearchItem(ctx context.Context, episode common.Episode) (searchItem, error) {
	var header *string
	var showID *int
	var showTitle *common.LocaleString
	var seasonID *int
	var seasonTitle *common.LocaleString

	if episode.SeasonID.Valid {
		sID := int(episode.SeasonID.Int64)
		seasonID = &sID
		season, err := service.loaders.SeasonLoader.Load(ctx, sID)()
		if err != nil {
			return searchItem{}, err
		}
		if season != nil {
			shID := season.ShowID
			showID = &shID
			show, err := service.loaders.ShowLoader.Load(ctx, shID)()
			if err != nil {
				return searchItem{}, err
			}

			showID = &show.ID
			showTitle = &show.Title
			seasonID = &season.ID
			seasonTitle = &season.Title

			if episode.Number.Valid {
				headerString := fmt.Sprintf("S%d:E%d", season.Number, episode.Number.Int64)
				header = &headerString
			}
		}
	}

	var legacyID *int
	if episode.LegacyID.Valid {
		v := int(episode.LegacyID.Int64)
		legacyID = &v
	}

	if episode.LegacyProgramID.Valid {
		v := int(episode.LegacyProgramID.Int64)
		legacyID = &v
	}

	image := episode.Images.GetDefault([]string{"no"}, common.ImageStyleDefault)

	var item = searchItem{
		ID:          "episodes-" + strconv.Itoa(episode.ID),
		LegacyID:    legacyID,
		Title:       episode.Title,
		Description: episode.Description,
		Header:      header,
		ShowID:      showID,
		ShowTitle:   showTitle,
		SeasonID:    seasonID,
		SeasonTitle: seasonTitle,
		Type:        "episode",
		AgeRating:   &episode.AgeRating,
		Duration:    &episode.Duration,
		Image:       image,
	}

	err := item.assignTags(ctx, service.loaders, episode)
	return item, err
}
