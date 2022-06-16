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
	object[statusField] = item.Status
	object[rolesField] = roles
	if item.DateCreated.Valid {
		object[createdAtField] = item.DateCreated.Time.UTC().Unix()
	}
	if item.DateUpdated.Valid {
		object[updatedAtField] = item.DateUpdated.Time.UTC().Unix()
	}
	object[publishedAtField] = item.PublishDate.UTC()
	object[titleField], object[descriptionField] = mapTranslationsForShow(translations)
	if image != nil {
		object[imageField] = image.GetImageUrl()
	}
	return object
}

func indexShows(
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
		return mapShowToSearchObject(item, roleDict[item.ID], image, tDict[item.ID])
	})

	err := indexObjects(index, objects)

	if err != nil {
		log.L.Error().Err(err).Msg("Failed to index objects")
		return
	}
}

func (service *Service) indexShow(item sqlc.Show) {
	ctx := context.Background()
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
	_, err = service.index.SaveObject(mapShowToSearchObject(item, roles, thumbnail, translations))
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to index season")
	}
}
