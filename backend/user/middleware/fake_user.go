package middleware

import (
	"encoding/json"

	"github.com/bcc-code/bcc-media-platform/backend/auth0"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/user"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/gin-gonic/gin"
)

func NewFakeUserMiddleware(secret string) gin.HandlerFunc {
	if secret == "" || len(secret) < 8 {
		log.L.Warn().Msg("Secret is not set or too short (<8 characters). Fake user middleware will not be used.")
		return func(ctx *gin.Context) {}
	}
	return func(ctx *gin.Context) {
		if v, ok := ctx.Get(auth0.CtxAuthenticated); !ok || v.(bool) != true {
			return
		}
		if v, ok := ctx.Get(auth0.CtxPersonID); !ok || v == nil {
			return
		}
		secretHeaderValue := ctx.GetHeader("x-fake-user-secret")
		if secretHeaderValue == "" {
			return
		}

		if secretHeaderValue != secret {
			log.L.Warn().Msg("Secret header does not match the configured secret. Not setting fake user.")
			return
		}

		userStr := ctx.GetHeader("x-user-data")
		if userStr != "" {
			var u common.User
			_ = json.Unmarshal([]byte(userStr), &u)
			ctx.Set(user.CtxUser, &u)
			ctx.Set(user.CtxImpersonating, true)
		}
	}
}
