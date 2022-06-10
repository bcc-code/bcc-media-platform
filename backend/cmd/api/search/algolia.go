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
	//_, err := index.ClearObjects()
	//if err != nil {
	//	log.L.Error().Err(err).Msg("Failed to clear index")
	//}

	_, err := index.SaveObjects(objects)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to index objects")
	}
	return err
}

type Client struct {
	AlgoliaClient *search.Client
	DB            *sql.DB
}

func NewClient(algoliaAppId string, algoliaApiKey string, db *sql.DB) *Client {
	var client *Client

	client.AlgoliaClient = search.NewClient(algoliaAppId, algoliaApiKey)
	client.DB = db

	return client
}

func (searchClient *Client) Index() {
	algoliaClient := searchClient.AlgoliaClient
	index := algoliaClient.InitIndex(indexName)
	ctx := context.Background()
	queries := sqlc.New(searchClient.DB)

	_, err := index.ClearObjects()
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to clear objects from index")
	}
	_, err = index.SetSettings(search.Settings{
		SearchableAttributes: opt.SearchableAttributes("title_en", "title_no"),
	})
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to set searchable fields")
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
