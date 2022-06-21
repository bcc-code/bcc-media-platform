package search

import (
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

func (handler *RequestHandler) mapSeasonToSearchObject(
	item sqlc.Season,
	image *sqlc.DirectusFile,
) searchObject {
	object := searchObject{}
	itemId := int(item.ID)
	object[rolesField] = handler.getRolesForSeason(item.ID)
	object[idField] = "season-" + strconv.Itoa(itemId)
	if item.DateCreated.Valid {
		object[createdAtField] = item.DateCreated.Time.UTC().Unix()
	}
	if item.DateUpdated.Valid {
		object[updatedAtField] = item.DateUpdated.Time.UTC().Unix()
	}
	object[publishedAtField] = item.PublishDate.UTC().Unix()
	if image != nil {
		object[imageField] = image.GetImageUrl()
	}

	object.assignVisibility(handler.getVisibilityForSeason(item.ID))
	title, description := toLocaleStrings(handler.getTranslationsForSeason(item.ID))
	object.mapFromLocaleString(titleField, title)
	object.mapFromLocaleString(descriptionField, description)
	showTitle, _ := toLocaleStrings(handler.getTranslationsForShow(item.ShowID))
	object.mapFromLocaleString(showTitleField, showTitle)
	return object
}

func (handler *RequestHandler) indexSeasons(
	items []sqlc.Season,
	imageDict map[uuid.UUID]sqlc.DirectusFile,
	index *search.Index,
) {
	objects := lo.Map(items, func(item sqlc.Season, _ int) searchObject {
		var image *sqlc.DirectusFile
		if item.ImageFileID.Valid {
			thumbnailResult := imageDict[item.ImageFileID.UUID]
			image = &thumbnailResult
		}
		return handler.mapSeasonToSearchObject(item, image)
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

	object := handler.mapSeasonToSearchObject(item, image)
	_, err := service.index.SaveObject(object)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to index season")
	}
}
