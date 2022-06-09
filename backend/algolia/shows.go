package main

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/mediabank-bridge/log"
	"strconv"
)

func getShowMapsToIndex(queries *sqlc.Queries, ctx context.Context) ([]searchObject, error) {
	items, err := queries.GetShows(ctx)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to retrieve shows")
		return nil, err
	}

	translationsByShow, err := getTranslationsByShow(queries, ctx)

	if err != nil {
		log.L.Error().Err(err).Msg("Failed to retrieve translations")
		return nil, err
	}

	var objects []searchObject
	for _, item := range items {
		objects = append(objects, mapShowToObject(item, translationsByShow[int(item.ID)]))
	}

	return objects, nil
}

func getTranslationsByShow(queries *sqlc.Queries, ctx context.Context) (map[int][]sqlc.ShowsTranslation, error) {
	translations, err := queries.GetShowTranslations(ctx)
	if err != nil {
		return nil, err
	}

	translationsByParent := map[int][]sqlc.ShowsTranslation{}

	for _, translation := range translations {
		parentId := translation.GetParentId()
		translationsByParent[parentId] = append(translationsByParent[parentId], translation)
	}

	return translationsByParent, nil
}

func mapShowToObject(item sqlc.Show, translations []sqlc.ShowsTranslation) searchObject {
	itemId := item.GetId()
	object := searchObject{
		"objectID": item.GetModelName() + "-" + strconv.Itoa(itemId),
	}

	for _, translation := range translations {
		mapTranslationToObject(translation, object)
	}

	return object
}
