package middleware

import (
	"fmt"
	cache "github.com/Code-Hex/go-generics-cache"
	"github.com/bcc-code/bcc-media-platform/backend/memorycache"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"strings"
	"time"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/log"
	"github.com/bcc-code/bcc-media-platform/backend/user"
	"github.com/gin-gonic/gin"
	"github.com/samber/lo"
)

// ApplicationMiddleware fills the context with the current application
func ApplicationMiddleware(queries *sqlc.Queries) gin.HandlerFunc {
	return func(ctx *gin.Context) {
		applicationCode := ctx.GetHeader("X-Application")
		applicationCode = mapApplicationCode(applicationCode)

		apps, err := memorycache.GetOrSet(ctx, "applications", queries.ListApplications, cache.WithExpiration(time.Minute*60))
		if err != nil {
			log.L.Error().Err(err).Send()
			ctx.Set(common.CtxApp, nil)
			return
		}

		app, found := lo.Find(apps, func(i common.Application) bool {
			return i.Code == strings.ToLower(strings.TrimSpace(applicationCode))
		})

		if !found {
			app, found = lo.Find(apps, func(i common.Application) bool {
				return i.Default
			})
		}

		ctx.Set(common.CtxApp, &app)
	}
}

// Support app version with old application name kids
func mapApplicationCode(applicationCode string) string {
	if applicationCode == "kids" {
		return "kids-mobile"
	}
	if applicationCode == "connect-tvos" {
		return "live-tvos"
	}
	return applicationCode
}

// RoleMiddleware registers a middleware which reads the application header
func RoleMiddleware(ctx *gin.Context) {
	userRoles := user.GetFromCtx(ctx).Roles

	app, err := common.GetApplicationFromCtx(ctx)
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
