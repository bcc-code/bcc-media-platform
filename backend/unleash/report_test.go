package unleash

import (
	"net/http"
	"net/http/httptest"
	"sync"
	"testing"

	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"

	"github.com/bcc-code/bcc-media-platform/backend/utils"
)

func TestDecisiveFlags(t *testing.T) {
	tests := []struct {
		name    string
		granted []string
		want    []FlagRef
	}{
		{
			name:    "empty intersection grants nothing",
			granted: nil,
		},
		{
			name:    "an ordinary role granted it, so no flag was decisive",
			granted: []string{"bcc-members", "feature-flag:early-birds"},
		},
		{
			name:    "several ordinary roles",
			granted: []string{"bcc-members", "public"},
		},
		{
			name:    "flag alone",
			granted: []string{"feature-flag:early-birds"},
			want:    []FlagRef{{Key: "early-birds"}},
		},
		{
			name:    "flag with variant",
			granted: []string{"feature-flag:early-birds:on"},
			want:    []FlagRef{{Key: "early-birds", Variant: "on"}},
		},
		{
			// FeatureFlags.List emits both shapes, so both land in the roles.
			name:    "bare and variant shapes of one flag collapse, variant wins",
			granted: []string{"feature-flag:early-birds", "feature-flag:early-birds:on"},
			want:    []FlagRef{{Key: "early-birds", Variant: "on"}},
		},
		{
			name:    "variant shape seen first still collapses",
			granted: []string{"feature-flag:early-birds:on", "feature-flag:early-birds"},
			want:    []FlagRef{{Key: "early-birds", Variant: "on"}},
		},
		{
			// Application.ComputedRoles prefixes with the app code and the
			// normalized group label.
			name:    "app-prefixed role",
			granted: []string{"kids-mobile-feature-flag:early-birds"},
			want:    []FlagRef{{Key: "early-birds"}},
		},
		{
			name: "prefixed and bare shapes of one flag collapse",
			granted: []string{
				"feature-flag:early-birds",
				"kids-mobile-feature-flag:early-birds",
				"bible-kids-feature-flag:early-birds:on",
			},
			want: []FlagRef{{Key: "early-birds", Variant: "on"}},
		},
		{
			name:    "two distinct flags",
			granted: []string{"feature-flag:a", "feature-flag:b:v"},
			want:    []FlagRef{{Key: "a"}, {Key: "b", Variant: "v"}},
		},
		{
			// A role that merely contains the substring is not flag-derived:
			// the prefix has to be empty or end in a dash.
			name:    "lookalike role is treated as ordinary",
			granted: []string{"myfeature-flag:x"},
		},
		{
			name:    "prefix with no flag name is not flag-derived",
			granted: []string{"feature-flag:"},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			assert.Equal(t, tt.want, DecisiveFlags(tt.granted))
		})
	}
}

// newReportTestServer wires the two middlewares ReportConsidered depends on and
// returns the engine plus the reporter its counts land in.
func newReportTestServer(t *testing.T) (*gin.Engine, *MetricsReporter) {
	t.Helper()
	gin.SetMode(gin.TestMode)

	reporter := NewMetricsReporter(MetricsConfig{URL: "http://example.invalid", Token: "t"})
	require.NotNil(t, reporter)

	r := gin.New()
	r.Use(utils.FeatureFlagReporterMiddleware())
	r.Use(MetricsMiddleware(reporter))
	return r, reporter
}

func serve(t *testing.T, r *gin.Engine) *httptest.ResponseRecorder {
	t.Helper()
	req, err := http.NewRequest(http.MethodGet, "/test", nil)
	require.NoError(t, err)
	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)
	return w
}

