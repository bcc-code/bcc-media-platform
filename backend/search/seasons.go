package search

import (
	"context"
	"github.com/algolia/algoliasearch-client-go/v3/algolia/search"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/samber/lo"
	"strconv"
)

func getSeasonLanguage(translation sqlc.SeasonsTranslation) string {
	return translation.LanguagesCode
}

func getSeasonTitle(translation sqlc.SeasonsTranslation) string {
	return translation.Title.ValueOrZero()
}

func getSeasonDescription(translation sqlc.SeasonsTranslation) string {
	return translation.Description.ValueOrZero()
}

func mapSeasonToSearchObject(item sqlc.Season, translations []sqlc.SeasonsTranslation) searchObject {
	object := searchObject{}
	itemId := int(item.ID)
	object[idField] = "season-" + strconv.Itoa(itemId)
	if item.DateCreated.Valid {
		object[createdAtField] = item.DateCreated.Time.UTC()
	}
	if item.DateUpdated.Valid {
		object[updatedAtField] = item.DateUpdated.Time.UTC()
	}
	object[publishedAtField] = item.PublishDate.UTC()
	mapTsToObject(object, translations, getSeasonLanguage, getSeasonTitle, getSeasonDescription)
	return object
}

func indexSeasons(queries *sqlc.Queries, ctx context.Context, index *search.Index) {
	items, err := queries.GetSeasons(ctx)
	if err != nil {
		return
	}
	ts, err := queries.GetSeasonTranslations(ctx)
	if err != nil {
		return
	}
	tDict := mapToRelatedId(ts, func(item sqlc.SeasonsTranslation) int {
		return int(item.SeasonsID)
	})
	objects := lo.Map(items, func(item sqlc.Season, _ int) searchObject {
		return mapSeasonToSearchObject(item, tDict[int(item.ID)])
	})

	err = indexObjects(index, objects)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to index objects")
		return
	}
}

func (service *Service) indexSeason(item sqlc.Season) {
	ctx := context.Background()
	ts, err := service.queries.GetTranslationsForSeason(ctx, item.ID)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to retrieve translations for season")
	}

	_, err = service.index.SaveObject(mapSeasonToSearchObject(item, ts))
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to index season")
	}
}
