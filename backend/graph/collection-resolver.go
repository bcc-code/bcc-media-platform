package graph

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/common"
	gqlmodel "github.com/bcc-code/brunstadtv/backend/graph/model"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/brunstadtv/backend/user"
	"github.com/bcc-code/brunstadtv/backend/utils"
	"github.com/graph-gophers/dataloader/v7"
	"strconv"
)

func itemsResolverForIntID[t any, r any](ctx context.Context, id string, loader *dataloader.Loader[int, []*t], converter func(context.Context, *t) r) ([]r, error) {
	intID, err := strconv.ParseInt(id, 10, 32)
	if err != nil {
		return nil, err
	}
	return itemsResolverFor(ctx, int(intID), loader, converter)
}

func getFromLoaderAndFilterAccess[k comparable, t restrictedItem](ctx context.Context, loader *dataloader.Loader[k, *t], ids []k) ([]*t, error) {
	items, err := common.GetManyFromLoader(ctx, loader, ids)
	if err != nil {
		return nil, err
	}
	var result []*t
	for _, i := range items {
		err := user.ValidateAccess(ctx, *i)
		if err != nil {
			continue
		}
		result = append(result, i)
	}
	return result, nil
}

func toCollectionItemArray[t gqlmodel.Item](items []t) []gqlmodel.Item {
	var result []gqlmodel.Item
	for _, i := range items {
		result = append(result, i)
	}
	return result
}

func preloadIds(ctx context.Context, loaders *BatchLoaders, idMap map[string][]int) {
	for t, ids := range idMap {
		switch t {
		case "page":
			loaders.PageLoader.LoadMany(ctx, ids)
		case "show":
			loaders.ShowLoader.LoadMany(ctx, ids)
		case "season":
			loaders.SeasonLoader.LoadMany(ctx, ids)
		case "episode":
			loaders.EpisodeLoader.LoadMany(ctx, ids)
		}
	}
}

func iterateAndPreloadCollectionItems(ctx context.Context, loaders *BatchLoaders, items []*sqlc.CollectionItem) {
	var idMap = map[string][]int{}
	for _, item := range items {
		t := item.Type.ValueOrZero()
		var id int
		switch t {
		case "page":
			id = int(item.PageID.ValueOrZero())
		case "show":
			id = int(item.ShowID.ValueOrZero())
		case "season":
			id = int(item.SeasonID.ValueOrZero())
		case "episode":
			id = int(item.EpisodeID.ValueOrZero())
		}
		if _, ok := idMap[t]; !ok {
			idMap[t] = []int{}
		}
		idMap[t] = append(idMap[t], id)
	}
	preloadIds(ctx, loaders, idMap)
}

func itemToGQL(ctx context.Context, r *Resolver, item *sqlc.CollectionItem) (gqlmodel.Item, error) {
	var res gqlmodel.Item
	sort := int(item.Sort.ValueOrZero())
	switch item.Type.ValueOrZero() {
	case "page":
		stringId := strconv.Itoa(int(item.PageID.ValueOrZero()))
		page, err := r.QueryRoot().Page(ctx, &stringId, nil)
		if err != nil {
			return res, err
		}
		return gqlmodel.PageItem{
			ID:    page.ID,
			Title: page.Title,
			Page:  page,
			Sort:  sort,
		}, nil
	case "show":
		show, err := r.QueryRoot().Show(ctx, strconv.Itoa(int(item.ShowID.ValueOrZero())))
		if err != nil {
			return res, err
		}
		return gqlmodel.ShowItem{
			ID:    show.ID,
			Title: show.Title,
			Show:  show,
			Sort:  sort,
		}, nil
	case "season":
		season, err := r.QueryRoot().Season(ctx, strconv.Itoa(int(item.SeasonID.ValueOrZero())))
		if err != nil {
			return res, err
		}
		return gqlmodel.SeasonItem{
			ID:     season.ID,
			Title:  season.Title,
			Season: season,
			Sort:   sort,
		}, nil
	case "episode":
		episode, err := r.QueryRoot().Episode(ctx, strconv.Itoa(int(item.EpisodeID.ValueOrZero())))
		if err != nil {
			return res, err
		}
		return gqlmodel.EpisodeItem{
			ID:      episode.ID,
			Title:   episode.Title,
			Episode: episode,
			Sort:    sort,
		}, nil
	}
	return res, ErrUnsupportedType
}

func getItemsForSelectCollection(ctx context.Context, r *Resolver, id int) ([]gqlmodel.Item, error) {
	loaders := r.Loaders
	items, err := common.GetFromLoaderForKey(ctx, loaders.CollectionItemLoader, id)
	if err != nil {
		return nil, err
	}
	iterateAndPreloadCollectionItems(ctx, loaders, items)
	var result []gqlmodel.Item
	for _, item := range items {
		res, err := itemToGQL(ctx, r, item)
		if err != nil {
			continue
		}
		result = append(result, res)
	}
	return result, nil
}

func getItemsForQueryCollection(ctx context.Context, loaders *BatchLoaders, id int, collection string) ([]gqlmodel.Item, error) {
	itemIds, err := loaders.CollectionItemIdsLoader.Load(ctx, id)()
	if err != nil {
		return nil, err
	}

	switch collection {
	case "pages":
		items, err := getFromLoaderAndFilterAccess(ctx, loaders.PageLoader, itemIds)
		if err != nil {
			return nil, err
		}
		return toCollectionItemArray(utils.MapWithCtx(ctx, items, gqlmodel.PageItemFrom)), nil
	case "shows":
		items, err := getFromLoaderAndFilterAccess(ctx, loaders.ShowLoader, itemIds)
		if err != nil {
			return nil, err
		}
		return toCollectionItemArray(utils.MapWithCtx(ctx, items, gqlmodel.ShowItemFrom)), nil
	case "seasons":
		items, err := getFromLoaderAndFilterAccess(ctx, loaders.SeasonLoader, itemIds)
		if err != nil {
			return nil, err
		}
		return toCollectionItemArray(utils.MapWithCtx(ctx, items, gqlmodel.SeasonItemFrom)), nil
	case "episodes":
		items, err := getFromLoaderAndFilterAccess(ctx, loaders.EpisodeLoader, itemIds)
		if err != nil {
			return nil, err
		}
		return toCollectionItemArray(utils.MapWithCtx(ctx, items, gqlmodel.EpisodeItemFrom)), nil
	}
	return nil, ErrUnsupportedCollection
}

func collectionItemResolver(ctx context.Context, r *Resolver, id string) ([]gqlmodel.Item, error) {
	int64ID, _ := strconv.ParseInt(id, 10, 32)
	intID := int(int64ID)

	section, err := r.Loaders.SectionLoader.Load(ctx, intID)()
	if err != nil {
		return nil, err
	}

	if !section.CollectionID.Valid {
		return nil, nil
	}

	col, err := r.Loaders.CollectionLoader.Load(ctx, int(section.CollectionID.ValueOrZero()))()
	if err != nil {
		return nil, err
	}

	switch col.FilterType.ValueOrZero() {
	case "select":
		return getItemsForSelectCollection(ctx, r, int(col.ID))
	case "query":
		return getItemsForQueryCollection(ctx, r.Loaders, int(col.ID), col.Collection.ValueOrZero())
	}
	return nil, nil
}
