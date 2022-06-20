package search

import (
	"fmt"
	"strconv"
	"time"

	"github.com/algolia/algoliasearch-client-go/v3/algolia/search"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/google/uuid"
	"github.com/samber/lo"
)

func mapTranslationsForEpisode(translations []sqlc.EpisodesTranslation) (title map[string]string, description map[string]string) {
	title = map[string]string{}
	description = map[string]string{}
	for _, translation := range translations {
		language := translation.LanguagesCode
		if value := translation.Title.ValueOrZero(); value != "" {
			title[language] = value
		}
		if value := translation.Description.ValueOrZero(); value != "" {
			description[language] = value
		}
		if value := translation.ExtraDescription.ValueOrZero(); value != "" {
			if description[language] == "" {
				description[language] = value
			} else {
				description[language] += "\n" + value
			}
		}
	}
	return title, description
}

func mapEpisodeToSearchObject(
	item sqlc.Episode,
	roles []string,
	image *sqlc.DirectusFile,
	translations []sqlc.EpisodesTranslation,
	season *sqlc.Season,
) searchObject {
	object := searchObject{}
	itemId := int(item.ID)
	object[idField] = "episode-" + strconv.Itoa(itemId)
	object[typeField] = item.Type
	if roles == nil {
		roles = []string{}
	}
	object[rolesField] = roles

	object[createdAtField] = item.DateCreated.UTC().Unix()
	object[updatedAtField] = item.DateUpdated.UTC().Unix()
	object[publishedAtField] = item.PublishDate.UTC().Unix()
	title, description := mapTranslationsForEpisode(translations)
	object.mapFromLocaleString(titleField, title)
	object.mapFromLocaleString(descriptionField, description)

	if image != nil {
		object[imageField] = image.GetImageUrl()
	}
	if season != nil {
		if value := item.EpisodeNumber.ValueOrZero(); value != 0 {
			object[headerField] = fmt.Sprintf("S%d:E%d", season.SeasonNumber, value)
		}
	}
	return object
}

func (handler *RequestHandler) indexEpisodes(
	items []sqlc.Episode,
	rolesDict map[int32][]string,
	imageDict map[uuid.UUID]sqlc.DirectusFile,
	tDict map[int32][]sqlc.EpisodesTranslation,
	seasons map[int32]sqlc.Season,
	seasonTs map[int32][]sqlc.SeasonsTranslation,
	showTs map[int32][]sqlc.ShowsTranslation,
	index *search.Index,
) {
	objects := lo.Map(items, func(item sqlc.Episode, _ int) searchObject {
		var season *sqlc.Season
		var seasonTranslations []sqlc.SeasonsTranslation
		var showTranslations []sqlc.ShowsTranslation
		if item.SeasonID.Valid {
			seasonResult := seasons[int32(item.SeasonID.ValueOrZero())]
			season = &seasonResult
			seasonTranslations = seasonTs[season.ID]
			showTranslations, _ = showTs[season.ShowID]
		}
		var thumbnail *sqlc.DirectusFile
		if item.ImageFileID.Valid {
			thumbnailResult := imageDict[item.ImageFileID.UUID]
			thumbnail = &thumbnailResult
		}
		object := mapEpisodeToSearchObject(item, rolesDict[item.ID], thumbnail, tDict[item.ID], season)
		object.assignVisibility(handler.getVisibilityForEpisode(item.ID))
		if season != nil {
			object.assignSeasonIDAndTitle(int32(item.SeasonID.ValueOrZero()), seasonTranslations)
			object.assignShowIDAndTitle(season.ShowID, showTranslations)
		}
		return object
	})

	err := indexObjects(index, objects)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to index objects")
		return
	}
}

func (handler *RequestHandler) indexEpisode(item sqlc.Episode) {
	service := handler.service
	ctx := handler.context
	ts, err := service.queries.GetTranslationsForEpisode(ctx, item.ID)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to retrieve translations for season")
	}

	var season *sqlc.Season
	var seasonTs []sqlc.SeasonsTranslation
	var showTs []sqlc.ShowsTranslation
	if item.SeasonID.Valid {
		seasonResult, _ := service.queries.GetSeason(ctx, int32(item.SeasonID.Int64))
		season = &seasonResult
		seasonTs, _ = service.queries.GetTranslationsForSeason(ctx, int32(item.SeasonID.Int64))
		showTs, _ = service.queries.GetTranslationsForShow(ctx, season.ShowID)
	}

	var image *sqlc.DirectusFile
	if item.ImageFileID.Valid {
		thumbnailResult, _ := service.queries.GetFile(ctx, item.ImageFileID.UUID)
		image = &thumbnailResult
	}

	roles, _ := service.queries.GetRolesForEpisode(ctx, item.ID)

	object := mapEpisodeToSearchObject(item, roles, image, ts, season)
	object.assignVisibility(handler.getVisibilityForEpisode(item.ID))
	if season != nil {
		object.assignSeasonIDAndTitle(season.ID, seasonTs)
		object.assignShowIDAndTitle(season.ShowID, showTs)
	}

	_, err = service.index.SaveObject(object)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to index season")
	}
}