// TestReportConsideredCountsOncePerRequest is the property that keeps backend
// counts comparable to the clients': a query resolving many streams consults
// the same flag many times and must still report one exposure.
func TestReportConsideredCountsOncePerRequest(t *testing.T) {
	r, reporter := newReportTestServer(t)
	r.GET("/test", func(c *gin.Context) {
		for range 40 {
			ReportConsidered(c, "cdn-provider", "ioriver", true)
		}
	})

	w := serve(t, r)

	b := reporter.swap()
	require.NotNil(t, b)
	assert.Equal(t, 1, b.Toggles["cdn-provider"].Yes)
	assert.Equal(t, map[string]int{"ioriver": 1}, b.Toggles["cdn-provider"].Variants)

	// Set flags are still echoed back for debugging.
	assert.Equal(t, []string{"cdn-provider:ioriver"}, w.Header().Values("x-feature-flags"))
}

// TestReportConsideredControlCase covers the flag-was-off observation, without
// which Unleash cannot show anything but 100% adoption.
func TestReportConsideredControlCase(t *testing.T) {
	r, reporter := newReportTestServer(t)
	r.GET("/test", func(c *gin.Context) {
		ReportConsidered(c, "cdn-provider", "", false)
	})

	w := serve(t, r)

	b := reporter.swap()
	require.NotNil(t, b)
	assert.Equal(t, 0, b.Toggles["cdn-provider"].Yes)
	assert.Equal(t, 1, b.Toggles["cdn-provider"].No)

	// Nothing was activated, so nothing is echoed back.
	assert.Empty(t, w.Header().Values("x-feature-flags"))
}

// TestReportConsideredOnAndOffCannotBothCount guards the dedup key choice: it is
// the flag name alone, so one request cannot contribute to both sides.
func TestReportConsideredOnAndOffCannotBothCount(t *testing.T) {
	r, reporter := newReportTestServer(t)
	r.GET("/test", func(c *gin.Context) {
		ReportConsidered(c, "cdn-provider", "ioriver", true)
		ReportConsidered(c, "cdn-provider", "", false)
	})

	serve(t, r)

	b := reporter.swap()
	require.NotNil(t, b)
	assert.Equal(t, 1, b.Toggles["cdn-provider"].Yes)
	assert.Equal(t, 0, b.Toggles["cdn-provider"].No)
}

func TestReportConsideredDistinctFlags(t *testing.T) {
	r, reporter := newReportTestServer(t)
	r.GET("/test", func(c *gin.Context) {
		ReportConsidered(c, "cdn-provider", "ioriver", true)
		ReportConsidered(c, "live-cdn-provider", "cloudfront", true)
		ReportConsidered(c, "shorts-with-scores3", "", false)
	})

	serve(t, r)

	b := reporter.swap()
	require.NotNil(t, b)
	assert.Len(t, b.Toggles, 3)
	assert.Equal(t, 1, b.Toggles["cdn-provider"].Yes)
	assert.Equal(t, 1, b.Toggles["live-cdn-provider"].Yes)
	assert.Equal(t, 1, b.Toggles["shorts-with-scores3"].No)
}

// TestReportConsideredSeparateRequests verifies dedup is per request, not global.
func TestReportConsideredSeparateRequests(t *testing.T) {
	r, reporter := newReportTestServer(t)
	r.GET("/test", func(c *gin.Context) {
		ReportConsidered(c, "cdn-provider", "ioriver", true)
	})

	serve(t, r)
	serve(t, r)
	serve(t, r)

	b := reporter.swap()
	require.NotNil(t, b)
	assert.Equal(t, 3, b.Toggles["cdn-provider"].Yes)
}

// TestReportConsideredConcurrent exercises the dedup under -race, since gqlgen
// resolves sibling fields on parallel goroutines sharing one gin.Context.
func TestReportConsideredConcurrent(t *testing.T) {
	r, reporter := newReportTestServer(t)
	r.GET("/test", func(c *gin.Context) {
		var wg sync.WaitGroup
		wg.Add(100)
		for range 100 {
			go func() {
				defer wg.Done()
				ReportConsidered(c, "cdn-provider", "ioriver", true)
			}()
		}
		wg.Wait()
	})

	serve(t, r)

	b := reporter.swap()
	require.NotNil(t, b)
	assert.Equal(t, 1, b.Toggles["cdn-provider"].Yes)
}

