package search

import (
	"context"
	"database/sql"
	"github.com/algolia/algoliasearch-client-go/v3/algolia/opt"
	"github.com/algolia/algoliasearch-client-go/v3/algolia/search"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/mediabank-bridge/log"
	_ "github.com/lib/pq"
)

const indexName = "global"

type searchObject map[string]interface{}

func indexObjects(index *search.Index, objects []searchObject) error {
	_, err := index.SaveObjects(objects)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to index objects")
	}
	return err
}

type Service struct {
	AlgoliaClient *search.Client
	DB            *sql.DB
}

func NewService(algoliaAppId string, algoliaApiKey string, db *sql.DB) *Service {
	var service *Service

	service.AlgoliaClient = search.NewClient(algoliaAppId, algoliaApiKey)
	service.DB = db

	return service
}

func (service *Service) Index() {
	ctx := context.Background()
	queries := sqlc.New(service.DB)

	algoliaClient := service.AlgoliaClient
	index := algoliaClient.InitIndex(indexName)

	_, err := index.ClearObjects()
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to clear objects from index")
		return
	}

	_, err = index.SetSettings(search.Settings{
		SearchableAttributes: opt.SearchableAttributes(service.getFields()...),
	})
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to set searchable fields")
		return
	}

	log.L.Debug().Msg("Indexing shows")
	objects, err := getShowMapsToIndex(queries, ctx)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to retrieve objects to index")
		return
	}

	err = indexObjects(index, objects)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to index shows")
	}

	log.L.Debug().Msg("Indexing episodes")
	objects, err = getEpisodeMapsToIndex(queries, ctx)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to retrieve episodes to index")
		return
	}

	err = indexObjects(index, objects)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to index episodes")
	}

	log.L.Debug().Msg("Indexing seasons")
	objects, err = getSeasonMapsToIndex(queries, ctx)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to retrieve episodes to index")
		return
	}

	err = indexObjects(index, objects)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to index episodes")
	}
}
