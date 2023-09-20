package applications

import (
	"context"
	"fmt"
	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/user"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/gin-gonic/gin"
	"github.com/samber/lo"
)

// CtxApp is the context key containing application
const (
	CtxApp = "app"
)

// ApplicationMiddleware fills the context with the current application
func ApplicationMiddleware(
	applicationParser func(ctx context.Context, code string) *common.Application,
) gin.HandlerFunc {
	return func(ctx *gin.Context) {
		applicationCode := ctx.GetHeader("X-Application")

		app := applicationParser(ctx, applicationCode)
		if app == nil {
			// Means that this is not implemented. Just ignore
			return
		}

		ctx.Set(CtxApp, app)
	}
}

// GetFromCtx returns the stored application object from context
func GetFromCtx(ctx *gin.Context) (*common.Application, error) {
	entry, ok := ctx.Get(CtxApp)
	if !ok {
		return nil, merry.New("Application is not in context")
	}
	app, ok := entry.(*common.Application)
	if !ok {
		return nil, merry.New("Application was incorrectly set in context")
	}
	return app, nil
}

// RoleMiddleware registers a middleware which reads the application header
func RoleMiddleware() gin.HandlerFunc {
	return func(ctx *gin.Context) {
		userRoles := user.GetFromCtx(ctx).Roles

		app, err := GetFromCtx(ctx)
		if err != nil {
			log.L.Warn().Err(err).Msg("Apps not configured or no default app is set")
			// Means that this is not implemented or configured. Just ignore
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
