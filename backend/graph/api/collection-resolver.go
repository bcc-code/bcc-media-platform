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

func sectionCollectionEntryResolver(ctx context.Context, loaders *common.BatchLoaders, filteredLoaders *common.FilteredLoaders, section *common.Section, first *int, offset *int) (*utils.PaginationResult[*model.SectionItem], error) {
	if !section.CollectionID.Valid {
		return &utils.PaginationResult[*model.SectionItem]{}, nil
	}

	entries, err := collection.GetCollectionEntries(ctx, loaders, filteredLoaders, int(section.CollectionID.ValueOrZero()))
	if err != nil {
		return nil, err
	}

	pagination := utils.Paginate(entries, first, offset, nil)

	preloadLoaders(ctx, loaders, pagination.Items)

	var items []*model.SectionItem
	for _, e := range pagination.Items {
		var item *model.SectionItem
		switch e.Type {
		case "page":
			i, err := common.GetFromLoaderByID(ctx, loaders.PageLoader, e.ID)
			if err != nil {
				return nil, err
			}
			item = model.PageSectionItemFrom(ctx, i, e.Sort, section.Style)
		case "show":
			i, err := common.GetFromLoaderByID(ctx, loaders.ShowLoader, e.ID)
			if err != nil {
				return nil, err
			}
			item = model.ShowSectionItemFrom(ctx, i, e.Sort, section.Style)
		case "season":
			i, err := common.GetFromLoaderByID(ctx, loaders.SeasonLoader, e.ID)
			if err != nil {
				return nil, err
			}
			item = model.SeasonSectionItemFrom(ctx, i, e.Sort, section.Style)
		case "episode":
			i, err := common.GetFromLoaderByID(ctx, loaders.EpisodeLoader, e.ID)
			if err != nil {
				return nil, err
			}
			item = model.EpisodeSectionItemFrom(ctx, i, e.Sort, section.Style)
		case "link":
			i, err := common.GetFromLoaderByID(ctx, loaders.LinkLoader, e.ID)
			if err != nil {
				return nil, err
			}
			item = model.LinkSectionItemFrom(ctx, i, e.Sort, section.Style)
		}
		if item != nil {
			items = append(items, item)
		}
	}

	return &utils.PaginationResult[*model.SectionItem]{
		Total:  pagination.Total,
		First:  pagination.First,
		Offset: pagination.Offset,
		Items:  items,
	}, nil
}

func collectionEntryResolver(ctx context.Context, loaders *common.BatchLoaders, filteredLoaders *common.FilteredLoaders, collectionId int, first *int, offset *int) (*utils.PaginationResult[model.CollectionItem], error) {
	entries, err := collection.GetCollectionEntries(ctx, loaders, filteredLoaders, collectionId)
	if err != nil {
		return nil, err
	}

	pagination := utils.Paginate(entries, first, offset, nil)

	preloadLoaders(ctx, loaders, pagination.Items)

	var items []model.CollectionItem
	for _, e := range pagination.Items {
		var item model.CollectionItem
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

	return &utils.PaginationResult[model.CollectionItem]{
		Total:  pagination.Total,
		First:  pagination.First,
		Offset: pagination.Offset,
		Items:  items,
	}, nil
}

func collectionItemResolverFromCollection(ctx context.Context, r *Resolver, id string, first *int, offset *int) (*utils.PaginationResult[model.CollectionItem], error) {
	int64ID, _ := strconv.ParseInt(id, 10, 32)

	return collectionEntryResolver(ctx, r.Loaders, r.FilteredLoaders(ctx), int(int64ID), first, offset)
}

func sectionCollectionItemResolver(ctx context.Context, r *Resolver, id string, first *int, offset *int) (*model.SectionItemPagination, error) {
	int64ID, _ := strconv.ParseInt(id, 10, 32)

	section, err := common.GetFromLoaderByID(ctx, r.Loaders.SectionLoader, int(int64ID))
	if err != nil {
		return nil, err
	}

	pagination, err := sectionCollectionEntryResolver(ctx, r.Loaders, r.FilteredLoaders(ctx), section, first, offset)
	if err != nil {
		return nil, err
	}

	return &model.SectionItemPagination{
		Total:  pagination.Total,
		First:  pagination.First,
		Offset: pagination.Offset,
		Items:  pagination.Items,
	}, nil
}
