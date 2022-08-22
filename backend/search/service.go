package search

import (
	"database/sql"
	"github.com/algolia/algoliasearch-client-go/v3/algolia/search"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/items/episode"
	"github.com/bcc-code/brunstadtv/backend/items/season"
	"github.com/bcc-code/brunstadtv/backend/items/show"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/google/uuid"
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
	ImageLoader   *dataloader.Loader[uuid.UUID, *sqlc.DirectusFile]
	TagLoader     *dataloader.Loader[int, *common.Tag]
	// Permissions
	ShowPermissionsLoader    *dataloader.Loader[int, *common.Permissions]
	SeasonPermissionsLoader  *dataloader.Loader[int, *common.Permissions]
	EpisodePermissionsLoader *dataloader.Loader[int, *common.Permissions]
}

// Service is the type for the service itself
type Service struct {
	algoliaClient *search.Client
	index         *search.Index
	queries       *sqlc.Queries
	loaders       loaders
}

// New creates a new instance of the search service
func New(db *sql.DB, algoliaAppId string, algoliaApiKey string) *Service {
	service := Service{
		algoliaClient: search.NewClient(algoliaAppId, algoliaApiKey),
	}
	service.index = service.algoliaClient.InitIndex(indexName)
	service.queries = sqlc.New(db)

	service.loaders = loaders{
		ShowLoader:    show.NewBatchLoader(*service.queries),
		SeasonLoader:  season.NewBatchLoader(*service.queries),
		EpisodeLoader: episode.NewBatchLoader(*service.queries),
		ImageLoader: common.NewCustomBatchLoader(service.queries.GetFilesByIds, func(i sqlc.DirectusFile) uuid.UUID {
			return i.ID
		}),
		TagLoader: common.NewBatchLoader(service.queries.GetTags),
	}

	return &service
}
