package utils

import (
	"context"
	"errors"
	"net/http/httptest"
	"sync"
	"sync/atomic"
	"testing"

	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

type loaderSet struct{ id int }

// requestContext builds the context a handler sees: a gin context carrying the
// per-request lock, wrapped the way GinContextToContextMiddleware wraps it.
func requestContext(t *testing.T) context.Context {
	t.Helper()
	gin.SetMode(gin.TestMode)

	ginCtx, _ := gin.CreateTestContext(httptest.NewRecorder())
	ginCtx.Request = httptest.NewRequest("GET", "/", nil)
	ginCtx.Set(contextLockKey, &sync.Mutex{})

	return context.WithValue(ginCtx.Request.Context(), "GinContextKey", ginCtx) //nolint:staticcheck // mirrors the middleware
}

// gqlgen resolves fields concurrently, so several goroutines can ask for the
// same request-scoped value at once. Building it more than once would defeat the
// per-request batching the loaders exist to provide.
func TestGetOrSetContextWithLockBuildsOnlyOnce(t *testing.T) {
	ctx := requestContext(t)

	var built atomic.Int32
	var wg sync.WaitGroup
	results := make([]*loaderSet, 20)

	for i := range results {
		wg.Add(1)
		go func() {
			defer wg.Done()
			got, err := GetOrSetContextWithLock(ctx, "loaders", func() (*loaderSet, error) {
				return &loaderSet{id: int(built.Add(1))}, nil
			})
			require.NoError(t, err)
			results[i] = got
		}()
	}
	wg.Wait()

	assert.Equal(t, int32(1), built.Load(), "factory ran more than once for the same key")
	for i, r := range results {
		assert.Same(t, results[0], r, "goroutine %d got a different instance", i)
	}
}

func TestGetOrSetContextWithLockKeepsKeysSeparate(t *testing.T) {
	ctx := requestContext(t)

	a, err := GetOrSetContextWithLock(ctx, "a", func() (*loaderSet, error) { return &loaderSet{id: 1}, nil })
	require.NoError(t, err)
	b, err := GetOrSetContextWithLock(ctx, "b", func() (*loaderSet, error) { return &loaderSet{id: 2}, nil })
	require.NoError(t, err)

	assert.NotSame(t, a, b)
	assert.Equal(t, 1, a.id)
	assert.Equal(t, 2, b.id)
}

func TestGetOrSetContextWithLockPropagatesFactoryErrors(t *testing.T) {
	ctx := requestContext(t)
	want := errors.New("cannot build")

	_, err := GetOrSetContextWithLock(ctx, "failing", func() (*loaderSet, error) { return nil, want })
	assert.ErrorIs(t, err, want)

	// A failed build must not be cached as a result.
	got, err := GetOrSetContextWithLock(ctx, "failing", func() (*loaderSet, error) { return &loaderSet{id: 9}, nil })
	require.NoError(t, err)
	assert.Equal(t, 9, got.id)
}

func TestGetOrSetContextWithLockWithoutAGinContext(t *testing.T) {
	_, err := GetOrSetContextWithLock(context.Background(), "k", func() (*loaderSet, error) {
		t.Fatal("factory should not run without a gin context")
		return nil, nil
	})
	assert.Error(t, err)
}
