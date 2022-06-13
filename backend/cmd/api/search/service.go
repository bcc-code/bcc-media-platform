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

type searchObject map[string]any

func indexObjects(index *search.Index, objects []searchObject) error {
	_, err := index.SaveObjects(objects)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to index objects")
	}
	return err
}

func mapToRelatedId[T sqlc.IRelatedItem](items []T) map[int][]T {
	dictionary := map[int][]T{}

	for _, item := range items {
		relatedId := item.GetRelatedItemId()
		dictionary[relatedId] = append(dictionary[relatedId], item)
	}

	return dictionary
}

type Service struct {
	algoliaClient *search.Client
	db            *sql.DB
}

func NewService(algoliaAppId string, algoliaApiKey string, db *sql.DB) Service {
	service := Service{
		db:            db,
		algoliaClient: search.NewClient(algoliaAppId, algoliaApiKey),
	}
	return service
}

func (service *Service) Index() {
	ctx := context.Background()
	queries := sqlc.New(service.db)

	algoliaClient := service.algoliaClient
	index := algoliaClient.InitIndex(indexName)

	// TODO: Should probably just delete individual documents when they are removed from database.
	_, err := index.ClearObjects()
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to clear objects from index")
		return
	}

	// Makes it possible to filter in query, which fields you are searching on
	_, err = index.SetSettings(search.Settings{
		SearchableAttributes: opt.SearchableAttributes(service.getFields()...),
	})
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to set searchable fields")
		return
	}

	log.L.Debug().Msg("Indexing shows")
	indexShows(queries, ctx, index)

	log.L.Debug().Msg("Indexing seasons")
	indexSeasons(queries, ctx, index)

	log.L.Debug().Msg("Indexing episodes")
	indexEpisodes(queries, ctx, index)
}
