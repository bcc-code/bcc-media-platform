package graph

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/batchloaders"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/graph/api/model"
	"github.com/bcc-code/brunstadtv/backend/items/collection"
	"github.com/bcc-code/brunstadtv/backend/user"
	"github.com/bcc-code/brunstadtv/backend/utils"
	"github.com/bcc-code/mediabank-bridge/log"
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

func sectionCollectionEntryResolver(
	ctx context.Context,
	loaders *common.BatchLoaders,
	filteredLoaders *common.FilteredLoaders,
	section *common.Section,
	first *int,
	offset *int,
) (*utils.PaginationResult[*model.SectionItem], error) {
	if !section.CollectionID.Valid {
		return &utils.PaginationResult[*model.SectionItem]{}, nil
	}

	collectionId := int(section.CollectionID.ValueOrZero())

	col, err := batchloaders.GetByID(ctx, loaders.CollectionLoader, collectionId)
	if err != nil {
		return nil, err
	}

	entries, err := collection.GetCollectionEntries(ctx, loaders, filteredLoaders, collectionId)
	if err != nil {
		return nil, err
	}

	switch col.AdvancedType.String {
	case "continue_watching":
		ginCtx, err := utils.GinCtx(ctx)
		if err != nil {
			break
		}
		profile := user.GetProfileFromCtx(ginCtx)
		if profile == nil {
			break
		}
		ids, err := loaders.EpisodeProgressLoader.Get(ctx, profile.ID)
		if err != nil {
			return nil, err
		}

		limit := 20
		if col.Filter != nil && col.Filter.Limit != nil {
			limit = *col.Filter.Limit
		}
		var newEntries []collection.Entry
		for _, id := range utils.PointerIntArrayToIntArray(ids) {
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
		entries = newEntries
	}

	pagination := utils.Paginate(entries, first, offset, nil)

	imageStyle := sectionStyleToImageStyle(section.Style)

	preloadLoaders(ctx, loaders, pagination.Items)

	var items []*model.SectionItem
	for _, e := range pagination.Items {
		var item *model.SectionItem
		switch e.Collection {
		case "pages":
			i, err := batchloaders.GetByID(ctx, loaders.PageLoader, utils.AsInt(e.ID))
			if err != nil {
				return nil, err
			}
			if i == nil {
				log.L.Debug().Str("id", e.ID).Str("type", string(e.Collection)).Msg("Item with id not found")
				continue
			}
			item = model.PageSectionItemFrom(ctx, i, e.Sort, imageStyle)
		case "shows":
			i, err := batchloaders.GetByID(ctx, loaders.ShowLoader, utils.AsInt(e.ID))
			if err != nil {
				return nil, err
			}
			if i == nil {
				log.L.Debug().Str("id", e.ID).Str("type", string(e.Collection)).Msg("Item with id not found")
				continue
			}
			item = model.ShowSectionItemFrom(ctx, i, e.Sort, imageStyle)
		case "seasons":
			i, err := batchloaders.GetByID(ctx, loaders.SeasonLoader, utils.AsInt(e.ID))
			if err != nil {
				return nil, err
			}
			if i == nil {
				log.L.Debug().Str("id", e.ID).Str("type", string(e.Collection)).Msg("Item with id not found")
				continue
			}
			item = model.SeasonSectionItemFrom(ctx, i, e.Sort, imageStyle)
		case "episodes":
			i, err := batchloaders.GetByID(ctx, loaders.EpisodeLoader, utils.AsInt(e.ID))
			if err != nil {
				return nil, err
			}
			if i == nil {
				log.L.Debug().Str("id", e.ID).Str("type", string(e.Collection)).Msg("Item with id not found")
				continue
			}
			item = model.EpisodeSectionItemFrom(ctx, i, e.Sort, imageStyle)
		case "links":
			i, err := batchloaders.GetByID(ctx, loaders.LinkLoader, utils.AsInt(e.ID))
			if err != nil {
				return nil, err
			}
			if i == nil {
				log.L.Debug().Str("id", e.ID).Str("type", string(e.Collection)).Msg("Item with id not found")
				continue
			}
			item = model.LinkSectionItemFrom(ctx, i, e.Sort, imageStyle)
		case "studytopics":
			i, err := loaders.StudyTopicLoader.Get(ctx, utils.AsUuid(e.ID))
			if err != nil {
				return nil, err
			}
			if i == nil {
				log.L.Debug().Str("id", e.ID).Str("type", string(e.Collection)).Msg("Item with id not found")
				continue
			}
			item = model.StudyTopicSectionItemFrom(ctx, i, e.Sort, imageStyle)
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
		switch e.Collection {
		case "pages":
			i, err := batchloaders.GetByID(ctx, loaders.PageLoader, utils.AsInt(e.ID))
			if err != nil {
				return nil, err
			}
			item = model.PageItemFrom(ctx, i, e.Sort)
		case "shows":
			i, err := batchloaders.GetByID(ctx, loaders.ShowLoader, utils.AsInt(e.ID))
			if err != nil {
				return nil, err
			}
			item = model.ShowItemFrom(ctx, i, e.Sort)
		case "seasons":
			i, err := batchloaders.GetByID(ctx, loaders.SeasonLoader, utils.AsInt(e.ID))
			if err != nil {
				return nil, err
			}
			item = model.SeasonItemFrom(ctx, i, e.Sort)
		case "episodes":
			i, err := batchloaders.GetByID(ctx, loaders.EpisodeLoader, utils.AsInt(e.ID))
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

	section, err := batchloaders.GetByID(ctx, r.Loaders.SectionLoader, int(int64ID))
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
