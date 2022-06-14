package search

import (
	"context"
	"github.com/algolia/algoliasearch-client-go/v3/algolia/search"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/samber/lo"
	"strconv"
)

func getShowLanguage(translation sqlc.ShowsTranslation) string {
	return translation.LanguagesCode
}

func getShowTitle(translation sqlc.ShowsTranslation) string {
	return translation.Title.ValueOrZero()
}

func getShowDescription(translation sqlc.ShowsTranslation) string {
	return translation.Description.ValueOrZero()
}

func mapShowToSearchObject(item sqlc.Show, translations []sqlc.ShowsTranslation) searchObject {
	values := searchObject{}
	itemId := int(item.ID)
	values[idField] = "show-" + strconv.Itoa(itemId)
	if item.DateCreated.Valid {
		values[createdAtField] = item.DateCreated.Time.UTC()
	}
	if item.DateUpdated.Valid {
		values[updatedAtField] = item.DateUpdated.Time.UTC()
	}
	values[publishedAtField] = item.PublishDate.UTC()
	mapTranslationsToSearchObject(values, translations, getShowLanguage, getShowTitle, getShowDescription)
	return values
}

func indexShows(queries *sqlc.Queries, ctx context.Context, index *search.Index) {
	items, err := queries.GetShows(ctx)
	if err != nil {
		return
	}
	itemTranslations, err := queries.GetShowTranslations(ctx)
	if err != nil {
		return
	}
	translationDictionary := mapToRelatedId(itemTranslations, func(item sqlc.ShowsTranslation) int {
		return int(item.ShowsID)
	})
	objects := lo.Map(items, func(item sqlc.Show, _ int) searchObject {
		return mapShowToSearchObject(item, translationDictionary[int(item.ID)])
	})

	err = indexObjects(index, objects)

	if err != nil {
		log.L.Error().Err(err).Msg("Failed to index objects")
		return
	}
}

func (service *Service) indexShow(item sqlc.Show) {
	ctx := context.Background()
	translations, err := service.queries.GetTranslationsForShow(ctx, item.ID)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to retrieve translations for season")
	}

	_, err = service.index.SaveObject(mapShowToSearchObject(item, translations))
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to index season")
	}
}
