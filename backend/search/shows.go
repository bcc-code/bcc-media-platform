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

func (handler *RequestHandler) mapShowToSearchObject(
	item sqlc.Show,
	image *sqlc.DirectusFile,
) searchObject {
	object := searchObject{}
	itemId := int(item.ID)
	object[idField] = "show-" + strconv.Itoa(itemId)
	object[rolesField] = handler.getRolesForShow(item.ID)
	object[createdAtField] = item.DateCreated.UTC().Unix()
	object[updatedAtField] = item.DateUpdated.UTC().Unix()
	if image != nil {
		object[imageField] = image.GetImageUrl()
	}

	object.assignVisibility(handler.getVisibilityForShow(item.ID))
	title, description := toLocaleStrings(handler.getTranslationsForShow(item.ID))
	object.mapFromLocaleString(titleField, title)
	object.mapFromLocaleString(descriptionField, description)
	return object
}

func (handler *RequestHandler) indexShows(
	items []sqlc.Show,
	imageDict map[uuid.UUID]sqlc.DirectusFile,
	index *search.Index,
) {
	objects := lo.Map(items, func(item sqlc.Show, _ int) searchObject {
		var image *sqlc.DirectusFile
		if item.ImageFileID.Valid {
			imageResult := imageDict[item.ImageFileID.UUID]
			image = &imageResult
		}
		return handler.mapShowToSearchObject(item, image)
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
	object := handler.mapShowToSearchObject(item, thumbnail)

	_, err := service.index.SaveObject(object)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to index season")
	}
}
