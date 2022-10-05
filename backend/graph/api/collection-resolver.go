package graph

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/graph/api/model"
	"github.com/bcc-code/brunstadtv/backend/items/collection"
	"github.com/bcc-code/brunstadtv/backend/utils"
	"strconv"
)

func preloadLoaders(ctx context.Context, loaders *common.BatchLoaders, entries []collection.Entry) {
	for _, e := range entries {
		switch e.Type {
		case "show":
			loaders.ShowLoader.Load(ctx, e.ID)
		case "season":
			loaders.SeasonLoader.Load(ctx, e.ID)
		case "episode":
			loaders.EpisodeLoader.Load(ctx, e.ID)
		case "page":
			loaders.PageLoader.Load(ctx, e.ID)
		case "section":
			loaders.SectionLoader.Load(ctx, e.ID)
		}
	}
}

func collectionEntryResolver(ctx context.Context, loaders *common.BatchLoaders, filteredLoaders *common.FilteredLoaders, collectionId int, first *int, offset *int) (*utils.PaginationResult[model.Item], error) {
	entries, err := collection.GetCollectionEntries(ctx, loaders, filteredLoaders, collectionId)
	if err != nil {
		return nil, err
	}

	pagination := utils.Paginate(entries, first, offset, nil)

	preloadLoaders(ctx, loaders, pagination.Items)

	var items []model.Item
	for _, e := range pagination.Items {
		var item model.Item
		switch e.Type {
		case "page":
			i, err := common.GetFromLoaderByID(ctx, loaders.PageLoader, e.ID)
			if err != nil {
				return nil, err
			}
			item = model.PageItemFrom(ctx, i, e.Sort)
		case "show":
			i, err := common.GetFromLoaderByID(ctx, loaders.ShowLoader, e.ID)
			if err != nil {
				return nil, err
			}
			item = model.ShowItemFrom(ctx, i, e.Sort)
		case "season":
			i, err := common.GetFromLoaderByID(ctx, loaders.SeasonLoader, e.ID)
			if err != nil {
				return nil, err
			}
			item = model.SeasonItemFrom(ctx, i, e.Sort)
		case "episode":
			i, err := common.GetFromLoaderByID(ctx, loaders.EpisodeLoader, e.ID)
			if err != nil {
				return nil, err
			}
			item = model.EpisodeItemFrom(ctx, i, e.Sort)
		}
		if item != nil {
			items = append(items, item)
		}
	}

	return &utils.PaginationResult[model.Item]{
		Total:  pagination.Total,
		First:  pagination.First,
		Offset: pagination.Offset,
		Items:  items,
	}, nil
}

func collectionItemResolver(ctx context.Context, r *Resolver, id string, first *int, offset *int) (*utils.PaginationResult[model.Item], error) {
	int64ID, _ := strconv.ParseInt(id, 10, 32)

	section, err := common.GetFromLoaderByID(ctx, r.Loaders.SectionLoader, int(int64ID))
	if err != nil {
		return nil, err
	}

	if !section.CollectionID.Valid {
		return nil, nil
	}

	return collectionEntryResolver(ctx, r.Loaders, r.FilteredLoaders(ctx), int(section.CollectionID.Int64), first, offset)
}

func collectionItemResolverFromCollection(ctx context.Context, r *Resolver, id string, first *int, offset *int) (*utils.PaginationResult[model.Item], error) {
	int64ID, _ := strconv.ParseInt(id, 10, 32)

	return collectionEntryResolver(ctx, r.Loaders, r.FilteredLoaders(ctx), int(int64ID), first, offset)
}
