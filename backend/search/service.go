package search

import (
	"github.com/algolia/algoliasearch-client-go/v3/algolia/search"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/loaders"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
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

type batchLoaders struct {
	ShowLoader    *loaders.Loader[int, *common.Show]
	SeasonLoader  *loaders.Loader[int, *common.Season]
	EpisodeLoader *loaders.Loader[int, *common.Episode]
	TagLoader     *loaders.Loader[int, *common.Tag]
	// Permissions
	ShowPermissionLoader    *loaders.Loader[int, *common.Permissions[int]]
	SeasonPermissionLoader  *loaders.Loader[int, *common.Permissions[int]]
	EpisodePermissionLoader *loaders.Loader[int, *common.Permissions[int]]
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
	loaders       batchLoaders
}

// New creates a new instance of the search service
func New(queries *sqlc.Queries, config Config) *Service {
	service := Service{
		algoliaClient: search.NewClient(config.AppID, config.APIKey),
	}
	service.index = service.algoliaClient.InitIndex(indexName)
	service.queries = queries

	service.loaders = batchLoaders{
		ShowLoader:    loaders.NewLoader(queries.GetShows),
		SeasonLoader:  loaders.NewLoader(queries.GetSeasons),
		EpisodeLoader: loaders.NewLoader(queries.GetEpisodes),
		TagLoader:     loaders.NewLoader(service.queries.GetTags),
		// Permissions
		ShowPermissionLoader: loaders.NewCustomLoader(queries.GetPermissionsForShows, func(i common.Permissions[int]) int {
			return i.ItemID
		}),
		SeasonPermissionLoader: loaders.NewCustomLoader(queries.GetPermissionsForSeasons, func(i common.Permissions[int]) int {
			return i.ItemID
		}),
		EpisodePermissionLoader: loaders.NewCustomLoader(queries.GetPermissionsForEpisodes, func(i common.Permissions[int]) int {
			return i.ItemID
		}),
	}

	return &service
}
