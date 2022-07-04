package search

import (
	"context"
	"strconv"

	"github.com/algolia/algoliasearch-client-go/v3/algolia/search"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/google/uuid"
	"github.com/samber/lo"
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

func (service *Service) mapSeasonToSearchObject(
	ctx context.Context,
	item sqlc.Season,
	image *sqlc.DirectusFile,
) searchObject {
	object := searchObject{}
	itemId := int(item.ID)
	object[rolesField] = service.getRolesForSeason(ctx, item.ID)
	object[idField] = "seasons-" + strconv.Itoa(itemId)
	object[createdAtField] = item.DateCreated.UTC().Unix()
	object[updatedAtField] = item.DateUpdated.UTC().Unix()
	object[publishedAtField] = item.PublishDate.UTC().Unix()
	if image != nil {
		object[imageField] = image.GetImageUrl()
	}

	object.assignVisibility(service.getVisibilityForSeason(ctx, item.ID))
	title, description := toLocaleStrings(service.getTranslationsForSeason(ctx, item.ID))
	object.mapFromLocaleString(titleField, title)
	object.mapFromLocaleString(descriptionField, description)
	showTitle, _ := toLocaleStrings(service.getTranslationsForShow(ctx, item.ShowID))
	object.mapFromLocaleString(showTitleField, showTitle)
	return object
}

func (service *Service) indexSeasons(
	ctx context.Context,
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
		return service.mapSeasonToSearchObject(ctx, item, image)
	})

	err := indexObjects(index, objects)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to index objects")
		return
	}
}

func (service *Service) indexSeason(ctx context.Context, item sqlc.Season) {
	var image *sqlc.DirectusFile
	if item.ImageFileID.Valid {
		thumbnailResult, _ := service.queries.GetFile(ctx, item.ImageFileID.UUID)
		image = &thumbnailResult
	}

	object := service.mapSeasonToSearchObject(ctx, item, image)
	_, err := service.index.SaveObject(object)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to index season")
	}
}
