package search

import (
	"context"
	"database/sql"
	"github.com/algolia/algoliasearch-client-go/v3/algolia/opt"
	"github.com/algolia/algoliasearch-client-go/v3/algolia/search"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/google/uuid"
	_ "github.com/lib/pq"
	"github.com/samber/lo"
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
	(*object)[publishedAtField] = v.PublishDate
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

func mapToKey[T any, R comparable](items []T, getKey func(item T) R) map[R][]T {
	dictionary := map[R][]T{}

	for _, item := range items {
		relatedId := getKey(item)
		dictionary[relatedId] = append(dictionary[relatedId], item)
	}

	return dictionary
}

type Service struct {
	algoliaClient *search.Client
	index         *search.Index
	queries       *sqlc.Queries
}

func New(algoliaAppId string, algoliaApiKey string, db *sql.DB) Service {
	service := Service{
		algoliaClient: search.NewClient(algoliaAppId, algoliaApiKey),
	}
	service.index = service.algoliaClient.InitIndex(indexName)
	service.queries = sqlc.New(db)
	return service
}

type RequestHandler struct {
	service *Service
	context context.Context
}

func (service *Service) NewRequestHandler(ctx context.Context) RequestHandler {
	return RequestHandler{
		service: service,
		context: context.WithValue(ctx, visibilityContextKey, map[string]common.Visibility{}),
	}
}

func (handler *RequestHandler) Reindex() {
	ctx := handler.context
	service := handler.service
	q := service.queries
	index := service.index

	_, err := index.ClearObjects()
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to clear objects from index")
		return
	}

	// Makes it possible to filter in query, which fields you are searching on
	// Also configures hits per page
	languages := service.getLanguageKeys()
	_, err = index.SetSettings(search.Settings{
		IndexLanguages:        opt.IndexLanguages(languages...),
		QueryLanguages:        opt.QueryLanguages(languages...),
		SearchableAttributes:  opt.SearchableAttributes(service.getFields()...),
		AttributesForFaceting: opt.AttributesForFaceting(service.getFilterFields()...),
		HitsPerPage:           opt.HitsPerPage(hitsPerPage),
	})
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to set searchable fields")
		return
	}

	shows, _ := q.GetShows(ctx)
	showById := lo.Reduce(shows, func(showById map[int32]sqlc.Show, season sqlc.Show, _ int) map[int32]sqlc.Show {
		showById[season.ID] = season
		return showById
	}, map[int32]sqlc.Show{})
	showThumbnails, _ := q.GetFilesByIds(ctx, lo.Map(lo.Filter(shows, func(i sqlc.Show, _ int) bool {
		return i.ImageFileID.Valid
	}), func(i sqlc.Show, _ int) uuid.UUID {
		return i.ImageFileID.UUID
	}))
	showThumbnailsById := lo.Reduce(showThumbnails, func(dict map[uuid.UUID]sqlc.DirectusFile, f sqlc.DirectusFile, _ int) map[uuid.UUID]sqlc.DirectusFile {
		dict[f.ID] = f
		return dict
	}, map[uuid.UUID]sqlc.DirectusFile{})
	showTs, _ := q.GetShowTranslations(ctx)
	showTsDict := mapToKey(showTs, func(item sqlc.ShowsTranslation) int32 {
		return item.ShowsID
	})

	seasons, _ := q.GetSeasons(ctx)
	seasonById := lo.Reduce(seasons, func(seasonById map[int32]sqlc.Season, season sqlc.Season, _ int) map[int32]sqlc.Season {
		seasonById[season.ID] = season
		return seasonById
	}, map[int32]sqlc.Season{})
	seasonThumbnails, _ := q.GetFilesByIds(ctx, lo.Map(lo.Filter(seasons, func(i sqlc.Season, _ int) bool {
		return i.ImageFileID.Valid
	}), func(i sqlc.Season, _ int) uuid.UUID {
		return i.ImageFileID.UUID
	}))
	seasonThumbnailsById := lo.Reduce(seasonThumbnails, func(dict map[uuid.UUID]sqlc.DirectusFile, f sqlc.DirectusFile, _ int) map[uuid.UUID]sqlc.DirectusFile {
		dict[f.ID] = f
		return dict
	}, map[uuid.UUID]sqlc.DirectusFile{})
	seasonTs, _ := q.GetSeasonTranslations(ctx)
	seasonTsDict := mapToKey(seasonTs, func(item sqlc.SeasonsTranslation) int32 {
		return item.SeasonsID
	})

	episodes, _ := q.GetEpisodes(ctx)
	episodeById := lo.Reduce(episodes, func(episodeById map[int32]sqlc.Episode, episode sqlc.Episode, _ int) map[int32]sqlc.Episode {
		episodeById[episode.ID] = episode
		return episodeById
	}, map[int32]sqlc.Episode{})
	episodeThumbnails, _ := q.GetFilesByIds(ctx, lo.Map(lo.Filter(episodes, func(i sqlc.Episode, _ int) bool {
		return i.ImageFileID.Valid
	}), func(i sqlc.Episode, _ int) uuid.UUID {
		return i.ImageFileID.UUID
	}))
	episodeThumbnailsById := lo.Reduce(episodeThumbnails, func(dict map[uuid.UUID]sqlc.DirectusFile, f sqlc.DirectusFile, _ int) map[uuid.UUID]sqlc.DirectusFile {
		dict[f.ID] = f
		return dict
	}, map[uuid.UUID]sqlc.DirectusFile{})
	episodeTs, _ := q.GetEpisodeTranslations(ctx)
	episodeTsDict := mapToKey(episodeTs, func(item sqlc.EpisodesTranslation) int32 {
		return item.EpisodesID
	})

	// ROLES
	episodeRoles, _ := q.GetEpisodeRoles(ctx)
	episodeRolesDict := lo.Reduce(episodeRoles, func(dict map[int32][]string, role sqlc.EpisodesUsergroup, _ int) map[int32][]string {
		episodeId := role.EpisodesID
		dict[episodeId] = append(dict[episodeId], role.UsergroupsCode)
		return dict
	}, map[int32][]string{})
	var seasonRolesDict = map[int32][]string{}
	for episodeId, roles := range episodeRolesDict {
		episode := episodeById[episodeId]
		if episode.SeasonID.Valid {
			seasonId := int32(episode.SeasonID.ValueOrZero())
			seasonRolesDict[seasonId] = lo.Uniq(append(seasonRolesDict[seasonId], roles...))
		}
	}
	var showRolesDict = map[int32][]string{}
	for seasonId, roles := range seasonRolesDict {
		season := seasonById[seasonId]
		showRolesDict[season.ShowID] = lo.Uniq(append(showRolesDict[season.ShowID], roles...))
	}

	// TODO: Using and prefilling context okay?
	showVisibilities, err := q.GetVisibilityForShows(ctx)
	if err != nil {
		log.L.Error().Err(err).Msg("failed to retrieve show visibilities")
		return
	}
	for _, v := range showVisibilities {
		visibility := ctx.Value(visibilityContextKey).(map[string]common.Visibility)
		visibility[getCacheKeyForModel("show", v.ID)] = v.ToVisibility()
	}

	seasonVisibilities, err := q.GetVisibilityForSeasons(ctx)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to retrieve season visibilities")
	}
	for _, v := range seasonVisibilities {
		visibility := ctx.Value(visibilityContextKey).(map[string]common.Visibility)
		visibility[getCacheKeyForModel("season", v.ID)] = v.ToVisibility()
	}

	episodeVisibilities, err := q.GetVisibilityForEpisodes(ctx)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to retrieve season visibilities")
	}
	for _, v := range episodeVisibilities {
		visibility := ctx.Value(visibilityContextKey).(map[string]common.Visibility)
		visibility[getCacheKeyForModel("episode", v.ID)] = v.ToVisibility()
	}

	log.L.Debug().Msg("Indexing shows")
	handler.indexShows(shows, showRolesDict, showThumbnailsById, showTsDict, index)
	log.L.Debug().Msg("Indexing seasons")
	handler.indexSeasons(seasons, seasonRolesDict, seasonThumbnailsById, seasonTsDict, showTsDict, index)
	log.L.Debug().Msg("Indexing episodes")
	handler.indexEpisodes(episodes, episodeRolesDict, episodeThumbnailsById, episodeTsDict, seasonById, seasonTsDict, showById, showTsDict, index)
}

func (handler *RequestHandler) DeleteObject(item interface{}) {
	var m string
	var id int
	switch v := item.(type) {
	case sqlc.Episode:
		m = "episode"
		id = int(v.ID)
	case sqlc.Season:
		m = "season"
		id = int(v.ID)
	case sqlc.Show:
		m = "show"
		id = int(v.ID)
	default:
		log.L.Error().Msg("Unknown type")
		return
	}
	handler.DeleteModel(m, id)
}

func (handler *RequestHandler) DeleteModel(model string, id int) {
	_, err := handler.service.index.DeleteObject(model + "-" + strconv.Itoa(id))
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to delete model")
	}
}

func (handler *RequestHandler) IndexObject(item interface{}) {
	switch v := item.(type) {
	case sqlc.Episode:
		handler.indexEpisode(v)
	case sqlc.Show:
		handler.indexShow(v)
	case sqlc.Season:
		handler.indexSeason(v)
	default:
		log.L.Error().Msg("Couldn't index object")
	}
}

func (handler *RequestHandler) IndexModel(model string, id int) {
	service := handler.service
	ctx := handler.context
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
	handler.IndexObject(i)
}
