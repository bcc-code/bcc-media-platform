package search

import (
	"context"
	"database/sql"
	"github.com/algolia/algoliasearch-client-go/v3/algolia/opt"
	"github.com/algolia/algoliasearch-client-go/v3/algolia/search"
	"github.com/bcc-code/brunstadtv/backend/base"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/google/uuid"
	_ "github.com/lib/pq"
	"github.com/samber/lo"
	"strconv"
	"strings"
)

const indexName = "global"

type searchObject map[string]interface{}

func indexObjects(index *search.Index, objects []searchObject) error {
	_, err := index.SaveObjects(objects)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to index objects")
	}
	return err
}

func mapToKey[T any](items []T, getRelatedId func(item T) int) map[int][]T {
	dictionary := map[int][]T{}

	for _, item := range items {
		relatedId := getRelatedId(item)
		dictionary[relatedId] = append(dictionary[relatedId], item)
	}

	return dictionary
}

type Service struct {
	algoliaClient *search.Client
	db            *sql.DB
	index         *search.Index
	queries       *sqlc.Queries
}

func New(algoliaAppId string, algoliaApiKey string, db *sql.DB) Service {
	service := Service{
		db:            db,
		algoliaClient: search.NewClient(algoliaAppId, algoliaApiKey),
	}
	service.index = service.algoliaClient.InitIndex(indexName)
	service.queries = sqlc.New(service.db)
	return service
}

func (service *Service) Reindex() {
	ctx := context.Background()
	q := service.queries
	index := service.index

	// TODO: Should probably just delete individual documents when they are removed from database.
	_, err := index.ClearObjects()
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to clear objects from index")
		return
	}

	// Makes it possible to filter in query, which fields you are searching on
	// Also configures hits per page
	_, err = index.SetSettings(search.Settings{
		SearchableAttributes: opt.SearchableAttributes(service.getFields()...),
		HitsPerPage:          opt.HitsPerPage(20),
	})
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to set searchable fields")
		return
	}

	log.L.Debug().Msg("Indexing shows")
	shows, _ := q.GetShows(ctx)
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
	showTsDict := mapToKey(showTs, func(item sqlc.ShowsTranslation) int {
		return int(item.ShowsID)
	})
	indexShows(shows, showThumbnailsById, showTsDict, index)

	log.L.Debug().Msg("Indexing seasons")
	seasons, _ := q.GetSeasons(ctx)
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
	seasonTsDict := mapToKey(seasonTs, func(item sqlc.SeasonsTranslation) int {
		return int(item.SeasonsID)
	})
	indexSeasons(seasons, seasonThumbnailsById, seasonTsDict, showTsDict, index)

	log.L.Debug().Msg("Indexing episodes")
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
	episodeTs, _ := q.GetEpisodeTranslations(ctx)
	episodeTsDict := mapToKey(episodeTs, func(item sqlc.EpisodesTranslation) int {
		return int(item.EpisodesID)
	})
	seasonById := lo.Reduce(seasons, func(seasonById map[int]sqlc.Season, season sqlc.Season, _ int) map[int]sqlc.Season {
		seasonById[int(season.ID)] = season
		return seasonById
	}, map[int]sqlc.Season{})
	indexEpisodes(episodes, episodeThumbnailsById, episodeTsDict, seasonById, seasonTsDict, showTsDict, index)
}

// DeleteObject
// Prefix id with model-name. For example: "show-10" for a Show with ID 10.
func (service *Service) DeleteObject(item interface{}) {
	var m string
	var id int
	switch item.(type) {
	case sqlc.Episode:
		m = "episode"
		id = int(item.(sqlc.Episode).ID)
	case sqlc.Season:
		m = "season"
		id = int(item.(sqlc.Season).ID)
	case sqlc.Show:
		m = "show"
		id = int(item.(sqlc.Show).ID)
	default:
		log.L.Error().Msg("Unknown type")
		return
	}
	service.DeleteModel(m, id)
}

func (service *Service) DeleteModel(model string, id int) {
	_, err := service.index.DeleteObject(model + "-" + strconv.Itoa(id))
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to delete model")
	}
}

func (service *Service) IndexObject(item interface{}) {
	switch item.(type) {
	case sqlc.Episode:
		service.indexEpisode(item.(sqlc.Episode))
	case sqlc.Show:
		service.indexShow(item.(sqlc.Show))
	case sqlc.Season:
		service.indexSeason(item.(sqlc.Season))
	default:
		log.L.Error().Msg("Couldn't index object")
	}
}

func (service *Service) IndexModel(model string, id int) {
	ctx := context.Background()
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
	service.IndexObject(i)
}

type searchHit struct {
	ID              string                 `json:"objectID"`
	Title           localeString           `json:"title"`
	Header          string                 `json:"header"`
	Description     localeString           `json:"description"`
	ShowID          int                    `json:"showID"`
	ShowTitle       localeString           `json:"showTitle"`
	SeasonID        int                    `json:"seasonID"`
	SeasonTitle     localeString           `json:"seasonTitle"`
	Image           string                 `json:"image"`
	HighlightResult map[string]interface{} `json:"_highlightResult"`
}

// TODO: implement permission checking
func hasAccess(user any, model string, id int) bool {
	return true
}

func (handler *Handler) Search(query *base.SearchQuery) (*base.SearchResult, error) {
	result, err := handler.service.index.Search(query.Query,
		opt.Filters(""),
		opt.Page(query.Page),
		opt.AttributesToHighlight(handler.service.getTextFields()...),
	)
	if err != nil {
		return nil, err
	}
	var searchResult base.SearchResult
	var hits []searchHit

	err = result.UnmarshalHits(&hits)
	if err != nil {
		return nil, err
	}

	searchResult.HitCount = result.NbHits
	searchResult.Page = result.Page
	searchResult.PageCount = result.NbPages

	for _, hit := range hits {
		parts := strings.Split(hit.ID, "-")
		model := parts[0]
		id, _ := strconv.ParseInt(parts[1], 0, 64)

		if hasAccess(handler.user, model, int(id)) {
			item := base.SearchResultItem{
				Id:    int(id),
				Model: model,
			}

			for _, opts := range hit.HighlightResult {
				values := opts.(map[string]interface{})
				if matchLevel := values["matchLevel"]; matchLevel != nil && matchLevel != "none" {
					value := values["value"].(string)
					if item.Highlight != nil {
						str := *item.Highlight + "\n" + value
						item.Highlight = &str
					} else {
						item.Highlight = &value
					}
				}
			}

			if value := hit.Title.get(defaultLanguage); value != "" {
				item.Title = value
			}
			if value := hit.Description.get(defaultLanguage); value != "" {
				item.Description = &value
			}
			if value := hit.Header; value != "" {
				item.Header = &value
			}

			item.Url = getUrl(model, int(id))
			if value := hit.Image; value != "" {
				item.Image = &value
			}

			searchResult.ResultCount++
			searchResult.Result = append(searchResult.Result, item)
		}
	}

	return &searchResult, nil
}
