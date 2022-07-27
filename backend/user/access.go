package user

import (
	"context"
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

type restrictedItem interface {
	GetRoles() common.Roles
	GetAvailability() common.Availability
}

// ValidateAccess returns error if user in context does not have access to the specified item
func ValidateAccess(ctx context.Context, item restrictedItem) error {
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
		return merry.Wrap(ErrItemNotPublished)
	}

	if len(lo.Intersect(u.Roles, roles.Access)) == 0 {
		return merry.Wrap(ErrItemNoAccess)
	}
	return nil
}
