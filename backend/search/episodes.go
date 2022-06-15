package search

import (
	"context"
	"fmt"
	"github.com/algolia/algoliasearch-client-go/v3/algolia/search"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/google/uuid"
	"github.com/samber/lo"
	"strconv"
)

func mapTranslationsForEpisode(translations []sqlc.EpisodesTranslation) (title map[string]string, description map[string]string) {
	title = map[string]string{}
	description = map[string]string{}
	for _, translation := range translations {
		language := translation.LanguagesCode
		if value := translation.Title.ValueOrZero(); value != "" {
			title[language] = value
		}
		if value := translation.Description.ValueOrZero(); value != "" {
			description[language] = value
		}
		if value := translation.ExtraDescription.ValueOrZero(); value != "" {
			if description[language] == "" {
				description[language] = value
			} else {
				description[language] += "\n" + value
			}
		}
	}
	return title, description
}

func mapEpisodeToSearchObject(item sqlc.Episode, image *sqlc.DirectusFile, translations []sqlc.EpisodesTranslation, season *sqlc.Season, seasonTs []sqlc.SeasonsTranslation, showTs []sqlc.ShowsTranslation) searchObject {
	object := searchObject{}
	itemId := int(item.ID)
	object[idField] = "episode-" + strconv.Itoa(itemId)
	object["type"] = item.Type
	if value := item.AvailableTo.ValueOrZero(); !value.IsZero() {
		object["availableTo"] = value.UTC()
	}
	if value := item.AvailableFrom.ValueOrZero(); !value.IsZero() {
		object["availableFrom"] = value.UTC()
	}
	if item.DateCreated.Valid {
		object[createdAtField] = item.DateCreated.Time.UTC()
	}
	if item.DateUpdated.Valid {
		object[updatedAtField] = item.DateUpdated.Time.UTC()
	}
	object[publishedAtField] = item.PublishDate.UTC()
	object[titleField], object[descriptionField] = mapTranslationsForEpisode(translations)

	if image != nil {
		object[imageField] = image.GetImageUrl()
	}
	if season != nil {
		if value := item.EpisodeNumber.ValueOrZero(); value != 0 {
			object[headerField] = fmt.Sprintf("S%d:E%d", season.SeasonNumber, value)
		}
		object[seasonIDField] = season.ID
		object[seasonTitleField], _ = mapTranslationsForSeason(seasonTs)
		object[showIDField] = season.ShowID
		object[showTitleField], _ = mapTranslationsForShow(showTs)
	}
	return object
}

func indexEpisodes(
	items []sqlc.Episode,
	imageDict map[uuid.UUID]sqlc.DirectusFile,
	tDict map[int][]sqlc.EpisodesTranslation,
	seasons map[int]sqlc.Season,
	seasonTs map[int][]sqlc.SeasonsTranslation,
	showTs map[int][]sqlc.ShowsTranslation,
	index *search.Index,
) {
	objects := lo.Map(items, func(item sqlc.Episode, _ int) searchObject {
		var season *sqlc.Season
		var seasonTranslations []sqlc.SeasonsTranslation
		var showTranslations []sqlc.ShowsTranslation
		if item.SeasonID.Valid {
			seasonResult := seasons[int(item.SeasonID.Int64)]
			season = &seasonResult
			seasonTranslations = seasonTs[int(season.ID)]
			showTranslations, _ = showTs[int(season.ShowID)]
		}
		var thumbnail *sqlc.DirectusFile
		if item.ImageFileID.Valid {
			thumbnailResult := imageDict[item.ImageFileID.UUID]
			thumbnail = &thumbnailResult
		}
		return mapEpisodeToSearchObject(item, thumbnail, tDict[int(item.ID)], season, seasonTranslations, showTranslations)
	})

	err := indexObjects(index, objects)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to index objects")
		return
	}
}

func (service *Service) indexEpisode(item sqlc.Episode) {
	ctx := context.Background()
	ts, err := service.queries.GetTranslationsForEpisode(ctx, item.ID)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to retrieve translations for season")
	}

	var season *sqlc.Season
	var seasonTs []sqlc.SeasonsTranslation
	var showTs []sqlc.ShowsTranslation
	if item.SeasonID.Valid {
		seasonResult, _ := service.queries.GetSeason(ctx, int32(item.SeasonID.Int64))
		season = &seasonResult
		seasonTs, _ = service.queries.GetTranslationsForSeason(ctx, int32(item.SeasonID.Int64))
		showTs, _ = service.queries.GetTranslationsForShow(ctx, season.ShowID)
	}

	var thumbnail *sqlc.DirectusFile
	if item.ImageFileID.Valid {
		thumbnailResult, _ := service.queries.GetFile(ctx, item.ImageFileID.UUID)
		thumbnail = &thumbnailResult
	}

	_, err = service.index.SaveObject(mapEpisodeToSearchObject(item, thumbnail, ts, season, seasonTs, showTs))
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to index season")
	}
}
