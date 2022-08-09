package search

import (
	"context"
	"github.com/algolia/algoliasearch-client-go/v3/algolia/opt"
	"github.com/algolia/algoliasearch-client-go/v3/algolia/search"
	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/brunstadtv/backend/common"
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
		strings.Join(primaryFields, ", "),
		strings.Join(relationalFields, ", "),
		strings.Join(getFunctionalFields(), ", "),
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

	log.L.Debug().Str("collection", "shows").Msg("Indexing")
	err = service.indexShows(ctx)
	if err != nil {
		return err
	}
	log.L.Debug().Str("collection", "seasons").Msg("Indexing")
	err = service.indexSeasons(ctx)
	if err != nil {
		return err
	}
	log.L.Debug().Str("collection", "episodes").Msg("Indexing")
	err = service.indexEpisodes(ctx)
	if err != nil {
		return err
	}

	return nil
}

func (service *Service) indexShows(ctx context.Context) error {
	return indexCollection[int, common.Show](
		ctx,
		service,
		service.loaders.ShowLoader,
		service.queries.ListShows,
		service.showToSearchItem,
	)
}

func (service *Service) indexShow(ctx context.Context, id int) error {
	i, err := service.loaders.ShowLoader.Load(ctx, id)()
	if err != nil {
		return err
	}
	return indexObject[int, common.Show](ctx, service, *i, service.showToSearchItem)
}

func (service *Service) indexSeasons(ctx context.Context) error {
	return indexCollection[int, common.Season](
		ctx,
		service,
		service.loaders.SeasonLoader,
		service.queries.ListSeasons,
		service.seasonToSearchItem,
	)
}

func (service *Service) indexSeason(ctx context.Context, id int) error {
	i, err := service.loaders.SeasonLoader.Load(ctx, id)()
	if err != nil {
		return err
	}
	return indexObject[int, common.Season](ctx, service, *i, service.seasonToSearchItem)
}

func (service *Service) indexEpisodes(ctx context.Context) error {
	return indexCollection[int, common.Episode](
		ctx,
		service,
		service.loaders.EpisodeLoader,
		service.queries.ListEpisodes,
		service.episodeToSearchItem,
	)
}

func (service *Service) indexEpisode(ctx context.Context, id int) error {
	i, err := service.loaders.EpisodeLoader.Load(ctx, id)()
	if err != nil {
		return err
	}
	return indexObject[int, common.Episode](ctx, service, *i, service.episodeToSearchItem)
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

func indexObject[k comparable, t indexable[k]](
	ctx context.Context,
	service *Service,
	obj t,
	converter func(context.Context, t) (searchItem, error),
) error {
	item, err := converter(ctx, obj)
	if err != nil {
		return err
	}

	item.assignVisibility(obj)
	item.assignRoles(obj)
	err = item.assignImage(ctx, service.loaders, obj)
	if err != nil {
		return err
	}
	_, err = service.index.SaveObject(item)
	return err
}

// DeleteModel from index by collection and id
func (service *Service) DeleteModel(collection string, id int) error {
	_, err := service.index.DeleteObject(collection + "-" + strconv.Itoa(id))
	return err
}

// IndexModel by collection and id
func (service *Service) IndexModel(ctx context.Context, collection string, id int) (err error) {
	// Clearing the loaders of cached instances
	// and indexing to the search engine
	log.L.Debug().Str("collection", collection).Int("id", id).Msg("Indexing item")
	switch collection {
	case "shows":
		service.loaders.ShowLoader.Clear(ctx, id)
		return service.indexShow(ctx, id)
	case "seasons":
		service.loaders.SeasonLoader.Clear(ctx, id)
		return service.indexSeason(ctx, id)
	case "episodes":
		service.loaders.EpisodeLoader.Clear(ctx, id)
		return service.indexEpisode(ctx, id)
	default:
		return merry.New("collection not supported for indexing")
	}
}
