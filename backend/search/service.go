package search

import (
	"context"
	"database/sql"
	"github.com/algolia/algoliasearch-client-go/v3/algolia/opt"
	"github.com/algolia/algoliasearch-client-go/v3/algolia/search"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/mediabank-bridge/log"
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

func (object *searchObject) assignShowIDAndTitle(id int32, ts []sqlc.ShowsTranslation) {
	(*object)[showIDField] = id
	showTitle, _ := mapTranslationsForShow(ts)
	object.mapFromLocaleString(showTitleField, showTitle)
}

func (object *searchObject) assignSeasonIDAndTitle(id int32, ts []sqlc.SeasonsTranslation) {
	(*object)[seasonIDField] = id
	seasonTitle, _ := mapTranslationsForSeason(ts)
	object.mapFromLocaleString(seasonTitleField, seasonTitle)
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

type RequestHandler struct {
	service *Service
	context context.Context
}

func (service *Service) NewRequestHandler(ctx context.Context) *RequestHandler {
	ctx = context.WithValue(ctx, visibilityContextKey, map[string]common.Visibility{})
	ctx = context.WithValue(ctx, translationContextKey, map[string][]common.Translation{})
	ctx = context.WithValue(ctx, rolesContextKey, map[string][]string{})
	return &RequestHandler{
		service: service,
		context: ctx,
	}
}

func (handler *RequestHandler) GenerateSecureKey() string {
	apiKey := handler.service.searchOnlyApiKey

	// TODO: perhaps generate a Search-only API key every 2 hours, and rotate every hour. That way we can update filters every hour ?

	filterString, _ := handler.getFiltersForCurrentUser()
	key, err := search.GenerateSecuredAPIKey(apiKey,
		opt.Filters(filterString),
	)
	if err != nil {
		log.L.Error().Err(err)
		return ""
	}
	return key
}
