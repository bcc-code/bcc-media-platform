package search

import (
	"context"
	"github.com/algolia/algoliasearch-client-go/v3/algolia/search"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/google/uuid"
	"github.com/samber/lo"
	"strconv"
)

func mapTranslationsForSeason(translations []sqlc.SeasonsTranslation) (title localeString, description localeString) {
	title = localeString{}
	description = localeString{}
	for _, translation := range translations {
		language := translation.LanguagesCode
		if titleString := translation.Title.ValueOrZero(); titleString != "" {
			title[language] = titleString
		}
		if descriptionString := translation.Description.ValueOrZero(); descriptionString != "" {
			description[language] = descriptionString
		}
	}
	return
}

func mapSeasonToSearchObject(
	item sqlc.Season,
	image *sqlc.DirectusFile,
	translations []sqlc.SeasonsTranslation,
	showTs []sqlc.ShowsTranslation,
) searchObject {
	object := searchObject{}
	itemId := int(item.ID)
	object[idField] = "season-" + strconv.Itoa(itemId)
	if item.DateCreated.Valid {
		object[createdAtField] = item.DateCreated.Time.UTC()
	}
	if item.DateUpdated.Valid {
		object[updatedAtField] = item.DateUpdated.Time.UTC()
	}
	object[publishedAtField] = item.PublishDate.UTC()
	object[titleField], object[descriptionField] = mapTranslationsForSeason(translations)
	object[showIDField] = item.ShowID
	object[showTitleField], _ = mapTranslationsForShow(showTs)
	if image != nil {
		object[imageField] = image.GetImageUrl()
	}
	return object
}

func indexSeasons(
	items []sqlc.Season,
	imageDict map[uuid.UUID]sqlc.DirectusFile,
	tDict map[int][]sqlc.SeasonsTranslation,
	showTs map[int][]sqlc.ShowsTranslation,
	index *search.Index,
) {
	objects := lo.Map(items, func(item sqlc.Season, _ int) searchObject {
		var thumbnail *sqlc.DirectusFile
		if item.ImageFileID.Valid {
			thumbnailResult := imageDict[item.ImageFileID.UUID]
			thumbnail = &thumbnailResult
		}
		return mapSeasonToSearchObject(item, thumbnail, tDict[int(item.ID)], showTs[int(item.ShowID)])
	})

	err := indexObjects(index, objects)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to index objects")
		return
	}
}

func (service *Service) indexSeason(item sqlc.Season) {
	ctx := context.Background()
	var thumbnail *sqlc.DirectusFile
	if item.ImageFileID.Valid {
		thumbnailResult, _ := service.queries.GetFile(ctx, item.ImageFileID.UUID)
		thumbnail = &thumbnailResult
	}
	ts, err := service.queries.GetTranslationsForSeason(ctx, item.ID)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to retrieve translations for season")
	}
	showTs, err := service.queries.GetTranslationsForShow(ctx, item.ShowID)
	_, err = service.index.SaveObject(mapSeasonToSearchObject(item, thumbnail, ts, showTs))
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to index season")
	}
}
