package utils

import (
	"context"

	"github.com/ansel1/merry/v2"
	"github.com/gin-gonic/gin"
)

// GinCtx extract the GIN context from a normal context
func GinCtx(ctx context.Context) (*gin.Context, error) {
	ginContext := ctx.Value("GinContextKey")

	if ginContext == nil {
		return nil, merry.Errorf("could not retrieve gin.Context")
	}

	gc, ok := ginContext.(*gin.Context)
	if !ok {
		return nil, merry.Errorf("gin.Context has wrong type")
	}
	return gc, nil
}

// GinContextToContextMiddleware injects the Gin context into the normal context to be later extracted
func GinContextToContextMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		ctx := context.WithValue(c.Request.Context(), "GinContextKey", c)
		c.Request = c.Request.WithContext(ctx)
		c.Next()
	}
}
