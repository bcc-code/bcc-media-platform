package search

import (
	"bytes"
	"context"
	"github.com/algolia/algoliasearch-client-go/v3/algolia/opt"
	"github.com/algolia/algoliasearch-client-go/v3/algolia/search"
	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/loaders"
	"github.com/bcc-code/bcc-media-platform/backend/log"
	"github.com/elastic/go-elasticsearch/v8"
	"github.com/google/uuid"
	"github.com/orsinium-labs/enum"
	"github.com/samber/lo"
	"strconv"
	"strings"
)

const tempIndexName = "bccm-temp"

type elasticIndex enum.Member[string]

var (
	IndexShows    = elasticIndex{"bccm-shows"}
	IndexSeasons  = elasticIndex{"bccm-seasons"}
	IndexEpisodes = elasticIndex{"bccm-episodes"}
	Indices       = enum.New(IndexShows, IndexSeasons, IndexEpisodes)
)

func (service *Service) resetElasticIndexes(ctx context.Context) error {
	for _, index := range Indices.Members() {
		indexExists, err := service.elasticClient.Indices.Exists(index.Value).Do(ctx)
		if err != nil {
			return merry.Wrap(err)
		}

		if indexExists {
			_, err = service.elasticClient.Indices.Delete(index.Value).Do(ctx)
			if err != nil {
				return err
			}
		}

		indexTemplate := &bytes.Buffer{}
		err = templates.ExecuteTemplate(indexTemplate, "indices.json.tmpl", nil)
		if err != nil {
			return merry.Wrap(err)
		}

		_, err = service.elasticClient.Indices.Create(index.Value).Raw(indexTemplate).Do(ctx)
		if err != nil {
			return err
		}
	}

	return nil
}

// ReindexElastic reindexes all data in elastic
//
// Please note that this will delete all data in elastic first, then recreate it
// This may not be what we want in the long term but it works for now, and is simple
func (service *Service) ReindexElastic(ctx context.Context) error {
	err := service.resetElasticIndexes(ctx)
	if err != nil {
		return err
	}
	log.L.Debug().Str("collection", "shows").Msg("Indexing")
	err = indexCollectionElastic[int, common.Show](
		ctx,
		service.elasticClient,
		IndexShows,
		service.loaders.ShowLoader,
		service.loaders.ShowPermissionLoader,
		service.queries.ListShows,
		service.showToSearchItem,
	)
	if err != nil {
		return err
	}

	log.L.Debug().Str("collection", "seasons").Msg("Indexing")
	err = indexCollectionElastic[int, common.Season](
		ctx,
		service.elasticClient,
		IndexSeasons,
		service.loaders.SeasonLoader,
		service.loaders.SeasonPermissionLoader,
		service.queries.ListSeasons,
		service.seasonToSearchItem,
	)
	if err != nil {
		return err
	}

	log.L.Debug().Str("collection", "episodes").Msg("Indexing")
	err = indexCollectionElastic[int, common.Episode](
		ctx,
		service.elasticClient,
		IndexEpisodes,
		service.loaders.EpisodeLoader,
		service.loaders.EpisodePermissionLoader,
		service.queries.ListEpisodes,
		service.episodeToSearchItem,
	)
	if err != nil {
		return err
	}

	return nil
}

// Reindex every supported collection with Algolia
func (service *Service) Reindex(ctx context.Context) error {
	res, err := service.algoliaClient.CopyIndex(indexName, tempIndexName)
	if err != nil {
		return err
	}
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

	err = indexObjectElastic[int, common.Show](ctx, service.elasticClient, IndexShows, *i, p, service.showToSearchItem)
	if err != nil {
		log.L.Error().Err(err).Msg("Could not index show in elastic")
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

	err = indexObjectElastic[int, common.Season](ctx, service.elasticClient, IndexSeasons, *i, p, service.seasonToSearchItem)
	if err != nil {
		log.L.Error().Err(err).Msg("Could not index season in elastic")
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

	err = indexObjectElastic[int, common.Episode](ctx, service.elasticClient, IndexEpisodes, *i, p, service.episodeToSearchItem)
	if err != nil {
		log.L.Error().Err(err).Msg("Could not index episode in elastic")
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

func indexCollectionElastic[k comparable, t indexable[k]](
	ctx context.Context,
	client *elasticsearch.TypedClient,
	index elasticIndex,
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

	//var searchItems []searchObject

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

		_, err = client.Index(index.Value).
			Id(item.ID).
			Request(item.toSearchObject()).
			Do(ctx)

		if err != nil {
			return merry.Wrap(err)
		}

		print(".")
	}
	return nil
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

func indexObjectElastic[k comparable, t indexable[k]](
	ctx context.Context,
	elasticClient *elasticsearch.TypedClient,
	index elasticIndex,
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

	_, err = elasticClient.Index(index.Value).
		Id(item.ID).
		Request(item.toSearchObject()).
		Do(ctx)

	return err
}

var supportedCollections = []string{
	"shows",
	"seasons",
	"episodes",
}

// DeleteModel from index by collection and id
func (service *Service) DeleteModel(ctx context.Context, collection string, key string) error {
	if !lo.Contains(supportedCollections, collection) {
		// no reason to send a request if the collection isn't supported
		return nil
	}

	_, err := service.index.DeleteObject(collection + "-" + key)
	if err != nil {
		return err
	}

	if index, ok := typeToIndexMap[collection]; ok {
		_, err = service.elasticClient.Delete(index, collection+"-"+key).Do(ctx)
	}

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
