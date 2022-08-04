package search

import (
	"database/sql"
	"github.com/algolia/algoliasearch-client-go/v3/algolia/opt"
	"github.com/algolia/algoliasearch-client-go/v3/algolia/search"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/items/episode"
	"github.com/bcc-code/brunstadtv/backend/items/season"
	"github.com/bcc-code/brunstadtv/backend/items/show"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/brunstadtv/backend/user"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/gin-gonic/gin"
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
	ShowLoader    *dataloader.Loader[int, *sqlc.ShowExpanded]
	SeasonLoader  *dataloader.Loader[int, *sqlc.SeasonExpanded]
	EpisodeLoader *dataloader.Loader[int, *sqlc.EpisodeExpanded]
	ImageLoader   *dataloader.Loader[uuid.UUID, *sqlc.DirectusFile]
}

// Service is the type for the service itself
type Service struct {
	algoliaClient    *search.Client
	searchOnlyApiKey string
	index            *search.Index
	queries          *sqlc.Queries
	loaders          loaders
}

func New(db *sql.DB, algoliaAppId string, algoliaApiKey string, algoliaSearchOnlyApiKey string) *Service {
	service := Service{
		algoliaClient: search.NewClient(algoliaAppId, algoliaApiKey),
	}
	service.index = service.algoliaClient.InitIndex(indexName)
	service.queries = sqlc.New(db)
	service.searchOnlyApiKey = algoliaSearchOnlyApiKey

	service.loaders = loaders{
		ShowLoader:    show.NewBatchLoader(*service.queries),
		SeasonLoader:  season.NewBatchLoader(*service.queries),
		EpisodeLoader: episode.NewBatchLoader(*service.queries),
		ImageLoader: common.NewBatchLoader(service.queries.GetFilesByIds, func(f sqlc.DirectusFile) uuid.UUID {
			return f.ID
		}, func(i uuid.UUID) uuid.UUID {
			return i
		}),
	}

	return &service
}

func (service *Service) GenerateSecureKey(ctx *gin.Context) string {
	apiKey := service.searchOnlyApiKey

	// TODO: perhaps generate a Search-only API key every 2 hours, and rotate every hour. That way we can update filters every hour ?

	u := user.GetFromCtx(ctx)
	filterString, _ := service.getFiltersForUser(u)
	key, err := search.GenerateSecuredAPIKey(apiKey,
		opt.Filters(filterString),
	)
	if err != nil {
		log.L.Error().Err(err)
		return ""
	}
	return key
}
