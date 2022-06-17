package search

import (
	"context"
	"fmt"
	"github.com/algolia/algoliasearch-client-go/v3/algolia/search"
	"github.com/bcc-code/brunstadtv/backend/base"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/google/uuid"
	"github.com/samber/lo"
	"strconv"
	"time"
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

func unixOrZero(timeStamp time.Time) int64 {
	if !timeStamp.IsZero() {
		return timeStamp.Unix()
	}
	return 0
}

func mapEpisodeToSearchObject(
	item sqlc.Episode,
	roles []string,
	image *sqlc.DirectusFile,
	translations []sqlc.EpisodesTranslation,
	season *sqlc.Season,
	seasonTs []sqlc.SeasonsTranslation,
	show *sqlc.Show,
	showTs []sqlc.ShowsTranslation,
) searchObject {
	object := searchObject{}
	itemId := int(item.ID)
	object[idField] = "episode-" + strconv.Itoa(itemId)
	object[typeField] = item.Type
	if roles == nil {
		roles = []string{}
	}
	object[rolesField] = roles
	if season != nil {
		object[statusField] = base.MostRestrictiveStatus(item.Status, season.Status, show.Status)
		object[availableToField] = unixOrZero(
			smallestTime(
				item.AvailableTo.ValueOrZero(),
				season.AvailableTo.ValueOrZero(),
				show.AvailableTo.ValueOrZero(),
			),
		)
		object[availableFromField] = unixOrZero(
			largestTime(
				item.AvailableFrom.ValueOrZero(),
				season.AvailableFrom.ValueOrZero(),
				show.AvailableFrom.ValueOrZero(),
			),
		)
	} else {
		object[statusField] = item.Status
		object[availableToField] = unixOrZero(item.AvailableTo.ValueOrZero())
		object[availableFromField] = unixOrZero(item.AvailableFrom.ValueOrZero())
	}
	if item.DateCreated.Valid {
		object[createdAtField] = item.DateCreated.Time.UTC().Unix()
	}
	if item.DateUpdated.Valid {
		object[updatedAtField] = item.DateUpdated.Time.UTC().Unix()
	}
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
		object[seasonIDField] = season.ID
		seasonTitle, _ := mapTranslationsForSeason(seasonTs)
		object.mapFromLocaleString(seasonTitleField, seasonTitle)
		object[showIDField] = season.ShowID
		showTitle, _ := mapTranslationsForShow(showTs)
		object.mapFromLocaleString(showTitleField, showTitle)
	}
	return object
}

func indexEpisodes(
	items []sqlc.Episode,
	rolesDict map[int32][]string,
	imageDict map[uuid.UUID]sqlc.DirectusFile,
	tDict map[int32][]sqlc.EpisodesTranslation,
	seasons map[int32]sqlc.Season,
	seasonTs map[int32][]sqlc.SeasonsTranslation,
	shows map[int32]sqlc.Show,
	showTs map[int32][]sqlc.ShowsTranslation,
	index *search.Index,
) {
	objects := lo.Map(items, func(item sqlc.Episode, _ int) searchObject {
		var season *sqlc.Season
		var show *sqlc.Show
		var seasonTranslations []sqlc.SeasonsTranslation
		var showTranslations []sqlc.ShowsTranslation
		if item.SeasonID.Valid {
			seasonResult := seasons[int32(item.SeasonID.ValueOrZero())]
			season = &seasonResult
			seasonTranslations = seasonTs[season.ID]
			showResult := shows[season.ShowID]
			show = &showResult
			showTranslations, _ = showTs[season.ShowID]
		}
		var thumbnail *sqlc.DirectusFile
		if item.ImageFileID.Valid {
			thumbnailResult := imageDict[item.ImageFileID.UUID]
			thumbnail = &thumbnailResult
		}
		return mapEpisodeToSearchObject(item, rolesDict[item.ID], thumbnail, tDict[item.ID], season, seasonTranslations, show, showTranslations)
	})

	err := indexObjects(index, objects)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to index objects")
		return
	}
}

func (service *Service) indexEpisode(item sqlc.Episode) {
	ctx := context.Background()
	ts, err := service.queries.GetTranslationsForEpisode(ctx, item.ID)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to retrieve translations for season")
	}

	var season *sqlc.Season
	var seasonTs []sqlc.SeasonsTranslation
	var showTs []sqlc.ShowsTranslation
	var show *sqlc.Show
	if item.SeasonID.Valid {
		seasonResult, _ := service.queries.GetSeason(ctx, int32(item.SeasonID.Int64))
		season = &seasonResult
		seasonTs, _ = service.queries.GetTranslationsForSeason(ctx, int32(item.SeasonID.Int64))
		showResult, _ := service.queries.GetShow(ctx, season.ShowID)
		show = &showResult
		showTs, _ = service.queries.GetTranslationsForShow(ctx, season.ShowID)
	}

	var image *sqlc.DirectusFile
	if item.ImageFileID.Valid {
		thumbnailResult, _ := service.queries.GetFile(ctx, item.ImageFileID.UUID)
		image = &thumbnailResult
	}

	roles, _ := service.queries.GetRolesForEpisode(ctx, item.ID)

	_, err = service.index.SaveObject(mapEpisodeToSearchObject(item, roles, image, ts, season, seasonTs, show, showTs))
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to index season")
	}
}
