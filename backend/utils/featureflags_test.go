package utils

import (
	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
	"net/http"
	"net/http/httptest"
	"sync"
	"testing"
)

func TestFeatureFlag(t *testing.T) {

	// Switch to test mode so you don't get such noisy output
	gin.SetMode(gin.TestMode)

	r := gin.Default()
	r.GET("/test", func(c *gin.Context) {
		ff := GetFeatureFlags(c)

		assert.True(t, ff.Has("feature1"))
		assert.True(t, ff.Has("feature2"))
		assert.True(t, ff.Has("feature3"))
		assert.False(t, ff.Has("feature4"))

		v, b := ff.GetVariant("feature1")
		assert.True(t, b)
		assert.Equal(t, "variant1", v)

		v, b = ff.GetVariant("feature2")
		assert.True(t, b)
		assert.Equal(t, "variant2", v)

		v, b = ff.GetVariant("feature3")
		assert.True(t, b)
		assert.Equal(t, "", v)
	})

	req, err := http.NewRequest(http.MethodGet, "/test", nil)
	if err != nil {
		t.Fatalf("Couldn't create request: %v\n", err)
	}
	req.Header.Set(featureFlagsHeader, "feature1:variant1,feature2:variant2,feature3")

	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)
}

// TestReportFlagActivationConcurrent reproduces the production crash where
// gqlgen sibling resolvers concurrently called ReportFlagActivation on the
// same gin.Context, racing on the underlying http.Header map and tripping
// `fatal error: concurrent map writes`. The reporter middleware must
// serialize header writes; this test exercises that under -race.
func TestReportFlagActivationConcurrent(t *testing.T) {
	gin.SetMode(gin.TestMode)

	const goroutines = 100

	r := gin.New()
	r.Use(FeatureFlagReporterMiddleware())
	r.GET("/test", func(c *gin.Context) {
		var wg sync.WaitGroup
		wg.Add(goroutines)
		for range goroutines {
			go func() {
				defer wg.Done()
				ReportFlagActivation(c, "cdn-provider", "streamproxy-ioriver")
			}()
		}
		wg.Wait()
	})

	req, err := http.NewRequest(http.MethodGet, "/test", nil)
	assert.NoError(t, err)

	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)

	// 100 racing goroutines reporting the same activation should produce
	// exactly one header value, not 100, and must not crash the process.
	values := w.Header().Values(featureFlagsHeader)
	assert.Equal(t, []string{"cdn-provider:streamproxy-ioriver"}, values)
}

// TestReportFlagActivationDistinct verifies distinct (flag, variant) pairs
// each emit their own header value, while duplicates within a pair dedupe.
func TestReportFlagActivationDistinct(t *testing.T) {
	gin.SetMode(gin.TestMode)

	r := gin.New()
	r.Use(FeatureFlagReporterMiddleware())
	r.GET("/test", func(c *gin.Context) {
		ReportFlagActivation(c, "cdn-provider", "streamproxy-ioriver")
		ReportFlagActivation(c, "cdn-provider", "streamproxy-ioriver") // dup
		ReportFlagActivation(c, "shorts-scores", "enabled")
		ReportFlagActivation(c, "no-variant", "")
		ReportFlagActivation(c, "no-variant", "") // dup
	})

	req, err := http.NewRequest(http.MethodGet, "/test", nil)
	assert.NoError(t, err)

	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)

	values := w.Header().Values(featureFlagsHeader)
	assert.ElementsMatch(t, []string{
		"cdn-provider:streamproxy-ioriver",
		"shorts-scores:enabled",
		"no-variant",
	}, values)
}

// TestReportFlagActivationWithoutMiddleware verifies that calling
// ReportFlagActivation without the middleware is a silent no-op rather than
// racing on the bare header map.
func TestReportFlagActivationWithoutMiddleware(t *testing.T) {
	gin.SetMode(gin.TestMode)

	r := gin.New()
	r.GET("/test", func(c *gin.Context) {
		ReportFlagActivation(c, "cdn-provider", "streamproxy-ioriver")
	})

	req, err := http.NewRequest(http.MethodGet, "/test", nil)
	assert.NoError(t, err)

	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)

	assert.Empty(t, w.Header().Values(featureFlagsHeader))
}
