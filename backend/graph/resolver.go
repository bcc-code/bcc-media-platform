package graph

import (
	"context"
	"strconv"

	"github.com/ansel1/merry/v2"
	"github.com/aws/aws-sdk-go/service/cloudfront/sign"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/search"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/brunstadtv/backend/user"
	"github.com/bcc-code/brunstadtv/backend/utils"
	"github.com/graph-gophers/dataloader/v7"
	"github.com/samber/lo"
)

type apiConfig interface {
	GetVOD2Domain() string
	GetFilesCDNDomain() string
}

// This file will not be regenerated automatically.
//
// It serves as dependency injection for your app, add any dependencies you require here.

// Resolver is the main struct for the GQL implementation
// It contains references to all external services and config
type Resolver struct {
	Queries       *sqlc.Queries
	Loaders       *common.BatchLoaders
	SearchService *search.Service
	URLSigner     *sign.URLSigner
	APIConfig     apiConfig
}

// ErrItemNotFound for not found items
var (
	ErrItemNotFound = merry.Sentinel("item not found")
)

type itemLoaders[k comparable, t any] struct {
	Permissions *dataloader.Loader[k, *common.Permissions[k]]
	Item        *dataloader.Loader[k, *t]
}

func toItemLoaders[k comparable, t any](item *dataloader.Loader[k, *t], permissions *dataloader.Loader[k, *common.Permissions[k]]) *itemLoaders[k, t] {
	return &itemLoaders[k, t]{
		Item:        item,
		Permissions: permissions,
	}
}

// resolverFor returns a resolver for the specified item
func resolverFor[k comparable, t any, r any](ctx context.Context, loaders *itemLoaders[k, t], id k, converter func(context.Context, *t) r) (res r, err error) {
	obj, err := common.GetFromLoaderByID(ctx, loaders.Item, id)
	if err != nil {
		return res, err
	}
	if obj == nil {
		return res, merry.Wrap(ErrItemNotFound)
	}

	if t, ok := any(obj).(common.HasKey[k]); ok {
		err = user.ValidateAccess(ctx, loaders.Permissions, t.GetKey())
		if err != nil {
			return res, nil
		}
	}

	return converter(ctx, obj), nil
}

// resolverForIntID returns a resolver for items with ints as keys
func resolverForIntID[t any, r any](ctx context.Context, loaders *itemLoaders[int, t], id string, converter func(context.Context, *t) r) (res r, err error) {
	intID, err := strconv.ParseInt(id, 10, 32)
	if err != nil {
		return res, err
	}

	return resolverFor(ctx, loaders, int(intID), converter)
}

func itemsResolverFor[k comparable, kr comparable, t any, r any](ctx context.Context, loaders *itemLoaders[k, t], listLoader *dataloader.Loader[kr, []*k], id kr, converter func(context.Context, *t) r) ([]r, error) {
	itemIds, err := common.GetFromLoaderForKey(ctx, listLoader, id)
	if err != nil {
		return nil, err
	}

	ids := lo.Map(lo.Filter(itemIds, func(i *k, _ int) bool {
		if loaders.Permissions != nil {
			return user.ValidateAccess(ctx, loaders.Permissions, *i) == nil
		}
		return true
	}), func(i *k, _ int) k {
		return *i
	})

	items, err := common.GetManyFromLoader(ctx, loaders.Item, ids)

	return utils.MapWithCtx(ctx, items, converter), nil
}

func itemsResolverForIntID[t any, r any](ctx context.Context, loaders *itemLoaders[int, t], listLoader *dataloader.Loader[int, []*int], id string, converter func(context.Context, *t) r) ([]r, error) {
	intID, err := strconv.ParseInt(id, 10, 32)
	if err != nil {
		return nil, err
	}
	return itemsResolverFor(ctx, loaders, listLoader, int(intID), converter)
}
