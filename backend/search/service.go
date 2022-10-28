package search

import (
	"github.com/algolia/algoliasearch-client-go/v3/algolia/search"
	"github.com/bcc-code/brunstadtv/backend/batchloaders"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/items/episode"
	"github.com/bcc-code/brunstadtv/backend/items/season"
	"github.com/bcc-code/brunstadtv/backend/items/show"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/graph-gophers/dataloader/v7"
	_ "github.com/lib/pq"
)

const indexName = "global"
const hitsPerPage = 20

type searchObject map[string]interface{}

func (object *searchObject) assignVisibility(v common.Visibility) {
	(*object)[publishedField] = v.Published
	if v.AvailableFrom != nil {
		(*object)[availableFromField] = v.AvailableFrom.Unix()
	} else {
		(*object)[availableFromField] = 0
	}
	if v.AvailableTo != nil {
		(*object)[availableToField] = v.AvailableTo.Unix()
	} else {
		(*object)[availableToField] = 0
	}
}

type loaders struct {
	ShowLoader    *dataloader.Loader[int, *common.Show]
	SeasonLoader  *dataloader.Loader[int, *common.Season]
	EpisodeLoader *dataloader.Loader[int, *common.Episode]
	TagLoader     *dataloader.Loader[int, *common.Tag]
	// Permissions
	ShowPermissionLoader    *dataloader.Loader[int, *common.Permissions[int]]
	SeasonPermissionLoader  *dataloader.Loader[int, *common.Permissions[int]]
	EpisodePermissionLoader *dataloader.Loader[int, *common.Permissions[int]]
}

// Config contains configuration options for the service
type Config struct {
	AppID  string
	APIKey string
}

// Service is the type for the service itself
type Service struct {
	algoliaClient *search.Client
	index         *search.Index
	queries       *sqlc.Queries
	loaders       loaders
}

// New creates a new instance of the search service
func New(queries *sqlc.Queries, config Config) *Service {
	service := Service{
		algoliaClient: search.NewClient(config.AppID, config.APIKey),
	}
	service.index = service.algoliaClient.InitIndex(indexName)
	service.queries = queries

	service.loaders = loaders{
		ShowLoader:    show.NewBatchLoader(*service.queries),
		SeasonLoader:  season.NewBatchLoader(*service.queries),
		EpisodeLoader: episode.NewBatchLoader(*service.queries),
		TagLoader:     batchloaders.NewLoader(service.queries.GetTags),
		// Permissions
		ShowPermissionLoader:    show.NewPermissionLoader(*service.queries),
		SeasonPermissionLoader:  season.NewPermissionLoader(*service.queries),
		EpisodePermissionLoader: episode.NewPermissionLoader(*service.queries),
	}

	return &service
}
