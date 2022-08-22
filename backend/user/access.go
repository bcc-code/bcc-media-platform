package user

import (
	"context"
	"github.com/graph-gophers/dataloader/v7"
	"time"

	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/utils"
	"github.com/samber/lo"
)

// Sentinel errors
var (
	ErrItemNotPublished = merry.Sentinel("Selected item is not published")
	ErrItemNoAccess     = merry.Sentinel("User does not have access to this item")
)

// ValidateItemAccess returns error if user in context does not have access to the specified item
func ValidateItemAccess(ctx context.Context, loaders *common.BatchLoaders, item any) error {
	switch t := item.(type) {
	case *common.Show:
		return ValidateAccess(ctx, loaders.ShowPermissionLoader, t.ID)
	case *common.Season:
		return ValidateAccess(ctx, loaders.SeasonPermissionLoader, t.ID)
	case *common.Episode:
		return ValidateAccess(ctx, loaders.EpisodePermissionLoader, t.ID)
	}
	return nil
}

// ValidateAccess returns error if user in context does not have access to the specified item
func ValidateAccess[k comparable](ctx context.Context, permissionLoader *dataloader.Loader[k, *common.Permissions], id k) error {
	ginCtx, err := utils.GinCtx(ctx)
	if err != nil {
		return err
	}
	u := GetFromCtx(ginCtx)

	perms, err := common.GetFromLoaderByID(ctx, permissionLoader, id)

	roles := perms.Roles
	availability := perms.Availability

	if len(lo.Intersect(u.Roles, roles.EarlyAccess)) == 0 && (!availability.Published ||
		availability.From.After(time.Now()) ||
		availability.To.Before(time.Now())) {
		return merry.Wrap(ErrItemNotPublished)
	}

	if len(lo.Intersect(u.Roles, roles.Access)) == 0 {
		return merry.Wrap(ErrItemNoAccess)
	}
	return nil
}
