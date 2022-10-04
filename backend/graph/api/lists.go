package graph

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/user"
	"github.com/graph-gophers/dataloader/v7"
	"strconv"
)

func getFirstAccessibleID(ctx context.Context, permissionLoader *dataloader.Loader[int, *common.Permissions[int]], ids []*int) *int {
	for i := 0; i < len(ids); i++ {
		if i > 10 {
			break
		}
		id := ids[i]
		if id == nil {
			continue
		}
		err := user.ValidateAccess(ctx, permissionLoader, *id)
		if err == nil {
			return id
		}
	}
	return nil
}

func getFirstLastAccessibleID(ctx context.Context, permissionLoader *dataloader.Loader[int, *common.Permissions[int]], ids []*int) *int {
	length := len(ids)
	for i := length - 1; i >= 0; i-- {
		if i < length-10 {
			break
		}
		id := ids[i]
		if id == nil {
			continue
		}
		err := user.ValidateAccess(ctx, permissionLoader, *id)
		if err == nil {
			return id
		}
	}
	return nil
}

func firstOf[R any](
	ctx context.Context,
	keyID string,
	permissionLoader *dataloader.Loader[int, *common.Permissions[int]],
	listLoader *dataloader.Loader[int, []*int],
	resolver func(ctx context.Context, id string) (*R, error),
) (*R, error) {
	intID, err := strconv.ParseInt(keyID, 10, 64)
	if err != nil {
		return nil, err
	}
	itemIds, err := common.GetFromLoaderForKey(ctx, listLoader, int(intID))

	id := getFirstAccessibleID(ctx, permissionLoader, itemIds)

	if id != nil {
		return resolver(ctx, strconv.Itoa(*id))
	}

	return nil, nil
}

func lastOf[R any](
	ctx context.Context,
	keyID string,
	permissionLoader *dataloader.Loader[int, *common.Permissions[int]],
	listLoader *dataloader.Loader[int, []*int],
	resolver func(ctx context.Context, id string) (*R, error),
) (*R, error) {
	intID, err := strconv.ParseInt(keyID, 10, 64)
	if err != nil {
		return nil, err
	}
	itemIds, err := common.GetFromLoaderForKey(ctx, listLoader, int(intID))

	id := getFirstLastAccessibleID(ctx, permissionLoader, itemIds)

	if id != nil {
		return resolver(ctx, strconv.Itoa(*id))
	}

	return nil, nil
}
