package search

import (
	"context"
	"github.com/bcc-code/bcc-media-platform/backend/loaders"
	"github.com/google/uuid"
	"strconv"
	"strings"

	"github.com/algolia/algoliasearch-client-go/v3/algolia/opt"
	"github.com/algolia/algoliasearch-client-go/v3/algolia/search"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/samber/lo"
)

const tempIndexName = "temp"

// Reindex every supported collection
func (service *Service) Reindex(ctx context.Context) error {
	res, err := service.algoliaClient.CopyIndex(indexName, tempIndexName)
	_ = res.Wait()
	index := service.algoliaClient.InitIndex(tempIndexName)
	_, err = index.ClearObjects()
	if err != nil {
		return err
	}

	// Make sure we're not fetching from cache anywhere,
	// although that shouldn't be an issue, as we're priming on fetch anyway
	service.loaders.ShowLoader.ClearAll()
	service.loaders.ShowPermissionLoader.ClearAll()
	service.loaders.SeasonLoader.ClearAll()
	service.loaders.SeasonPermissionLoader.ClearAll()
	service.loaders.EpisodeLoader.ClearAll()
	service.loaders.EpisodePermissionLoader.ClearAll()
	service.loaders.PlaylistLoader.ClearAll()
	service.loaders.PlaylistPermissionLoader.ClearAll()

	// Makes it possible to filter in query, which fields you are searching on
	// Also configures hits per page
	titleFields, err := service.getTranslatedTitleFields()
	if err != nil {
		return err
	}
	descriptionFields, err := service.getTranslatedDescriptionFields()
	if err != nil {
		return err
	}
	relationalFields, err := service.getRelationalTranslatedFields()
	if err != nil {
		return err
	}
	searchableAttributes := opt.SearchableAttributes(
		strings.Join(titleFields, ", "),
		tagsField,
		strings.Join(descriptionFields, ", "),
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
	err = service.indexShows(ctx, index)
	if err != nil {
		return err
	}
	log.L.Debug().Str("collection", "seasons").Msg("Indexing")
	err = service.indexSeasons(ctx, index)
	if err != nil {
		return err
	}
	log.L.Debug().Str("collection", "episodes").Msg("Indexing")
	err = service.indexEpisodes(ctx, index)
	if err != nil {
		return err
	}
	log.L.Debug().Str("collection", "episodes").Msg("Indexing")
	err = service.indexPlaylists(ctx, index)
	if err != nil {
		return err
	}

	res, err = service.algoliaClient.MoveIndex(tempIndexName, indexName)
	if err != nil {
		return err
	}
	return res.Wait()
}

func (service *Service) indexShows(ctx context.Context, index *search.Index) error {
	return indexCollection[int, common.Show](
		ctx,
		index,
		service.loaders.ShowLoader,
		service.loaders.ShowPermissionLoader,
		service.queries.ListShows,
		service.showToSearchItem,
	)
}

func (service *Service) indexShow(ctx context.Context, id int) error {
	i, err := service.loaders.ShowLoader.Load(ctx, id)()
	if err != nil {
		return err
	}
	p, err := service.loaders.ShowPermissionLoader.Get(ctx, id)
	if err != nil {
		return err
	}
	return indexObject[int, common.Show](ctx, service, *i, p, service.showToSearchItem)
}

func (service *Service) indexSeasons(ctx context.Context, index *search.Index) error {
	return indexCollection[int, common.Season](
		ctx,
		index,
		service.loaders.SeasonLoader,
		service.loaders.SeasonPermissionLoader,
		service.queries.ListSeasons,
		service.seasonToSearchItem,
	)
}

func (service *Service) indexSeason(ctx context.Context, id int) error {
	i, err := service.loaders.SeasonLoader.Load(ctx, id)()
	if err != nil {
		return err
	}
	p, err := service.loaders.SeasonPermissionLoader.Get(ctx, id)
	if err != nil {
		return err
	}
	return indexObject[int, common.Season](ctx, service, *i, p, service.seasonToSearchItem)
}

func (service *Service) indexEpisodes(ctx context.Context, index *search.Index) error {
	return indexCollection[int, common.Episode](
		ctx,
		index,
		service.loaders.EpisodeLoader,
		service.loaders.EpisodePermissionLoader,
		service.queries.ListEpisodes,
		service.episodeToSearchItem,
	)
}

func (service *Service) indexEpisode(ctx context.Context, id int) error {
	i, err := service.loaders.EpisodeLoader.Load(ctx, id)()
	if err != nil {
		return err
	}
	p, err := service.loaders.EpisodePermissionLoader.Get(ctx, id)
	if err != nil {
		return err
	}
	return indexObject[int, common.Episode](ctx, service, *i, p, service.episodeToSearchItem)
}

func (service *Service) indexPlaylists(ctx context.Context, index *search.Index) error {
	return indexCollection[uuid.UUID, common.Playlist](
		ctx,
		index,
		service.loaders.PlaylistLoader,
		service.loaders.PlaylistPermissionLoader,
		service.queries.ListPlaylists,
		service.playlistToSearchItem,
	)
}

type indexable[k comparable] interface {
	GetKey() k
}

func indexCollection[k comparable, t indexable[k]](
	ctx context.Context,
	index *search.Index,
	loader *loaders.Loader[k, *t],
	permissionLoader *loaders.Loader[k, *common.Permissions[k]],
	factory func(context.Context) ([]t, error),
	converter func(context.Context, t) (searchItem, error),
) error {
	items, err := factory(ctx)
	if err != nil {
		return err
	}

	ids := lo.Map(items, func(i t, _ int) k {
		return i.GetKey()
	})

	permissionLoader.LoadMany(ctx, ids)()

	var searchItems []searchObject
	pushItems := func(force bool) error {
		if len(searchItems) > 200 || (force && len(searchItems) > 0) {
			_, err := index.SaveObjects(searchItems)
			if err != nil {
				return err
			}
			searchItems = []searchObject{}
		}
		return nil
	}

	for _, i := range items {
		p := i
		loader.Prime(ctx, p.GetKey(), &p)

		item, err := converter(ctx, p)
		if err != nil {
			return err
		}

		perm, err := permissionLoader.Get(ctx, i.GetKey())
		if err != nil {
			return err
		}

		if perm != nil {
			item.assignVisibility(perm.Availability)
			item.assignRoles(perm.Roles)
		}

		searchItems = append(searchItems, item.toSearchObject())
		err = pushItems(false)
	}
	return pushItems(true)
}

func indexObject[k comparable, t indexable[k]](
	ctx context.Context,
	service *Service,
	obj t,
	perms *common.Permissions[k],
	converter func(context.Context, t) (searchItem, error),
) error {
	item, err := converter(ctx, obj)
	if err != nil {
		return err
	}

	item.assignVisibility(perms.Availability)
	item.assignRoles(perms.Roles)
	_, err = service.index.SaveObject(item)
	return err
}

var supportedCollections = []string{
	"shows",
	"seasons",
	"episodes",
}

// DeleteModel from index by collection and id
func (service *Service) DeleteModel(_ context.Context, collection string, key string) error {
	if !lo.Contains(supportedCollections, collection) {
		// no reason to send a request if the collection isn't supported
		return nil
	}
	_, err := service.index.DeleteObject(collection + "-" + key)
	return err
}

// IndexModel by collection and id
func (service *Service) IndexModel(ctx context.Context, collection string, key string) (err error) {
	// Clearing the loaders of cached instances
	// and indexing to the search engine
	log.L.Debug().Str("collection", collection).Str("key", key).Msg("Indexing item")
	switch collection {
	case "shows":
		id, _ := strconv.ParseInt(key, 10, 64)
		service.loaders.ShowLoader.Clear(ctx, int(id))
		return service.indexShow(ctx, int(id))
	case "seasons":
		id, _ := strconv.ParseInt(key, 10, 64)
		service.loaders.SeasonLoader.Clear(ctx, int(id))
		return service.indexSeason(ctx, int(id))
	case "episodes":
		id, _ := strconv.ParseInt(key, 10, 64)
		service.loaders.EpisodeLoader.Clear(ctx, int(id))
		return service.indexEpisode(ctx, int(id))
	}
	// no reason to return errors, as we know quite well what is supported
	return nil
}
