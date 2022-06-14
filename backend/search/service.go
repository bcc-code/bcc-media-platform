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

func mapToRelatedId[T any](items []T, getRelatedId func(item T) int) map[int][]T {
	dictionary := map[int][]T{}

	for _, item := range items {
		relatedId := getRelatedId(item)
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

func New(algoliaAppId string, algoliaApiKey string, db *sql.DB) Service {
	service := Service{
		db:            db,
		algoliaClient: search.NewClient(algoliaAppId, algoliaApiKey),
	}
	service.index = service.algoliaClient.InitIndex(indexName)
	service.queries = sqlc.New(service.db)
	return service
}

func (service *Service) Reindex() {
	ctx := context.Background()
	q := service.queries
	i := service.index

	// TODO: Should probably just delete individual documents when they are removed from database.
	_, err := i.ClearObjects()
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to clear objects from index")
		return
	}

	// Makes it possible to filter in query, which fields you are searching on
	_, err = i.SetSettings(search.Settings{
		SearchableAttributes: opt.SearchableAttributes(service.getFields()...),
	})
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to set searchable fields")
		return
	}

	log.L.Debug().Msg("Indexing shows")
	indexShows(q, ctx, i)

	log.L.Debug().Msg("Indexing seasons")
	indexSeasons(q, ctx, i)

	log.L.Debug().Msg("Indexing episodes")
	indexEpisodes(q, ctx, i)
}

// DeleteObject
// Prefix id with model-name. For example: "show-10" for a Show with ID 10.
func (service *Service) DeleteObject(item interface{}) {
	var m string
	var id int
	switch item.(type) {
	case sqlc.Episode:
		m = "episode"
		id = int(item.(sqlc.Episode).ID)
	case sqlc.Season:
		m = "season"
		id = int(item.(sqlc.Season).ID)
	case sqlc.Show:
		m = "show"
		id = int(item.(sqlc.Show).ID)
	default:
		log.L.Error().Msg("Unknown type")
		return
	}
	service.DeleteModel(m, id)
}

func (service *Service) DeleteModel(model string, id int) {
	_, err := service.index.DeleteObject(model + "-" + strconv.Itoa(id))
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to delete model")
	}
}

func (service *Service) IndexObject(item interface{}) {
	switch item.(type) {
	case sqlc.Episode:
		service.indexEpisode(item.(sqlc.Episode))
	case sqlc.Show:
		service.indexShow(item.(sqlc.Show))
	case sqlc.Season:
		service.indexSeason(item.(sqlc.Season))
	default:
		log.L.Error().Msg("Couldn't index object")
	}
}

func (service *Service) IndexModel(model string, id int) {
	ctx := context.Background()
	var i any
	var err error
	switch model {
	case "episode":
		i, err = service.queries.GetEpisode(ctx, int32(id))
	case "season":
		i, err = service.queries.GetSeason(ctx, int32(id))
	case "show":
		i, err = service.queries.GetShow(ctx, int32(id))
	}
	if err != nil {
		log.L.Error().Err(err)
		return
	}
	service.IndexObject(i)
}
