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
	"github.com/graph-gophers/dataloader/v7"
	"github.com/samber/lo"
	"strconv"
	"strings"
)

// Reindex every supported collection
func (service *Service) Reindex(ctx context.Context) error {
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

	supportedLanguages := []string{"da", "de", "en", "es", "fi", "fr", "hu", "it", "nl", "no", "pl", "pt", "ro", "ru", "tr"}

	languages = lo.Filter(languages, func(l string, _ int) bool {
		return lo.Contains(supportedLanguages, l)
	})

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

	err = service.indexShows(ctx)
	if err != nil {
		return err
	}
	err = service.indexSeasons(ctx)
	if err != nil {
		return err
	}
	err = service.indexEpisodes(ctx)
	if err != nil {
		return err
	}

	return nil
}

func (service *Service) indexShows(ctx context.Context) error {
	log.L.Debug().Str("collection", "shows").Msg("Indexing")
	return indexCollection[int, sqlc.ShowExpanded](
		ctx,
		service,
		service.loaders.ShowLoader,
		service.queries.ListShows,
		service.showToSearchItem,
	)
}

func (service *Service) indexSeasons(ctx context.Context) error {
	log.L.Debug().Str("collection", "seasons").Msg("Indexing")
	return indexCollection[int, sqlc.SeasonExpanded](
		ctx,
		service,
		service.loaders.SeasonLoader,
		service.queries.ListSeasons,
		service.seasonToSearchItem,
	)
}

func (service *Service) indexEpisodes(ctx context.Context) error {
	log.L.Debug().Str("collection", "episodes").Msg("Indexing")
	return indexCollection[int, sqlc.EpisodeExpanded](
		ctx,
		service,
		service.loaders.EpisodeLoader,
		service.queries.ListEpisodes,
		service.episodeToSearchItem,
	)
}

type indexable[k comparable] interface {
	GetKey() k
	GetRoles() common.Roles
	GetAvailability() common.Availability
	GetImage() uuid.NullUUID
}

func indexCollection[k comparable, t indexable[k]](
	ctx context.Context,
	service *Service,
	loader *dataloader.Loader[k, *t],
	factory func(context.Context) ([]t, error),
	converter func(context.Context, t) (searchItem, error),
) error {
	items, err := factory(ctx)
	if err != nil {
		return err
	}
	var searchItems []searchObject
	for _, i := range items {
		p := i
		loader.Prime(ctx, p.GetKey(), &p)

		item, err := converter(ctx, p)
		if err != nil {
			return err
		}

		item.assignVisibility(p)
		item.assignRoles(p)
		err = item.assignImage(ctx, service.loaders, p)
		if err != nil {
			return err
		}

		searchItems = append(searchItems, item.toSearchObject())
	}
	_, err = service.index.SaveObjects(searchItems)
	return err
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
	switch item.(type) {
	//case sqlc.EpisodeExpanded:
	//	return service.indexEpisode(ctx, v)
	//case sqlc.ShowExpanded:
	//	return service.indexShow(ctx, v)
	//case sqlc.SeasonExpanded:
	//	return service.indexSeason(ctx, v)
	default:
		return merry.New("collection not supported for indexing")
	}
}

// IndexModel by collection and id
func (service *Service) IndexModel(ctx context.Context, collection string, id int) (err error) {
	var i any
	switch collection {
	//case "episodes":
	//	i, err = service.queries.GetEpisode(ctx, int32(id))
	//case "seasons":
	//	i, err = service.queries.GetSeason(ctx, int32(id))
	//case "shows":
	//	i, err = service.queries.GetShow(ctx, int32(id))
	default:
		err = merry.New("collection not supported for indexing")
	}
	if err != nil {
		return
	}
	return service.IndexObject(ctx, i)
}
