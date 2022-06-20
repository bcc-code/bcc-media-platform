package search

import (
	"strconv"

	"github.com/algolia/algoliasearch-client-go/v3/algolia/search"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/google/uuid"
	"github.com/samber/lo"
	"gopkg.in/guregu/null.v4"
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
	showTs []sqlc.ShowsTranslation,
) searchObject {
	object := searchObject{}
	itemId := int(item.ID)
	if roles == nil {
		roles = []string{}
	}
	object[rolesField] = roles
	object[idField] = "season-" + strconv.Itoa(itemId)
	object[createdAtField] = item.DateCreated.UTC().Unix()
	object[updatedAtField] = item.DateUpdated.UTC().Unix()
	object[publishedAtField] = item.PublishDate.UTC().Unix()
	title, description := mapTranslationsForSeason(translations)
	object.mapFromLocaleString(titleField, title)
	object.mapFromLocaleString(descriptionField, description)
	object[showIDField] = item.ShowID
	showTitle, _ := mapTranslationsForShow(showTs)
	object.mapFromLocaleString(showTitleField, showTitle)
	if image != nil {
		object[imageField] = image.GetImageUrl()
	}
	return object
}

func (handler *RequestHandler) indexSeasons(
	items []sqlc.Season,
	rolesDict map[int32][]string,
	imageDict map[uuid.UUID]sqlc.DirectusFile,
	tDict map[int32][]sqlc.SeasonsTranslation,
	showTs map[int32][]sqlc.ShowsTranslation,
	index *search.Index,
) {
	objects := lo.Map(items, func(item sqlc.Season, _ int) searchObject {
		var image *sqlc.DirectusFile
		if item.ImageFileID.Valid {
			thumbnailResult := imageDict[item.ImageFileID.UUID]
			image = &thumbnailResult
		}
		object := mapSeasonToSearchObject(item, rolesDict[item.ID], image, tDict[item.ID], showTs[item.ShowID])
		object.assignVisibility(handler.getVisibilityForSeason(item.ID))
		return object
	})

	err := indexObjects(index, objects)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to index objects")
		return
	}
}

func (handler *RequestHandler) indexSeason(item sqlc.Season) {
	service := handler.service
	ctx := handler.context
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

	roles, err := service.queries.GetRolesForSeason(ctx, null.IntFrom(int64(item.ID)))
	if err != nil {
		log.L.Error().Err(err)
		return
	}

	object := mapSeasonToSearchObject(item, roles, image, ts, showTs)
	object.assignVisibility(handler.getVisibilityForSeason(item.ID))
	_, err = service.index.SaveObject(object)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to index season")
	}
}
