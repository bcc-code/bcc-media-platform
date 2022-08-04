package search

import (
	"context"
	"encoding/json"
	"fmt"
	"github.com/bcc-code/brunstadtv/backend/common"
	"strconv"

	"github.com/bcc-code/brunstadtv/backend/sqlc"
)

func (service *Service) episodeToSearchItem(ctx context.Context, episode sqlc.EpisodeExpanded) (searchItem, error) {
	var title common.LocaleString
	var description common.LocaleString
	_ = json.Unmarshal(episode.Title, &title)
	_ = json.Unmarshal(episode.Description, &description)

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
		_ = json.Unmarshal(season.Title, &seasonTitle)
		shID := int(season.ShowID)
		showID = &shID
		show, err := service.loaders.ShowLoader.Load(ctx, shID)()
		if err != nil {
			return searchItem{}, err
		}
		_ = json.Unmarshal(show.Title, &showTitle)

		if episode.EpisodeNumber.Valid {
			headerString := fmt.Sprintf("S%d:E%d", season.SeasonNumber, episode.EpisodeNumber.Int64)
			header = &headerString
		}
	}

	var item = searchItem{
		ID:          "episode-" + strconv.Itoa(int(episode.ID)),
		Title:       title,
		Description: description,
		Header:      header,
		ShowID:      showID,
		ShowTitle:   showTitle,
		SeasonID:    seasonID,
		SeasonTitle: seasonTitle,
		Type:        episode.Type,
	}
	return item, nil
}
