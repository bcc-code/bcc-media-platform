package middleware

import (
	"net/http/httptest"
	"testing"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/log"
	"github.com/bcc-code/bcc-media-platform/backend/user"
	"github.com/gin-gonic/gin"
	"github.com/rs/zerolog"
	"github.com/stretchr/testify/assert"
)

func TestMain(m *testing.M) {
	log.ConfigureGlobalLogger(zerolog.Disabled)
	m.Run()
}

func roleMiddlewareCtx(t *testing.T, u *common.User, app *common.Application) *gin.Context {
	t.Helper()
	gin.SetMode(gin.TestMode)
	ctx, _ := gin.CreateTestContext(httptest.NewRecorder())
	ctx.Set(user.CtxUser, u)
	if app != nil {
		ctx.Set(common.CtxApp, app)
	}
	return ctx
}

func TestRoleMiddleware(t *testing.T) {
	u := &common.User{Roles: []string{"registered", "bcc-members"}}

	t.Run("prefixes roles with app code and normalized group label", func(t *testing.T) {
		ctx := roleMiddlewareCtx(t, u, &common.Application{
			Code:       "kids-mobile",
			GroupLabel: "Bible Kids",
			Roles: []string{
				"kids-mobile-registered",
				"bible-kids-bcc-members",
				"some-other-role",
			},
		})

		RoleMiddleware(ctx)

		assert.ElementsMatch(t, []string{
			"kids-mobile-registered",
			"bible-kids-bcc-members",
		}, user.GetRolesFromCtx(ctx))
	})

	t.Run("keeps unprefixed roles that the app allows", func(t *testing.T) {
		ctx := roleMiddlewareCtx(t, u, &common.Application{
			Code:       "bccm-mobile",
			GroupLabel: "BCC Media",
			Roles:      []string{"registered", "bcc-media-registered"},
		})

		RoleMiddleware(ctx)

		assert.ElementsMatch(t, []string{
			"registered",
			"bcc-media-registered",
		}, user.GetRolesFromCtx(ctx))
	})

	t.Run("empty group label adds no group roles", func(t *testing.T) {
		ctx := roleMiddlewareCtx(t, u, &common.Application{
			Code:       "bccm-mobile",
			GroupLabel: "  ",
			Roles:      []string{"bccm-mobile-registered", "-registered"},
		})

		RoleMiddleware(ctx)

		assert.ElementsMatch(t, []string{"bccm-mobile-registered"}, user.GetRolesFromCtx(ctx))
	})

	t.Run("falls back to user roles when no app is configured", func(t *testing.T) {
		ctx := roleMiddlewareCtx(t, u, nil)

		RoleMiddleware(ctx)

		assert.ElementsMatch(t, u.Roles, user.GetRolesFromCtx(ctx))
	})
}
