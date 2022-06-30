package search

import (
	"github.com/algolia/algoliasearch-client-go/v3/algolia/opt"
	"github.com/algolia/algoliasearch-client-go/v3/algolia/search"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/google/uuid"
	"github.com/samber/lo"
	"strconv"
)

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

	shows, err := q.GetShows(ctx)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to retrieve shows")
		return
	}
	showThumbnails, _ := q.GetFilesByIds(ctx, lo.Map(lo.Filter(shows, func(i sqlc.Show, _ int) bool {
		return i.ImageFileID.Valid
	}), func(i sqlc.Show, _ int) uuid.UUID {
		return i.ImageFileID.UUID
	}))
	showThumbnailsById := lo.Reduce(showThumbnails, func(dict map[uuid.UUID]sqlc.DirectusFile, f sqlc.DirectusFile, _ int) map[uuid.UUID]sqlc.DirectusFile {
		dict[f.ID] = f
		return dict
	}, map[uuid.UUID]sqlc.DirectusFile{})

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

	episodes, _ := q.GetEpisodes(ctx)
	episodeThumbnails, _ := q.GetFilesByIds(ctx, lo.Map(lo.Filter(episodes, func(i sqlc.Episode, _ int) bool {
		return i.ImageFileID.Valid
	}), func(i sqlc.Episode, _ int) uuid.UUID {
		return i.ImageFileID.UUID
	}))
	episodeThumbnailsById := lo.Reduce(episodeThumbnails, func(dict map[uuid.UUID]sqlc.DirectusFile, f sqlc.DirectusFile, _ int) map[uuid.UUID]sqlc.DirectusFile {
		dict[f.ID] = f
		return dict
	}, map[uuid.UUID]sqlc.DirectusFile{})

	visibilityDict := ctx.Value(visibilityContextKey).(map[string]common.Visibility)

	showVisibilities, _ := q.GetVisibilityForShows(ctx)
	for _, v := range showVisibilities {
		visibilityDict[getCacheKeyForModel("show", v.ID)] = v.ToVisibility()
	}

	seasonVisibilities, _ := q.GetVisibilityForSeasons(ctx)
	for _, v := range seasonVisibilities {
		visibilityDict[getCacheKeyForModel("season", v.ID)] = v.ToVisibility()
	}

	episodeVisibilities, _ := q.GetVisibilityForEpisodes(ctx)
	for _, v := range episodeVisibilities {
		visibilityDict[getCacheKeyForModel("episode", v.ID)] = v.ToVisibility()
	}

	translationsDict := ctx.Value(translationContextKey).(map[string][]common.Translation)

	showTs, _ := q.GetShowTranslations(ctx)
	for _, v := range showTs {
		var cacheKey = getCacheKeyForModel("show", v.ShowsID)
		translationsDict[cacheKey] = append(translationsDict[cacheKey], v.ToTranslation())
	}

	seasonTs, _ := q.GetSeasonTranslations(ctx)
	for _, v := range seasonTs {
		var cacheKey = getCacheKeyForModel("season", v.SeasonsID)
		translationsDict[cacheKey] = append(translationsDict[cacheKey], v.ToTranslation())
	}

	episodeTs, _ := q.GetEpisodeTranslations(ctx)
	for _, v := range episodeTs {
		var cacheKey = getCacheKeyForModel("episode", v.EpisodesID)
		translationsDict[cacheKey] = append(translationsDict[cacheKey], v.ToTranslation())
	}

	rolesDict := ctx.Value(rolesContextKey).(map[string][]string)

	episodeById := lo.Reduce(episodes, func(dict map[int32]sqlc.Episode, i sqlc.Episode, _ int) map[int32]sqlc.Episode {
		dict[i.ID] = i
		return dict
	}, map[int32]sqlc.Episode{})

	episodeRoles, _ := q.GetEpisodeRoles(ctx)
	for _, v := range episodeRoles {
		cacheKey := getCacheKeyForModel("episode", v.EpisodesID)
		rolesDict[cacheKey] = append(rolesDict[cacheKey], v.UsergroupsCode)
		episode := episodeById[v.EpisodesID]
		if episode.SeasonID.Valid {
			season := seasonById[int32(episode.SeasonID.ValueOrZero())]
			cacheKey = getCacheKeyForModel("season", season.ID)
			rolesDict[cacheKey] = lo.Uniq(append(rolesDict[cacheKey], v.UsergroupsCode))
			cacheKey = getCacheKeyForModel("show", season.ShowID)
			rolesDict[cacheKey] = lo.Uniq(append(rolesDict[cacheKey], v.UsergroupsCode))
		}
	}

	log.L.Debug().Msg("Indexing shows")
	handler.indexShows(shows, showThumbnailsById, index)
	log.L.Debug().Msg("Indexing seasons")
	handler.indexSeasons(seasons, seasonThumbnailsById, index)
	log.L.Debug().Msg("Indexing episodes")
	handler.indexEpisodes(episodes, episodeThumbnailsById, seasonById, index)
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

func (handler *RequestHandler) IndexModel(collection string, id int) {
	service := handler.service
	ctx := handler.context
	var i any
	var err error
	switch collection {
	case "episodes":
		i, err = service.queries.GetEpisode(ctx, int32(id))
	case "seasons":
		i, err = service.queries.GetSeason(ctx, int32(id))
	case "shows":
		i, err = service.queries.GetShow(ctx, int32(id))
	default:
		return
	}
	if err != nil {
		log.L.Error().Err(err).Str("collection", collection).Int("id", id).Msg("Failed to retrieve collection")
		return
	}
	handler.IndexObject(i)
}
