package search

import (
	"context"
	"github.com/algolia/algoliasearch-client-go/v3/algolia/search"
	"github.com/bcc-code/brunstadtv/backend/base"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/google/uuid"
	"github.com/samber/lo"
	"gopkg.in/guregu/null.v4"
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
	roles []string,
	image *sqlc.DirectusFile,
	translations []sqlc.SeasonsTranslation,
	show *sqlc.Show,
	showTs []sqlc.ShowsTranslation,
) searchObject {
	object := searchObject{}
	itemId := int(item.ID)
	object[statusField] = base.MostRestrictiveStatus(item.Status, show.Status)
	object[rolesField] = roles
	object[availableToField] = unixOrZero(smallestTime(item.AvailableTo, show.AvailableTo))
	object[availableFromField] = unixOrZero(largestTime(item.AvailableFrom, show.AvailableFrom))
	object[idField] = "season-" + strconv.Itoa(itemId)
	if item.DateCreated.Valid {
		object[createdAtField] = item.DateCreated.Time.UTC().Unix()
	}
	if item.DateUpdated.Valid {
		object[updatedAtField] = item.DateUpdated.Time.UTC().Unix()
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
	rolesDict map[int32][]string,
	imageDict map[uuid.UUID]sqlc.DirectusFile,
	tDict map[int32][]sqlc.SeasonsTranslation,
	showDict map[int32]sqlc.Show,
	showTs map[int32][]sqlc.ShowsTranslation,
	index *search.Index,
) {
	objects := lo.Map(items, func(item sqlc.Season, _ int) searchObject {
		var image *sqlc.DirectusFile
		if item.ImageFileID.Valid {
			thumbnailResult := imageDict[item.ImageFileID.UUID]
			image = &thumbnailResult
		}
		show, _ := showDict[item.ShowID]
		return mapSeasonToSearchObject(item, rolesDict[item.ID], image, tDict[item.ID], &show, showTs[item.ShowID])
	})

	err := indexObjects(index, objects)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to index objects")
		return
	}
}

func (service *Service) indexSeason(item sqlc.Season) {
	ctx := context.Background()
	var image *sqlc.DirectusFile
	if item.ImageFileID.Valid {
		thumbnailResult, _ := service.queries.GetFile(ctx, item.ImageFileID.UUID)
		image = &thumbnailResult
	}

	ts, err := service.queries.GetTranslationsForSeason(ctx, item.ID)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to retrieve translations for season")
	}

	showTs, err := service.queries.GetTranslationsForShow(ctx, item.ShowID)
	if err != nil {
		log.L.Error().Err(err)
		return
	}

	show, err := service.queries.GetShow(ctx, item.ShowID)
	if err != nil {
		log.L.Error().Err(err)
		return
	}

	roles, err := service.queries.GetRolesForSeason(ctx, null.IntFrom(int64(item.ID)))
	if err != nil {
		log.L.Error().Err(err)
		return
	}
	_, err = service.index.SaveObject(mapSeasonToSearchObject(item, roles, image, ts, &show, showTs))
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to index season")
	}
}

func (service *Service) getSeasonRoles(id int32) {

}
