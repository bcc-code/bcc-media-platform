package algolia

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/mediabank-bridge/log"
	"strconv"
)

func getEpisodeMapsToIndex(queries *sqlc.Queries, ctx context.Context) ([]searchObject, error) {
	items, err := queries.GetEpisodes(ctx)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to retrieve shows")
		return nil, err
	}

	translationsByEpisode, err := getTranslationsByEpisode(queries, ctx)

	if err != nil {
		log.L.Error().Err(err).Msg("Failed to retrieve translations")
		return nil, err
	}

	var objects []searchObject
	for _, item := range items {
		objects = append(objects, mapEpisodeToObject(item, translationsByEpisode[int(item.ID)]))
	}

	return objects, nil
}

func getTranslationsByEpisode(queries *sqlc.Queries, ctx context.Context) (map[int][]sqlc.EpisodesTranslation, error) {
	translations, err := queries.GetEpisodeTranslations(ctx)
	if err != nil {
		return nil, err
	}

	translationsByParent := map[int][]sqlc.EpisodesTranslation{}

	for _, translation := range translations {
		parentId := translation.GetParentId()
		translationsByParent[parentId] = append(translationsByParent[parentId], translation)
	}

	return translationsByParent, nil
}

func mapEpisodeToObject(item sqlc.Episode, translations []sqlc.EpisodesTranslation) searchObject {
	itemId := item.GetId()
	object := searchObject{
		"objectID": item.GetModelName() + "-" + strconv.Itoa(itemId),
	}

	object["seasonID"] = item.SeasonID

	for _, translation := range translations {
		mapTranslationToObject(translation, object)
	}

	return object
}
