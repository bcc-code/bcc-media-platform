package search

import (
	"context"
	"github.com/algolia/algoliasearch-client-go/v3/algolia/opt"
	"github.com/algolia/algoliasearch-client-go/v3/algolia/search"
	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/google/uuid"
	"github.com/samber/lo"
	"strconv"
	"strings"
)

// InitCtx to fill context with empty maps for caching purposes
func InitCtx(ctx context.Context) context.Context {
	ctx = context.WithValue(ctx, visibilityContextKey, map[string]common.Visibility{})
	ctx = context.WithValue(ctx, translationContextKey, map[string][]common.Translation{})
	ctx = context.WithValue(ctx, rolesContextKey, map[string][]string{})
	return ctx
}

// Reindex every supported collection
func (service *Service) Reindex(ctx context.Context) error {
	ctx = InitCtx(ctx)
	q := service.queries
	index := service.index

	_, err := index.ClearObjects()
	if err != nil {
		return err
	}

	// Makes it possible to filter in query, which fields you are searching on
	// Also configures hits per page
	primaryFields, err := service.getPrimaryTranslatedFields()
	if err != nil {
		return err
	}
	relationalFields, err := service.getRelationalTranslatedFields()
	if err != nil {
		return err
	}
	searchableAttributes := opt.SearchableAttributes(
		strings.Join(primaryFields, ","),
		strings.Join(relationalFields, ","),
		strings.Join(getFunctionalFields(), ","),
	)
	languages, err := service.getLanguageKeys()
	if err != nil {
		return err
	}
	_, err = index.SetSettings(search.Settings{
		IndexLanguages:        opt.IndexLanguages(languages...),
		QueryLanguages:        opt.QueryLanguages(languages...),
		SearchableAttributes:  searchableAttributes,
		AttributesForFaceting: opt.AttributesForFaceting(service.getFilterFields()...),
		HitsPerPage:           opt.HitsPerPage(hitsPerPage),
	})
	if err != nil {
		return err
	}

	shows, err := q.GetShows(ctx)
	if err != nil {
		return err
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
	err = service.indexShows(ctx, shows, showThumbnailsById, index)
	if err != nil {
		return err
	}
	log.L.Debug().Msg("Indexing seasons")
	err = service.indexSeasons(ctx, seasons, seasonThumbnailsById, index)
	if err != nil {
		return err
	}
	log.L.Debug().Msg("Indexing episodes")
	err = service.indexEpisodes(ctx, episodes, episodeThumbnailsById, seasonById, index)
	if err != nil {
		return err
	}
	return nil
}

// DeleteObject from the index
func (service *Service) DeleteObject(item interface{}) error {
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
		return merry.New("unsupported collection")
	}
	return service.DeleteModel(m, id)
}

// DeleteModel from index by collection and id
func (service *Service) DeleteModel(collection string, id int) error {
	_, err := service.index.DeleteObject(collection + "-" + strconv.Itoa(id))
	return err
}

// IndexObject to the index
func (service *Service) IndexObject(ctx context.Context, item interface{}) error {
	switch v := item.(type) {
	case sqlc.Episode:
		return service.indexEpisode(ctx, v)
	case sqlc.Show:
		return service.indexShow(ctx, v)
	case sqlc.Season:
		return service.indexSeason(ctx, v)
	default:
		return merry.New("collection not supported for indexing")
	}
}

// IndexModel by collection and id
func (service *Service) IndexModel(ctx context.Context, collection string, id int) (err error) {
	var i any
	switch collection {
	case "episodes":
		i, err = service.queries.GetEpisode(ctx, int32(id))
	case "seasons":
		i, err = service.queries.GetSeason(ctx, int32(id))
	case "shows":
		i, err = service.queries.GetShow(ctx, int32(id))
	default:
		err = merry.New("collection not supported for indexing")
	}
	if err != nil {
		return
	}
	return service.IndexObject(ctx, i)
}
