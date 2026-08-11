package user

import (
	"context"
	"fmt"
	"time"

	"github.com/bcc-code/bcc-media-platform/backend/loaders"

	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/unleash"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"github.com/samber/lo"
)

// Sentinel errors
var (
	ErrItemNotPublished    = common.ErrItemNotPublished
	ErrItemNoAccess        = common.ErrItemNoAccess
	ErrPublishDateInFuture = merry.Sentinel("Publish date in the future")
)

// CheckConditions defines which conditions that should be checked
type CheckConditions struct {
	FromDate    bool
	PublishDate bool
	Download    bool
}

// ValidateAccess returns error if user in context does not have access to the specified item
func ValidateAccess[k comparable](
	ctx context.Context,
	permissionLoader *loaders.Loader[k, *common.Permissions[k]],
	id k,
	conditions CheckConditions,
) error {
	ginCtx, err := utils.GinCtx(ctx)
	if err != nil {
		return err
	}
	rs := GetRolesFromCtx(ginCtx)

	perms, err := permissionLoader.Get(ctx, id)
	if err != nil {
		return err
	}

	roles := perms.Roles
	availability := perms.Availability

	if conditions.Download {
		granted := lo.Intersect(rs, roles.Download)
		if len(granted) == 0 {
			return merry.Wrap(ErrItemNoAccess)
		}
		unleash.ReportDecisive(ginCtx, granted)
	}

	if earlyAccess := lo.Intersect(rs, roles.EarlyAccess); len(earlyAccess) > 0 && (availability.Published || availability.Unlisted) {
		unleash.ReportDecisive(ginCtx, earlyAccess)
		return nil
	}

	if !(availability.Published || availability.Unlisted) ||
		availability.To.Before(time.Now()) ||
		(conditions.FromDate && availability.From.After(time.Now())) {
		return merry.Wrap(fmt.Errorf("item ID: %v, ERR: %w", id, ErrItemNotPublished))
	}

	access := lo.Intersect(rs, roles.Access)
	if len(access) == 0 {
		return merry.Wrap(ErrItemNoAccess)
	}
	// Only counts when a feature-flag role is the sole reason this passed; if an
	// ordinary role is in the intersection the flag changed nothing.
	unleash.ReportDecisive(ginCtx, access)

	if conditions.PublishDate && availability.PublishedOn.After(time.Now()) {
		return merry.Wrap(ErrPublishDateInFuture)
	}

	return nil
}
