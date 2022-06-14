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
	object := searchObject{}
	itemId := int(item.ID)
	object[idField] = "show-" + strconv.Itoa(itemId)
	if item.DateCreated.Valid {
		object[createdAtField] = item.DateCreated.Time.UTC()
	}
	if item.DateUpdated.Valid {
		object[updatedAtField] = item.DateUpdated.Time.UTC()
	}
	object[publishedAtField] = item.PublishDate.UTC()
	mapTsToObject(object, translations, getShowLanguage, getShowTitle, getShowDescription)
	return object
}

func indexShows(queries *sqlc.Queries, ctx context.Context, index *search.Index) {
	items, err := queries.GetShows(ctx)
	if err != nil {
		return
	}
	ts, err := queries.GetShowTranslations(ctx)
	if err != nil {
		return
	}
	tDict := mapToRelatedId(ts, func(item sqlc.ShowsTranslation) int {
		return int(item.ShowsID)
	})
	objects := lo.Map(items, func(item sqlc.Show, _ int) searchObject {
		return mapShowToSearchObject(item, tDict[int(item.ID)])
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
