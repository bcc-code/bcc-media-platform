package search

import (
	"context"
	"fmt"
	"strconv"

	"github.com/algolia/algoliasearch-client-go/v3/algolia/search"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/google/uuid"
	"github.com/samber/lo"
)

func (handler *RequestHandler) mapEpisodeToSearchObject(
	ctx context.Context,
	item sqlc.Episode,
	image *sqlc.DirectusFile,
	season *sqlc.Season,
) searchObject {
	object := searchObject{}
	itemId := int(item.ID)
	object[idField] = "episodes-" + strconv.Itoa(itemId)
	object[typeField] = item.Type
	object[rolesField] = handler.getRolesForEpisode(ctx, item.ID)

	object[createdAtField] = item.DateCreated.UTC().Unix()
	object[updatedAtField] = item.DateUpdated.UTC().Unix()
	object[publishedAtField] = item.PublishDate.UTC().Unix()

	if image != nil {
		object[imageField] = image.GetImageUrl()
	}
	if season != nil {
		if value := item.EpisodeNumber.ValueOrZero(); value != 0 {
			object[headerField] = fmt.Sprintf("S%d:E%d", season.SeasonNumber, value)
		}
	}

	object.assignVisibility(handler.getVisibilityForEpisode(ctx, item.ID))
	title, description := toLocaleStrings(handler.getTranslationsForEpisode(ctx, item.ID))
	object.mapFromLocaleString(titleField, title)
	object.mapFromLocaleString(descriptionField, description)
	if season != nil {
		object[seasonIDField] = season.ID
		seasonTitle, _ := toLocaleStrings(handler.getTranslationsForSeason(ctx, season.ID))
		object.mapFromLocaleString(seasonTitleField, seasonTitle)

		object[showIDField] = season.ShowID
		showTitle, _ := toLocaleStrings(handler.getTranslationsForShow(ctx, season.ShowID))
		object.mapFromLocaleString(showTitleField, showTitle)
	}

	return object
}

func (handler *RequestHandler) indexEpisodes(
	ctx context.Context,
	items []sqlc.Episode,
	imageDict map[uuid.UUID]sqlc.DirectusFile,
	seasonById map[int32]sqlc.Season,
	index *search.Index,
) {
	objects := lo.Map(items, func(item sqlc.Episode, _ int) searchObject {
		var season *sqlc.Season
		if item.SeasonID.Valid {
			seasonResult := seasonById[int32(item.SeasonID.ValueOrZero())]
			season = &seasonResult
		}
		var thumbnail *sqlc.DirectusFile
		if item.ImageFileID.Valid {
			thumbnailResult := imageDict[item.ImageFileID.UUID]
			thumbnail = &thumbnailResult
		}
		return handler.mapEpisodeToSearchObject(ctx, item, thumbnail, season)
	})

	err := indexObjects(index, objects)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to index objects")
		return
	}
}

func (handler *RequestHandler) indexEpisode(ctx context.Context, item sqlc.Episode) {
	service := handler.service

	var image *sqlc.DirectusFile
	if item.ImageFileID.Valid {
		thumbnailResult, _ := service.queries.GetFile(ctx, item.ImageFileID.UUID)
		image = &thumbnailResult
	}

	var season *sqlc.Season
	if item.SeasonID.Valid {
		seasonResult, _ := service.queries.GetSeason(ctx, int32(item.SeasonID.ValueOrZero()))
		season = &seasonResult
	}

	object := handler.mapEpisodeToSearchObject(ctx, item, image, season)

	_, err := service.index.SaveObject(object)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to index episode")
	}
}
