package user

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/batchloaders"
	"time"

	"github.com/graph-gophers/dataloader/v7"

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

// ValidateAccess returns error if user in context does not have access to the specified item
func ValidateAccess[k comparable](ctx context.Context, permissionLoader *dataloader.Loader[k, *common.Permissions[k]], id k) error {
	ginCtx, err := utils.GinCtx(ctx)
	if err != nil {
		return err
	}
	rs := GetRolesFromCtx(ginCtx)

	perms, err := batchloaders.GetByID(ctx, permissionLoader, id)
	if err != nil {
		return err
	}

	roles := perms.Roles
	availability := perms.Availability

	if len(lo.Intersect(rs, roles.EarlyAccess)) == 0 && (!availability.Published ||
		availability.From.After(time.Now()) ||
		availability.To.Before(time.Now())) {
		return merry.Wrap(ErrItemNotPublished)
	}

	if len(lo.Intersect(rs, roles.Access)) == 0 {
		return merry.Wrap(ErrItemNoAccess)
	}
	return nil
}
