package search

import (
	"context"
	"database/sql"
	"github.com/algolia/algoliasearch-client-go/v3/algolia/opt"
	"github.com/algolia/algoliasearch-client-go/v3/algolia/search"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/mediabank-bridge/log"
	_ "github.com/lib/pq"
	"strconv"
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
	index         *search.Index
	queries       *sqlc.Queries
}

func NewService(algoliaAppId string, algoliaApiKey string, db *sql.DB) Service {
	service := Service{
		db:            db,
		algoliaClient: search.NewClient(algoliaAppId, algoliaApiKey),
	}
	service.index = service.algoliaClient.InitIndex(indexName)
	service.queries = sqlc.New(service.db)
	return service
}

func (service *Service) Index() {
	ctx := context.Background()
	queries := service.queries
	index := service.index

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

// DeleteObject
// Prefix id with model-name. For example: "show-10" for a Show with ID 10.
func (service *Service) DeleteObject(item interface{}) {
	var objectId string
	switch item.(type) {
	case sqlc.Episode:
		objectId = "episode-" + strconv.Itoa(int(item.(*sqlc.Episode).ID))
		break
	case sqlc.Season:
		objectId = "season-" + strconv.Itoa(int(item.(*sqlc.Season).ID))
		break
	case sqlc.Show:
		objectId = "show-" + strconv.Itoa(int(item.(*sqlc.Show).ID))
		break
	default:
		log.L.Error().Msg("Unknown type")
		return
	}
	_, err := service.index.DeleteObject(objectId)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to delete object")
	}
}
