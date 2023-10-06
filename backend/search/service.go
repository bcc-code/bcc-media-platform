package search

import (
	"context"
	"github.com/algolia/algoliasearch-client-go/v3/algolia/search"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/loaders"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
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

	ctx := context.Background()

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
