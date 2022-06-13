package search

import (
	"context"
	"github.com/algolia/algoliasearch-client-go/v3/algolia/search"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/mediabank-bridge/log"
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
	values["objectID"] = "episode-" + strconv.Itoa(itemId)
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
	translationDictionary := mapToRelatedId(itemTranslations)
	objects := mapToSearchObjects(items, func(item sqlc.Episode) searchObject {
		return mapEpisodeToSearchObject(item, translationDictionary[int(item.ID)])
	})

	err = indexObjects(index, objects)

	if err != nil {
		log.L.Error().Err(err).Msg("Failed to index objects")
		return
	}
}

func (service *Service) IndexEpisode(item sqlc.Episode) {
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
