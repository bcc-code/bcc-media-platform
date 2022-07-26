package user

import (
	"context"
	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/utils"
	"github.com/samber/lo"
	"time"
)

var (
	errItemNotPublished = merry.Sentinel("Selected item is not published")
	errItemNoAccess     = merry.Sentinel("User does not have access to this item")
)

type restrictedItem interface {
	GetRoles() common.Roles
	GetAvailability() common.Availability
}

// ValidateAccess returns error if user in context does not have access to the specified item
func ValidateAccess[t restrictedItem](ctx context.Context, item t) error {
	ginCtx, err := utils.GinCtx(ctx)
	if err != nil {
		return err
	}
	u := GetFromCtx(ginCtx)

	roles := item.GetRoles()
	availability := item.GetAvailability()

	if len(lo.Intersect(u.Roles, roles.EarlyAccess)) == 0 && (!availability.Published ||
		availability.From.After(time.Now()) ||
		availability.To.Before(time.Now())) {
		return merry.Wrap(errItemNotPublished)
	}

	if len(lo.Intersect(u.Roles, roles.Access)) == 0 {
		return merry.Wrap(errItemNoAccess)
	}
	return nil
}
