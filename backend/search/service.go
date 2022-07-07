package search

import (
	"database/sql"
	"github.com/algolia/algoliasearch-client-go/v3/algolia/opt"
	"github.com/algolia/algoliasearch-client-go/v3/algolia/search"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/brunstadtv/backend/user"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/gin-gonic/gin"
	_ "github.com/lib/pq"
	"strconv"
)

const indexName = "global"
const hitsPerPage = 20

type searchObject map[string]interface{}

func getCacheKeyForModel(model string, id int32) string {
	return model + "-" + strconv.Itoa(int(id))
}

func (object *searchObject) assignVisibility(v common.Visibility) {
	(*object)[statusField] = v.Status
	(*object)[publishedAtField] = v.PublishDate.Unix()
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

func indexObjects(index *search.Index, objects []searchObject) error {
	_, err := index.SaveObjects(objects)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to index objects")
	}
	return err
}

type Service struct {
	algoliaClient    *search.Client
	searchOnlyApiKey string
	index            *search.Index
	queries          *sqlc.Queries
}

func New(db *sql.DB, algoliaAppId string, algoliaApiKey string, algoliaSearchOnlyApiKey string) *Service {
	service := Service{
		algoliaClient: search.NewClient(algoliaAppId, algoliaApiKey),
	}
	service.index = service.algoliaClient.InitIndex(indexName)
	service.queries = sqlc.New(db)
	service.searchOnlyApiKey = algoliaSearchOnlyApiKey
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