// TestReportConsideredWithoutMiddleware verifies the degraded path is a no-op
// rather than counting without the per-request dedup state.
func TestReportConsideredWithoutMiddleware(t *testing.T) {
	gin.SetMode(gin.TestMode)
	reporter := NewMetricsReporter(MetricsConfig{URL: "http://example.invalid", Token: "t"})
	require.NotNil(t, reporter)

	r := gin.New()
	r.Use(MetricsMiddleware(reporter)) // no FeatureFlagReporterMiddleware
	r.GET("/test", func(c *gin.Context) {
		ReportConsidered(c, "cdn-provider", "ioriver", true)
	})

	serve(t, r)

	assert.Nil(t, reporter.swap())
}

// TestReportConsideredWithoutReporter covers Unleash being unconfigured: the
// request path must not care.
func TestReportConsideredWithoutReporter(t *testing.T) {
	gin.SetMode(gin.TestMode)

	r := gin.New()
	r.Use(utils.FeatureFlagReporterMiddleware())
	r.Use(MetricsMiddleware(nil))
	r.GET("/test", func(c *gin.Context) {
		assert.NotPanics(t, func() {
			ReportConsidered(c, "cdn-provider", "ioriver", true)
			ReportDecisive(c, []string{"feature-flag:x"})
			ReportRoleCandidates(c)
		})
	})

	w := serve(t, r)
	// The response header still works without a reporter. "x" comes from the
	// ReportDecisive call, which found that flag to be the sole grant.
	assert.ElementsMatch(t, []string{"cdn-provider:ioriver", "x"}, w.Header().Values("x-feature-flags"))
}

func TestReportConsideredNilContext(t *testing.T) {
	assert.NotPanics(t, func() {
		ReportConsidered(nil, "cdn-provider", "ioriver", true)
		ReportDecisive(nil, []string{"feature-flag:x"})
		ReportRoleCandidates(nil)
		SetRoleCandidates(nil, []FlagRef{{Key: "x"}})
	})
}

func TestReportDecisiveOnlyCountsSoleGrants(t *testing.T) {
	r, reporter := newReportTestServer(t)
	r.GET("/test", func(c *gin.Context) {
		// An ordinary role also granted this, so the flag changed nothing.
		ReportDecisive(c, []string{"bcc-members", "feature-flag:not-decisive"})
		ReportDecisive(c, []string{"feature-flag:decisive:on"})
	})

	serve(t, r)

	b := reporter.swap()
	require.NotNil(t, b)
	assert.Len(t, b.Toggles, 1)
	assert.Equal(t, 1, b.Toggles["decisive"].Yes)
	assert.Equal(t, map[string]int{"on": 1}, b.Toggles["decisive"].Variants)
}

// TestRoleCandidatesReportedOnUse verifies the usergroup-gated flags are counted
// only once the request actually reaches a role-filtered query.
func TestRoleCandidatesReportedOnUse(t *testing.T) {
	r, reporter := newReportTestServer(t)
	r.GET("/test", func(c *gin.Context) {
		SetRoleCandidates(c, []FlagRef{{Key: "gated", Variant: "on"}})
		if c.Query("filtered") == "1" {
			ReportRoleCandidates(c)
		}
	})

	// A request that never runs a role-filtered query reports nothing.
	req, err := http.NewRequest(http.MethodGet, "/test", nil)
	require.NoError(t, err)
	r.ServeHTTP(httptest.NewRecorder(), req)
	assert.Nil(t, reporter.swap(), "candidates alone must not count")

	req, err = http.NewRequest(http.MethodGet, "/test?filtered=1", nil)
	require.NoError(t, err)
	r.ServeHTTP(httptest.NewRecorder(), req)

	b := reporter.swap()
	require.NotNil(t, b)
	assert.Equal(t, 1, b.Toggles["gated"].Yes)
	assert.Equal(t, map[string]int{"on": 1}, b.Toggles["gated"].Variants)
}
