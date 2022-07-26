package graph

import (
	"context"
	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/brunstadtv/backend/common"
	gqlmodel "github.com/bcc-code/brunstadtv/backend/graph/model"
	"github.com/bcc-code/brunstadtv/backend/search"
	"github.com/bcc-code/brunstadtv/backend/user"
	"github.com/bcc-code/brunstadtv/backend/utils"
	"github.com/samber/lo"
	"strconv"
)

import (
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/graph-gophers/dataloader/v7"
)

// This file will not be regenerated automatically.
//
// It serves as dependency injection for your app, add any dependencies you require here.

// Resolver is the main struct for the GQL implementation
// It contains references to all external services and config
type Resolver struct {
	Queries       *sqlc.Queries
	Loaders       *BatchLoaders
	SearchService *search.Service
}

// BatchLoaders is a collection of GQL dataloaders
type BatchLoaders struct {
	PageLoader              *dataloader.Loader[int, *sqlc.PageExpanded]
	SectionLoader           *dataloader.Loader[int, *sqlc.SectionExpanded]
	SectionsLoader          *dataloader.Loader[int, []*sqlc.SectionExpanded]
	CollectionLoader        *dataloader.Loader[int, *sqlc.CollectionExpanded]
	CollectionItemIdsLoader *dataloader.Loader[int, []int]
	ShowLoader              *dataloader.Loader[int, *sqlc.ShowExpanded]
	SeasonLoader            *dataloader.Loader[int, *sqlc.SeasonExpanded]
	EpisodeLoader           *dataloader.Loader[int, *sqlc.EpisodeExpanded]
	SeasonsLoader           *dataloader.Loader[int, []*sqlc.SeasonExpanded]
	EpisodesLoader          *dataloader.Loader[int, []*sqlc.EpisodeExpanded]
	FilesLoader             *dataloader.Loader[int, []*sqlc.GetFilesForEpisodesRow]
	StreamsLoader           *dataloader.Loader[int, []*sqlc.GetStreamsForEpisodesRow]
}

type restrictedItem interface {
	GetRoles() common.Roles
	GetAvailability() common.Availability
}

// resolverFor returns a resolver for the specified item
func resolverFor[k comparable, t restrictedItem, r any](ctx context.Context, id k, loader *dataloader.Loader[k, *t], converter func(context.Context, *t) r) (res r, err error) {
	obj, err := common.GetFromLoaderByID(ctx, loader, id)
	if err != nil {
		return res, err
	}
	if obj == nil {
		return res, merry.Sentinel("item not found")
	}

	err = user.ValidateAccess(ctx, *obj)
	if err != nil {
		return res, err
	}

	return converter(ctx, obj), nil
}

// resolverForIntID returns a resolver for items with ints as keys
func resolverForIntID[t restrictedItem, r any](ctx context.Context, id string, loader *dataloader.Loader[int, *t], converter func(context.Context, *t) r) (res r, err error) {
	intID, err := strconv.ParseInt(id, 10, 32)
	if err != nil {
		return res, err
	}

	return resolverFor(ctx, int(intID), loader, converter)
}

func resolverWithoutAccessValidationFor[k comparable, t any, r any](ctx context.Context, id k, loader *dataloader.Loader[k, *t], converter func(context.Context, *t) r) (res r, err error) {
	obj, err := common.GetFromLoaderByID(ctx, loader, id)
	if err != nil {
		return res, err
	}
	if obj == nil {
		return res, merry.Sentinel("item not found")
	}

	return converter(ctx, obj), nil
}

func resolverWithoutAccessValidationForIntID[t any, r any](ctx context.Context, id string, loader *dataloader.Loader[int, *t], converter func(context.Context, *t) r) (res r, err error) {
	intID, err := strconv.ParseInt(id, 10, 32)
	if err != nil {
		return res, err
	}
	return resolverWithoutAccessValidationFor(ctx, int(intID), loader, converter)
}

func itemsResolverFor[k comparable, t restrictedItem, r any](ctx context.Context, id k, loader *dataloader.Loader[k, []*t], converter func(context.Context, *t) r) ([]r, error) {
	items, err := common.GetFromLoaderForKey(ctx, loader, id)
	if err != nil {
		return nil, err
	}

	return utils.MapWithCtx(ctx, lo.Filter(items, func(i *t, _ int) bool {
		// Validate that user has access
		return user.ValidateAccess(ctx, *i) == nil
	}), converter), nil
}

func itemsResolverForIntID[t restrictedItem, r any](ctx context.Context, id string, loader *dataloader.Loader[int, []*t], converter func(context.Context, *t) r) ([]r, error) {
	intID, err := strconv.ParseInt(id, 10, 32)
	if err != nil {
		return nil, err
	}
	return itemsResolverFor(ctx, int(intID), loader, converter)
}

func itemsResolverWithoutAccessValidationFor[k comparable, t any, r any](ctx context.Context, id k, loader *dataloader.Loader[k, []*t], converter func(context.Context, *t) r) ([]r, error) {
	items, err := common.GetFromLoaderForKey(ctx, loader, id)
	if err != nil {
		return nil, err
	}

	return utils.MapWithCtx(ctx, items, converter), nil
}

func itemsResolverWithoutAccessValidationForIntID[t any, r any](ctx context.Context, id string, loader *dataloader.Loader[int, []*t], converter func(context.Context, *t) r) ([]r, error) {
	intID, err := strconv.ParseInt(id, 10, 32)
	if err != nil {
		return nil, err
	}
	return itemsResolverWithoutAccessValidationFor(ctx, int(intID), loader, converter)
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

func toCollectionItemArray[t gqlmodel.CollectionItem](items []t) []gqlmodel.CollectionItem {
	var result []gqlmodel.CollectionItem
	for _, i := range items {
		result = append(result, i)
	}
	return result
}

func collectionResolverFor(ctx context.Context, loaders *BatchLoaders, id string) ([]gqlmodel.CollectionItem, error) {
	int64ID, _ := strconv.ParseInt(id, 10, 32)
	intID := int(int64ID)

	col, err := loaders.CollectionLoader.Load(ctx, intID)()
	if err != nil {
		return nil, err
	}

	itemIds, err := loaders.CollectionItemIdsLoader.Load(ctx, int(col.ID))()
	if err != nil {
		return nil, err
	}

	switch col.Collection.ValueOrZero() {
	case "pages":
		items, err := getFromLoaderAndFilterAccess(ctx, loaders.PageLoader, itemIds)
		if err != nil {
			return nil, err
		}
		return toCollectionItemArray(utils.MapWithCtx(ctx, items, gqlmodel.PageItemFromSQL)), nil
	case "shows":
		items, err := getFromLoaderAndFilterAccess(ctx, loaders.ShowLoader, itemIds)
		if err != nil {
			return nil, err
		}
		return toCollectionItemArray(utils.MapWithCtx(ctx, items, gqlmodel.ShowItemFromSQL)), nil
	case "seasons":
		items, err := getFromLoaderAndFilterAccess(ctx, loaders.SeasonLoader, itemIds)
		if err != nil {
			return nil, err
		}
		return toCollectionItemArray(utils.MapWithCtx(ctx, items, gqlmodel.SeasonItemFromSQL)), nil
	case "episodes":
		items, err := getFromLoaderAndFilterAccess(ctx, loaders.EpisodeLoader, itemIds)
		if err != nil {
			return nil, err
		}
		return toCollectionItemArray(utils.MapWithCtx(ctx, items, gqlmodel.EpisodeItemFromSQL)), nil
	}
	return nil, nil
}
