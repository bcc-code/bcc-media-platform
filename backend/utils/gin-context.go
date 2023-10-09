package utils

import (
	"context"
	"sync"

	"github.com/ansel1/merry/v2"
	"github.com/gin-gonic/gin"
)

const contextLockKey = "context-lock"

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
		c.Set(contextLockKey, &sync.Mutex{})
		ctx := context.WithValue(c.Request.Context(), "GinContextKey", c)
		c.Request = c.Request.WithContext(ctx)
		c.Next()
	}
}

func getContextLock(c *gin.Context) (*sync.Mutex, error) {
	v, ok := c.Get(contextLockKey)
	if !ok {
		return nil, merry.Errorf("could not retrieve context lock")
	}
	lock, ok := v.(*sync.Mutex)
	if !ok {
		return nil, merry.Errorf("context lock has wrong type")
	}
	return lock, nil
}

// GetOrSetContextWithLock gets or sets a value in the context with a lock
func GetOrSetContextWithLock[T any](ctx context.Context, key string, factory func() (*T, error)) (*T, error) {
	ginCtx, err := GinCtx(ctx)
	if err != nil {
		return nil, err
	}
	v, ok := ginCtx.Get(key)
	if ok {
		r, ok := v.(*T)
		if !ok {
			return nil, merry.Errorf("could not cast value to type %T", r)
		}
		return r, nil
	}
	cLock, err := getContextLock(ginCtx)
	if err != nil {
		return nil, err
	}

	// this will lock the entire context, but shouldn't be a problem
	cLock.Lock()

	lock, ok := ginCtx.Get("context-lock-" + key)
	if !ok {
		lock = &sync.Mutex{}
		ginCtx.Set("context-lock-"+key, lock)
	}
	cLock.Unlock()
	lock.(*sync.Mutex).Lock()
	defer lock.(*sync.Mutex).Unlock()

	v, ok = ginCtx.Get(key)
	if ok {
		r, ok := v.(*T)
		if !ok {
			return nil, merry.Errorf("could not cast value to type %T", r)
		}
		return r, nil
	}
	r, err := factory()
	if err != nil {
		return nil, err
	}
	ginCtx.Set(key, r)
	return r, nil
}
