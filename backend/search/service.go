package search

import (
	"context"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/loaders"
	"github.com/bcc-code/bcc-media-platform/backend/log"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/elastic/go-elasticsearch/v8"
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	_ "github.com/lib/pq"
	"github.com/samber/lo"
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
	ShowLoader     *loaders.Loader[int, *common.Show]
	SeasonLoader   *loaders.Loader[int, *common.Season]
	EpisodeLoader  *loaders.Loader[int, *common.Episode]
	PlaylistLoader *loaders.Loader[uuid.UUID, *common.Playlist]
	TagLoader      *loaders.Loader[int, *common.Tag]
	// Permissions
	ShowPermissionLoader     *loaders.Loader[int, *common.Permissions[int]]
	SeasonPermissionLoader   *loaders.Loader[int, *common.Permissions[int]]
	EpisodePermissionLoader  *loaders.Loader[int, *common.Permissions[int]]
	PlaylistPermissionLoader *loaders.Loader[uuid.UUID, *common.Permissions[uuid.UUID]]
}

// ElasticConfig contains configuration options for the service
// If CloudID is defined it takes precedence above URL
type ElasticConfig struct {
	CloudID string
	ApiKey  string

	URL      string
	Username string
	Password string
}

// Config contains configuration options for the service
type Config struct {
	Elastic ElasticConfig
}

// Service is the type for the service itself
type Service struct {
	elasticClient *elasticsearch.TypedClient
	queries       *sqlc.Queries
	loaders       batchLoaders
}

func newElasticClient(ctx context.Context, config ElasticConfig) *elasticsearch.TypedClient {

	var elasticConfig elasticsearch.Config

	if config.CloudID != "" {
		log.L.Debug().Msg("Using elastic cloud config")
		elasticConfig = elasticsearch.Config{
			CloudID: config.CloudID,
			APIKey:  config.ApiKey,
		}
	} else {
		log.L.Debug().Msg("Using elastic URL config")
		elasticConfig = elasticsearch.Config{
			Addresses: []string{config.URL},
			Username:  config.Username,
			Password:  config.Password,
		}
	}

	elasticClient, err := elasticsearch.NewTypedClient(elasticConfig)

	if err != nil {
		log.L.Fatal().Msgf("Failed to create elasticsearch client: %v", err)
	}

	_, err = elasticClient.Ping().Do(ctx)
	if err != nil {
		log.L.Fatal().Msgf("Failed to ping elasticsearch: %v", err)
	}

	return elasticClient
}

// New creates a new instance of the search service
func New(queries *sqlc.Queries, config Config) *Service {
	ctx := context.Background()

	elasticClient := newElasticClient(ctx, config.Elastic)

	service := Service{
		elasticClient: elasticClient,
	}
	service.queries = queries

	service.loaders = batchLoaders{
		ShowLoader:    loaders.NewLoader(ctx, queries.GetShows),
		SeasonLoader:  loaders.NewLoader(ctx, queries.GetSeasons),
		EpisodeLoader: loaders.NewLoader(ctx, queries.GetEpisodes),
		PlaylistLoader: loaders.New(ctx, queries.GetPlaylists, loaders.WithKeyFunc(func(i common.Playlist) uuid.UUID {
			return i.ID
		})),
		TagLoader: loaders.NewLoader(ctx, service.queries.GetTags),
		// Permissions
		ShowPermissionLoader: loaders.NewCustomLoader(ctx, queries.GetPermissionsForShows, func(i common.Permissions[int]) int {
			return i.ItemID
		}),
		SeasonPermissionLoader: loaders.NewCustomLoader(ctx, queries.GetPermissionsForSeasons, func(i common.Permissions[int]) int {
			return i.ItemID
		}),
		EpisodePermissionLoader: loaders.NewCustomLoader(ctx, queries.GetPermissionsForEpisodes, func(i common.Permissions[int]) int {
			return i.ItemID
		}),
		PlaylistPermissionLoader: loaders.NewCustomLoader[uuid.UUID, common.Permissions[uuid.UUID]](ctx, func(ctx context.Context, ids []uuid.UUID) ([]common.Permissions[uuid.UUID], error) {
			rows, err := queries.GetRolesForPlaylists(ctx, ids)
			if err != nil {
				return nil, err
			}
			return lo.Map(rows, func(i sqlc.GetRolesForPlaylistsRow, _ int) common.Permissions[uuid.UUID] {
				return common.Permissions[uuid.UUID]{
					Roles: common.Roles{
						Access: i.Roles,
					},
				}
			}), nil
		}, func(i common.Permissions[uuid.UUID]) uuid.UUID {
			return i.ItemID
		}),
	}

	return &service
}

// TopbarSearch performs a search optimized for the topbar dropdown
func (service *Service) TopbarSearch(ctx *gin.Context, term string, size int) ([]common.TopbarSearchResult, error) {
	if size > 50 {
		size = 50
	}
	if size <= 0 {
		size = 20
	}

	query := common.SearchQuery{
		Query:  term,
		Limit:  &size,
		Offset: lo.ToPtr(0),
	}

	searchResult, err := service.SearchElastic(ctx, query, "")
	if err != nil {
		return nil, err
	}

	// Get application from context
	app, err := common.GetApplicationFromCtx(ctx)
	if err != nil {
		return nil, err
	}

	urlPrefix := app.WebPrefix.String

	results := make([]common.TopbarSearchResult, 0, len(searchResult.Result))
	for _, item := range searchResult.Result {
		subtitle := ""
		if item.Show != nil && item.Season != nil {
			subtitle = *item.Show + " • " + *item.Season
		} else if item.Show != nil {
			subtitle = *item.Show
		} else if item.Season != nil {
			subtitle = *item.Season
		}

		imageURL := ""
		if item.Image != nil {
			imageURL = *item.Image
		}

		url := urlPrefix + item.Url

		if url == "" {
			continue
		}

		url += "?src=topbarsearch"

		results = append(results, common.TopbarSearchResult{
			Title:    item.Title,
			Subtitle: subtitle,
			Image:    imageURL,
			URL:      url,
		})
	}

	return results, nil
}
