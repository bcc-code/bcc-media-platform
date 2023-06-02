package graph

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/graph/api/model"
	"github.com/bcc-code/brunstadtv/backend/items/collection"
	"github.com/bcc-code/brunstadtv/backend/user"
	"github.com/bcc-code/brunstadtv/backend/utils"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/google/uuid"
	"github.com/samber/lo"
	"strconv"
)

func preloadLoaders(ctx context.Context, loaders *common.BatchLoaders, entries []collection.Entry) {
	for _, e := range entries {
		switch e.Collection {
		case "shows":
			loaders.ShowLoader.Load(ctx, utils.AsInt(e.ID))
		case "seasons":
			loaders.SeasonLoader.Load(ctx, utils.AsInt(e.ID))
		case "episodes":
			loaders.EpisodeLoader.Load(ctx, utils.AsInt(e.ID))
		case "pages":
			loaders.PageLoader.Load(ctx, utils.AsInt(e.ID))
		case "sections":
			loaders.SectionLoader.Load(ctx, utils.AsInt(e.ID))
		case "studytopics":
			loaders.StudyTopicLoader.Load(ctx, utils.AsUuid(e.ID))
		case "links":
			loaders.LinkLoader.Load(ctx, utils.AsInt(e.ID))
		}
	}
}

func sectionStyleToImageStyle(style string) common.ImageStyle {
	switch style {
	case "icon_grid", "icons":
		return common.ImageStyleIcon
	case "poster_grid", "posters":
		return common.ImageStylePoster
	case "featured":
		return common.ImageStyleFeatured
	default:
		return common.ImageStyleDefault
	}
}

func filterWithIds(col *common.Collection, entries []collection.Entry, ids []*int) []collection.Entry {
	limit := 20
	if col.Filter != nil && col.Filter.Limit != nil {
		limit = *col.Filter.Limit
	}
	var newEntries []collection.Entry
	for _, id := range utils.PointerArrayToArray(ids) {
		entry, found := lo.Find(entries, func(e collection.Entry) bool {
			return e.Collection == "episodes" && e.ID == strconv.Itoa(id)
		})
		if found {
			newEntries = append(newEntries, entry)
			if len(newEntries) >= limit {
				break
			}
		}
	}
	return newEntries
}

func resolveContinueWatchingCollection(ctx context.Context, ls *common.BatchLoaders) ([]*int, error) {
	ginCtx, err := utils.GinCtx(ctx)
	if err != nil {
		return nil, err
	}
	profile := user.GetProfileFromCtx(ginCtx)
	if profile == nil {
		return nil, err
	}
	ids, err := ls.EpisodeProgressLoader.Get(ctx, profile.ID)
	if err != nil {
		return nil, err
	}
	return ids, nil
}

func resolveMyListCollection(ctx context.Context, ls *common.BatchLoaders) ([]*int, error) {
	ginCtx, err := utils.GinCtx(ctx)
	if err != nil {
		return nil, err
	}
	profile := user.GetProfileFromCtx(ginCtx)
	if profile == nil {
		return nil, nil
	}
	myListID, err := ls.ProfileMyListCollectionID.Get(ctx, profile.ID)
	if err != nil || myListID == nil {
		return nil, err
	}
	entryIDs, err := ls.UserCollectionEntryIDsLoader.Get(ctx, *myListID)
	if err != nil {
		return nil, err
	}
	collectionEntries, err := ls.UserCollectionEntryLoader.GetMany(ctx, utils.PointerArrayToArray(entryIDs))
	if err != nil {
		return nil, err
	}
	// UUIDs, but only for episodes
	uuids := lo.Map(lo.Filter(collectionEntries, func(i *common.UserCollectionEntry, _ int) bool {
		return i.Type == "episode"
	}), func(i *common.UserCollectionEntry, _ int) uuid.UUID {
		return i.ItemID
	})
	ids, err := ls.EpisodeIDFromUuidLoader.GetMany(ctx, uuids)
	if err != nil {
		return nil, err
	}
	return ids, nil
}

