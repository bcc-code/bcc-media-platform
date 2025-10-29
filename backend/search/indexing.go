package search

import (
	"bytes"
	"context"
	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/loaders"
	"github.com/bcc-code/bcc-media-platform/backend/log"
	"github.com/elastic/go-elasticsearch/v8"
	"github.com/orsinium-labs/enum"
	"github.com/samber/lo"
	"strconv"
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

func (service *Service) indexShow(ctx context.Context, id int) error {
	i, err := service.loaders.ShowLoader.Load(ctx, id)()
	if err != nil {
		return err
	}
	p, err := service.loaders.ShowPermissionLoader.Get(ctx, id)
	if err != nil {
		return err
	}

	return indexObjectElastic[int, common.Show](ctx, service.elasticClient, IndexShows, *i, p, service.showToSearchItem)
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

	return indexObjectElastic[int, common.Season](ctx, service.elasticClient, IndexSeasons, *i, p, service.seasonToSearchItem)
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

	return indexObjectElastic[int, common.Episode](ctx, service.elasticClient, IndexEpisodes, *i, p, service.episodeToSearchItem)
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

	var err error
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
