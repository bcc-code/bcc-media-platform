package search

import (
	"context"
	"strconv"

	"github.com/algolia/algoliasearch-client-go/v3/algolia/search"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
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

func (service *Service) mapShowToSearchObject(
	ctx context.Context,
	item sqlc.Show,
	image *sqlc.DirectusFile,
) searchObject {
	object := searchObject{}
	itemId := int(item.ID)
	object[idField] = "shows-" + strconv.Itoa(itemId)
	object[rolesField] = service.getRolesForShow(ctx, item.ID)
	object[createdAtField] = item.DateCreated.UTC().Unix()
	object[updatedAtField] = item.DateUpdated.UTC().Unix()
	if image != nil {
		object[imageField] = image.GetImageUrl()
	}

	object.assignVisibility(service.getVisibilityForShow(ctx, item.ID))
	title, description := toLocaleStrings(service.getTranslationsForShow(ctx, item.ID))
	object.mapFromLocaleString(titleField, title)
	object.mapFromLocaleString(descriptionField, description)
	return object
}

func (service *Service) indexShows(
	ctx context.Context,
	items []sqlc.Show,
	imageDict map[uuid.UUID]sqlc.DirectusFile,
	index *search.Index,
) error {
	objects := lo.Map(items, func(item sqlc.Show, _ int) searchObject {
		var image *sqlc.DirectusFile
		if item.ImageFileID.Valid {
			imageResult := imageDict[item.ImageFileID.UUID]
			image = &imageResult
		}
		return service.mapShowToSearchObject(ctx, item, image)
	})

	return indexObjects(index, objects)
}

func (service *Service) indexShow(ctx context.Context, item sqlc.Show) error {
	var thumbnail *sqlc.DirectusFile
	if item.ImageFileID.Valid {
		thumbnailResult, _ := service.queries.GetFile(ctx, item.ImageFileID.UUID)
		thumbnail = &thumbnailResult
	}
	object := service.mapShowToSearchObject(ctx, item, thumbnail)

	_, err := service.index.SaveObject(object)
	return err
}