func mapCollectionEntriesToSectionItems(ctx context.Context, ls *common.BatchLoaders, entries []collection.Entry, imageStyle string) ([]*model.SectionItem, error) {
	var items []*model.SectionItem
	for _, e := range entries {
		var item *model.SectionItem
		switch e.Collection {
		case "pages":
			i, err := ls.PageLoader.Get(ctx, utils.AsInt(e.ID))
			if err != nil {
				return nil, err
			}
			if i == nil {
				log.L.Debug().Str("id", e.ID).Str("type", string(e.Collection)).Msg("Item with id not found")
				continue
			}
			item = model.PageSectionItemFrom(ctx, i, e.Sort, imageStyle)
		case "shows":
			i, err := ls.ShowLoader.Get(ctx, utils.AsInt(e.ID))
			if err != nil {
				return nil, err
			}
			if i == nil {
				log.L.Debug().Str("id", e.ID).Str("type", string(e.Collection)).Msg("Item with id not found")
				continue
			}
			item = model.ShowSectionItemFrom(ctx, i, e.Sort, imageStyle)
		case "seasons":
			i, err := ls.SeasonLoader.Get(ctx, utils.AsInt(e.ID))
			if err != nil {
				return nil, err
			}
			if i == nil {
				log.L.Debug().Str("id", e.ID).Str("type", string(e.Collection)).Msg("Item with id not found")
				continue
			}
			item = model.SeasonSectionItemFrom(ctx, i, e.Sort, imageStyle)
		case "episodes":
			i, err := ls.EpisodeLoader.Get(ctx, utils.AsInt(e.ID))
			if err != nil {
				return nil, err
			}
			if i == nil {
				log.L.Debug().Str("id", e.ID).Str("type", string(e.Collection)).Msg("Item with id not found")
				continue
			}
			item = model.EpisodeSectionItemFrom(ctx, i, e.Sort, imageStyle)
		case "links":
			i, err := ls.LinkLoader.Get(ctx, utils.AsInt(e.ID))
			if err != nil {
				return nil, err
			}
			if i == nil {
				log.L.Debug().Str("id", e.ID).Str("type", string(e.Collection)).Msg("Item with id not found")
				continue
			}
			item = model.LinkSectionItemFrom(ctx, i, e.Sort, imageStyle)
		case "studytopics":
			i, err := ls.StudyTopicLoader.Get(ctx, utils.AsUuid(e.ID))
			if err != nil {
				return nil, err
			}
			if i == nil {
				log.L.Debug().Str("id", e.ID).Str("type", string(e.Collection)).Msg("Item with id not found")
				continue
			}
			item = model.StudyTopicSectionItemFrom(ctx, i, e.Sort, imageStyle)
		case "games":
			i, err := ls.GameLoader.Get(ctx, utils.AsUuid(e.ID))
			if err != nil {
				return nil, err
			}
			if i == nil {
				log.L.Debug().Str("id", e.ID).Str("type", string(e.Collection)).Msg("Item with id not found")
				continue
			}
			item = model.GameSectionItemFrom(ctx, i, e.Sort, imageStyle)
		}
		if item != nil {
			items = append(items, item)
		}
	}
	return items, nil
}

func sectionCollectionEntryResolver(
	ctx context.Context,
	ls *common.BatchLoaders,
	filteredLoaders *common.FilteredLoaders,
	section *common.Section,
	first *int,
	offset *int,
) (*utils.PaginationResult[*model.SectionItem], error) {
	if !section.CollectionID.Valid {
		return &utils.PaginationResult[*model.SectionItem]{}, nil
	}

	collectionId := int(section.CollectionID.ValueOrZero())

	col, err := ls.CollectionLoader.Get(ctx, collectionId)
	if err != nil {
		return nil, err
	}

	entries, err := collection.GetCollectionEntries(ctx, ls, filteredLoaders, collectionId)
	if err != nil {
		return nil, err
	}

	switch col.AdvancedType.String {
	case "continue_watching":
		ids, err := resolveContinueWatchingCollection(ctx, ls)
		if err != nil {
			return nil, err
		}
		entries = filterWithIds(col, entries, ids)
	case "my_list":
		ids, err := resolveMyListCollection(ctx, ls)
		if err != nil {
			return nil, err
		}
		entries = filterWithIds(col, entries, ids)
	}

	pagination := utils.Paginate(entries, first, offset, nil)

	imageStyle := sectionStyleToImageStyle(section.Style)

	preloadLoaders(ctx, ls, pagination.Items)

	items, err := mapCollectionEntriesToSectionItems(ctx, ls, pagination.Items, imageStyle)
	if err != nil {
		return nil, err
	}

	return &utils.PaginationResult[*model.SectionItem]{
		Total:  pagination.Total,
		First:  pagination.First,
		Offset: pagination.Offset,
		Items:  items,
	}, nil
}

func collectionEntryResolver(ctx context.Context, ls *common.BatchLoaders, filteredLoaders *common.FilteredLoaders, collectionId int, first *int, offset *int) (*utils.PaginationResult[model.CollectionItem], error) {
	entries, err := collection.GetCollectionEntries(ctx, ls, filteredLoaders, collectionId)
	if err != nil {
		return nil, err
	}

	pagination := utils.Paginate(entries, first, offset, nil)

	preloadLoaders(ctx, ls, pagination.Items)

	var items []model.CollectionItem
	for _, e := range pagination.Items {
		var item model.CollectionItem
		switch e.Collection {
		case "pages":
			i, err := ls.PageLoader.Get(ctx, utils.AsInt(e.ID))
			if err != nil {
				return nil, err
			}
			item = model.PageItemFrom(ctx, i, e.Sort)
		case "shows":
			i, err := ls.ShowLoader.Get(ctx, utils.AsInt(e.ID))
			if err != nil {
				return nil, err
			}
			item = model.ShowItemFrom(ctx, i, e.Sort)
		case "seasons":
			i, err := ls.SeasonLoader.Get(ctx, utils.AsInt(e.ID))
			if err != nil {
				return nil, err
			}
			item = model.SeasonItemFrom(ctx, i, e.Sort)
		case "episodes":
			i, err := ls.EpisodeLoader.Get(ctx, utils.AsInt(e.ID))
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

	section, err := r.Loaders.SectionLoader.Get(ctx, int(int64ID))
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
