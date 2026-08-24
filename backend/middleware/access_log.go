package middleware

import (
	"time"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/log"
	"github.com/gin-gonic/gin"
)

// AccessLogMiddleware logs a structured line per request, including the
// resolved application code when ApplicationMiddleware has run.
func AccessLogMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		start := time.Now()
		c.Next()

		ev := log.L.Info().
			Str("method", c.Request.Method).
			Str("path", c.Request.URL.Path).
			Int("status", c.Writer.Status()).
			Dur("latency", time.Since(start)).
			Str("clientIP", c.ClientIP())
		if app, err := common.GetApplicationFromCtx(c); err == nil && app != nil && app.Code != "" {
			ev = ev.Str("applicationCode", app.Code)
		}
		if len(c.Errors) > 0 {
			ev = ev.Str("errors", c.Errors.String())
		}
		ev.Msg("request")
	}
}
