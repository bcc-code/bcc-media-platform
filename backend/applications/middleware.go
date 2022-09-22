package applications

import (
	"context"
	"fmt"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/user"
	"github.com/gin-gonic/gin"
	"github.com/samber/lo"
)

// RoleMiddleware registers a middleware which reads the application header
func RoleMiddleware(
	applicationParser func(ctx context.Context, code string) *common.Application,
) gin.HandlerFunc {
	return func(ctx *gin.Context) {
		userRoles := user.GetFromCtx(ctx).Roles
		applicationCode := ctx.GetHeader("X-Application")

		app := applicationParser(ctx, applicationCode)
		if app == nil {
			// Means that this is not implemented. Just ignore
			ctx.Set(user.CtxRoles, userRoles)
			return
		}

		computedRoles := lo.Reduce(userRoles, func(rs []string, r string, _ int) []string {
			return append(rs, fmt.Sprintf("%s-%s", app.Code, r))
		}, userRoles)

		effectiveRoles := lo.Intersect(computedRoles, app.Roles)

		ctx.Set(user.CtxRoles, effectiveRoles)
	}
}
