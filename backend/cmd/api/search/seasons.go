package search

import (
	"context"
	"github.com/algolia/algoliasearch-client-go/v3/algolia/search"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/mediabank-bridge/log"
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
	values := searchObject{}
	itemId := int(item.ID)
	values["objectID"] = "season-" + strconv.Itoa(itemId)
	mapTranslationsToSearchObject(values, translations, getSeasonLanguage, getSeasonTitle, getSeasonDescription)
	return values
}

func indexSeasons(queries *sqlc.Queries, ctx context.Context, index *search.Index) {
	items, err := queries.GetSeasons(ctx)
	if err != nil {
		return
	}
	itemTranslations, err := queries.GetSeasonTranslations(ctx)
	if err != nil {
		return
	}
	translationDictionary := mapToRelatedId(itemTranslations)
	objects := mapToSearchObjects(items, func(item sqlc.Season) searchObject {
		return mapSeasonToSearchObject(item, translationDictionary[int(item.ID)])
	})

	err = indexObjects(index, objects)

	if err != nil {
		log.L.Error().Err(err).Msg("Failed to index objects")
		return
	}
}

func (service *Service) IndexSeason(item sqlc.Season) {
	ctx := context.Background()
	translations, err := service.queries.GetTranslationsForSeason(ctx, item.ID)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to retrieve translations for season")
	}

	_, err = service.index.SaveObject(mapSeasonToSearchObject(item, translations))
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to index season")
	}
}
