package utils

import (
	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
	"net/http"
	"net/http/httptest"
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
