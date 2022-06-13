package search

import (
	"context"
	"github.com/algolia/algoliasearch-client-go/v3/algolia/search"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/samber/lo"
	"strconv"
)

func getEpisodeLanguage(translation sqlc.EpisodesTranslation) string {
	return translation.LanguagesCode
}

func getEpisodeTitle(translation sqlc.EpisodesTranslation) string {
	return translation.Title.ValueOrZero()
}

func getEpisodeDescription(translation sqlc.EpisodesTranslation) string {
	return translation.Description.ValueOrZero() + "\n" + translation.ExtraDescription.ValueOrZero()
}

func mapEpisodeToSearchObject(item sqlc.Episode, translations []sqlc.EpisodesTranslation) searchObject {
	values := searchObject{}
	itemId := int(item.ID)
	values[idField] = "episode-" + strconv.Itoa(itemId)
	if item.DateCreated.Valid {
		values[createdAtField] = item.DateCreated.Time.UTC()
	}
	if item.DateUpdated.Valid {
		values[updatedAtField] = item.DateUpdated.Time.UTC()
	}
	values[publishedAtField] = item.PublishDate.UTC()
	mapTranslationsToSearchObject(values, translations, getEpisodeLanguage, getEpisodeTitle, getEpisodeDescription)
	return values
}

func indexEpisodes(queries *sqlc.Queries, ctx context.Context, index *search.Index) {
	items, err := queries.GetEpisodes(ctx)
	if err != nil {
		return
	}
	itemTranslations, err := queries.GetEpisodeTranslations(ctx)
	if err != nil {
		return
	}
	translationDictionary := mapToRelatedId(itemTranslations, func(item sqlc.EpisodesTranslation) int {
		return int(item.EpisodesID)
	})
	objects := lo.Map(items, func(item sqlc.Episode, _ int) searchObject {
		return mapEpisodeToSearchObject(item, translationDictionary[int(item.ID)])
	})

	err = indexObjects(index, objects)

	if err != nil {
		log.L.Error().Err(err).Msg("Failed to index objects")
		return
	}
}

func (service *Service) indexEpisode(item sqlc.Episode) {
	ctx := context.Background()
	translations, err := service.queries.GetTranslationsForEpisode(ctx, item.ID)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to retrieve translations for season")
	}

	_, err = service.index.SaveObject(mapEpisodeToSearchObject(item, translations))
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to index season")
	}
}
