package algolia

import (
	"context"
	"database/sql"
	"github.com/algolia/algoliasearch-client-go/v3/algolia/search"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/mediabank-bridge/log"
	_ "github.com/lib/pq"
)

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
	AppId  string
	ApiKey string
	//TODO: Performance impact of putting this here?
	DB *sql.DB
}

const indexName = "global"

func (searchClient *Client) Index() {
	algoliaClient := search.NewClient(searchClient.AppId, searchClient.ApiKey)
	index := algoliaClient.InitIndex(indexName)
	ctx := context.Background()
	queries := sqlc.New(searchClient.DB)

	_, err := index.ClearObjects()
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to clear objects from index")
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
