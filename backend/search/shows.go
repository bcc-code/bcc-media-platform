package search

import (
	"strconv"

	"github.com/algolia/algoliasearch-client-go/v3/algolia/search"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/google/uuid"
	"github.com/samber/lo"
)

func mapTranslationsForShow(translations []sqlc.ShowsTranslation) (title localeString, description localeString) {
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

func mapShowToSearchObject(
	item sqlc.Show,
	roles []string,
	image *sqlc.DirectusFile,
	translations []sqlc.ShowsTranslation,
) searchObject {
	object := searchObject{}
	itemId := int(item.ID)
	object[idField] = "show-" + strconv.Itoa(itemId)
	if roles == nil {
		roles = []string{}
	}
	object[rolesField] = roles
	object[createdAtField] = item.DateCreated.UTC().Unix()
	object[updatedAtField] = item.DateUpdated.UTC().Unix()
	title, description := mapTranslationsForShow(translations)
	object.mapFromLocaleString(titleField, title)
	object.mapFromLocaleString(descriptionField, description)
	if image != nil {
		object[imageField] = image.GetImageUrl()
	}
	return object
}

func (handler *RequestHandler) indexShows(
	items []sqlc.Show,
	roleDict map[int32][]string,
	imageDict map[uuid.UUID]sqlc.DirectusFile,
	tDict map[int32][]sqlc.ShowsTranslation,
	index *search.Index,
) {
	objects := lo.Map(items, func(item sqlc.Show, _ int) searchObject {
		var image *sqlc.DirectusFile
		if item.ImageFileID.Valid {
			imageResult := imageDict[item.ImageFileID.UUID]
			image = &imageResult
		}
		object := mapShowToSearchObject(item, roleDict[item.ID], image, tDict[item.ID])
		object.assignVisibility(handler.getVisibilityForShow(item.ID))
		return object
	})

	err := indexObjects(index, objects)

	if err != nil {
		log.L.Error().Err(err).Msg("Failed to index objects")
		return
	}
}

func (handler *RequestHandler) indexShow(item sqlc.Show) {
	service := handler.service
	ctx := handler.context
	var thumbnail *sqlc.DirectusFile
	if item.ImageFileID.Valid {
		thumbnailResult, _ := service.queries.GetFile(ctx, item.ImageFileID.UUID)
		thumbnail = &thumbnailResult
	}
	translations, err := service.queries.GetTranslationsForShow(ctx, item.ID)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to retrieve translations for season")
		return
	}
	roles, err := service.queries.GetRolesForShow(ctx, item.ID)
	if err != nil {
		log.L.Error().Err(err)
		return
	}
	object := mapShowToSearchObject(item, roles, thumbnail, translations)
	object.assignVisibility(handler.getVisibilityForShow(item.ID))
	_, err = service.index.SaveObject(object)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to index season")
	}
}
