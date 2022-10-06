package graph

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/graph/api/model"
	"github.com/bcc-code/brunstadtv/backend/items/collection"
	"github.com/bcc-code/brunstadtv/backend/user"
	"github.com/bcc-code/brunstadtv/backend/utils"
	"github.com/bcc-code/mediabank-bridge/log"
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

func getEntriesWithAccess(ctx context.Context, loaders *common.BatchLoaders, entries []collection.Entry) []collection.Entry {
	for _, e := range entries {
		switch e.Type {
		case common.TypePage:
			loaders.PagePermissionLoader.Load(ctx, e.ID)
		case common.TypeShow:
			loaders.ShowPermissionLoader.Load(ctx, e.ID)
		case common.TypeSeason:
			loaders.SeasonPermissionLoader.Load(ctx, e.ID)
		case common.TypeEpisode:
			loaders.EpisodePermissionLoader.Load(ctx, e.ID)
		case common.TypeSection:
			loaders.SectionPermissionLoader.Load(ctx, e.ID)
		}
	}

	var returnEntries []collection.Entry
	for _, e := range entries {
		var success bool
		switch e.Type {
		case common.TypePage:
			success = user.ValidateAccess(ctx, loaders.PagePermissionLoader, e.ID) == nil
		case common.TypeShow:
			success = user.ValidateAccess(ctx, loaders.ShowPermissionLoader, e.ID) == nil
		case common.TypeSeason:
			success = user.ValidateAccess(ctx, loaders.SeasonPermissionLoader, e.ID) == nil
		case common.TypeEpisode:
			success = user.ValidateAccess(ctx, loaders.EpisodePermissionLoader, e.ID) == nil
		case common.TypeSection:
			success = user.ValidateAccess(ctx, loaders.SectionPermissionLoader, e.ID) == nil
		default:
			log.L.Error().Str("type", string(e.Type)).Msg("Invalid/unsupported entry type in collection")
		}
		if success {
			returnEntries = append(returnEntries, e)
		}
	}

	return returnEntries
}

func sectionCollectionEntryResolver(ctx context.Context, loaders *common.BatchLoaders, section *common.Section, first *int, offset *int) (*utils.PaginationResult[*model.SectionItem], error) {
	if !section.CollectionID.Valid {
		return nil, nil
	}

	entries, err := collection.GetCollectionEntries(ctx, loaders, int(section.CollectionID.ValueOrZero()))
	if err != nil {
		return nil, err
	}

	returnEntries := getEntriesWithAccess(ctx, loaders, entries)

	pagination := utils.Paginate(returnEntries, first, offset, nil)

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

func collectionEntryResolver(ctx context.Context, loaders *common.BatchLoaders, collectionId int, first *int, offset *int) (*utils.PaginationResult[model.Item], error) {
	entries, err := collection.GetCollectionEntries(ctx, loaders, collectionId)
	if err != nil {
		return nil, err
	}

	returnEntries := getEntriesWithAccess(ctx, loaders, entries)

	pagination := utils.Paginate(returnEntries, first, offset, nil)

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

func collectionItemResolverFromCollection(ctx context.Context, r *Resolver, id string, first *int, offset *int) (*utils.PaginationResult[model.Item], error) {
	int64ID, _ := strconv.ParseInt(id, 10, 32)

	return collectionEntryResolver(ctx, r.Loaders, int(int64ID), first, offset)
}

func sectionCollectionItemResolver(ctx context.Context, r *Resolver, id string, first *int, offset *int) (*utils.PaginationResult[*model.SectionItem], error) {
	int64ID, _ := strconv.ParseInt(id, 10, 32)

	section, err := common.GetFromLoaderByID(ctx, r.Loaders.SectionLoader, int(int64ID))
	if err != nil {
		return nil, err
	}

	return sectionCollectionEntryResolver(ctx, r.Loaders, section, first, offset)
}
