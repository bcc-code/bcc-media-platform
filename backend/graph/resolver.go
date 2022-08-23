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

type restrictedItem interface {
	GetRoles() common.Roles
	GetAvailability() common.Availability
}

// ErrItemNotFound for not found items
var (
	ErrItemNotFound = merry.Sentinel("item not found")
)

type hasKey[k comparable] interface {
	GetKey() k
}

func resolveList[k comparable, t hasKey[k], r any](
	ctx context.Context,
	loader *dataloader.Loader[k, *t],
	key string,
	factory func(context.Context) ([]t, error),
	converter func(context.Context, *t) r,
) ([]r, error) {
	items, err := common.List(ctx, loader, key, factory)
	if err != nil {
		return nil, err
	}
	return utils.MapWithCtx(ctx, lo.Filter(items, func(i *t, _ int) bool {
		// Validate that user has access
		switch v := any(i).(type) {
		case restrictedItem:
			return user.ValidateAccess(ctx, v) == nil
		default:
			return true
		}
	}), converter), nil
}

// resolverFor returns a resolver for the specified item
func resolverFor[k comparable, t any, r any](ctx context.Context, id k, loader *dataloader.Loader[k, *t], converter func(context.Context, *t) r) (res r, err error) {
	obj, err := common.GetFromLoaderByID(ctx, loader, id)
	if err != nil {
		return res, err
	}
	if obj == nil {
		return res, merry.Wrap(ErrItemNotFound)
	}
	switch t := any(obj).(type) {
	case restrictedItem:
		err = user.ValidateAccess(ctx, t)
		if err != nil {
			return res, err
		}
	}

	return converter(ctx, obj), nil
}

// resolverForIntID returns a resolver for items with ints as keys
func resolverForIntID[t any, r any](ctx context.Context, id string, loader *dataloader.Loader[int, *t], converter func(context.Context, *t) r) (res r, err error) {
	intID, err := strconv.ParseInt(id, 10, 32)
	if err != nil {
		return res, err
	}

	return resolverFor(ctx, int(intID), loader, converter)
}

func itemsResolverFor[k comparable, t any, r any](ctx context.Context, id k, loader *dataloader.Loader[k, []*t], converter func(context.Context, *t) r) ([]r, error) {
	items, err := common.GetFromLoaderForKey(ctx, loader, id)
	if err != nil {
		return nil, err
	}

	return utils.MapWithCtx(ctx, lo.Filter(items, func(i *t, _ int) bool {
		// Validate that user has access
		switch v := any(i).(type) {
		case restrictedItem:
			return user.ValidateAccess(ctx, v) == nil
		default:
			return true
		}
	}), converter), nil
}
