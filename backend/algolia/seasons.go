package main

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/mediabank-bridge/log"
	"strconv"
)

func getSeasonMapsToIndex(queries *sqlc.Queries, ctx context.Context) ([]searchObject, error) {
	items, err := queries.GetSeasons(ctx)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to retrieve shows")
		return nil, err
	}

	translationsByEpisode, err := getTranslationsBySeason(queries, ctx)

	if err != nil {
		log.L.Error().Err(err).Msg("Failed to retrieve translations")
		return nil, err
	}

	var objects []searchObject
	for _, item := range items {
		objects = append(objects, mapSeasonToObject(item, translationsByEpisode[int(item.ID)]))
	}

	return objects, nil
}

func getTranslationsBySeason(queries *sqlc.Queries, ctx context.Context) (map[int][]sqlc.SeasonsTranslation, error) {
	translations, err := queries.GetSeasonTranslations(ctx)
	if err != nil {
		return nil, err
	}

	translationsByParent := map[int][]sqlc.SeasonsTranslation{}

	for _, translation := range translations {
		parentId := translation.GetParentId()
		translationsByParent[parentId] = append(translationsByParent[parentId], translation)
	}

	return translationsByParent, nil
}

func mapSeasonToObject(item sqlc.Season, translations []sqlc.SeasonsTranslation) searchObject {
	itemId := item.GetId()
	object := searchObject{
		"objectID": item.GetModelName() + "-" + strconv.Itoa(itemId),
	}

	object["showID"] = int(item.ShowID)

	for _, translation := range translations {
		mapTranslationToObject(translation, object)
	}

	return object
}
