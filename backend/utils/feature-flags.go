package utils

import (
	"strings"
	"sync"

	"github.com/gin-gonic/gin"
)

// FeatureFlag is a feature flag
type FeatureFlag struct {
	Key     string
	Variant string
}

// FeatureFlags is a list of feature flags
type FeatureFlags []FeatureFlag

// GetVariant returns a flag for unleash
func (f FeatureFlags) GetVariant(key string) (string, bool) {
	for _, flag := range f {
		if flag.Key == key {
			return flag.Variant, true
		}
	}
	return "", false
}

// Has returns true if a flag is present
func (f FeatureFlags) Has(key string) bool {
	_, ok := f.GetVariant(key)
	return ok
}

// List returns a list of flags
func (f FeatureFlags) List() []string {
	var flags []string
	for _, flag := range f {
		r := flag.Key
		flags = append(flags, r)
		if flag.Variant != "" {
			r += ":" + flag.Variant
			flags = append(flags, r)
		}
	}
	return flags
}

const featureFlagsKey = "feature-flags"

const featureFlagsHeader = "x-feature-flags"

// GetFeatureFlags returns flags for unleash
func GetFeatureFlags(ctx *gin.Context) FeatureFlags {
	if ctx == nil {
		return nil
	}
	flags, ok := ctx.Get(featureFlagsKey)
	if ok {
		return flags.(FeatureFlags)
	}

	var featureFlags FeatureFlags
	featureFlagsString := ctx.GetHeader(featureFlagsHeader)
	for _, flag := range strings.Split(featureFlagsString, ",") {
		if flag == "" {
			continue
		}
		featureFlag := strings.Split(flag, ":")
		ff := FeatureFlag{
			Key: featureFlag[0],
		}
		if len(featureFlag) > 1 {
			ff.Variant = featureFlag[1]
		}
		featureFlags = append(featureFlags, ff)
	}

	ctx.Set(featureFlagsKey, featureFlags)

	return featureFlags
}

const reportedFlagsKey = "reported-feature-flags"

// reportedFlags is per-request state for feature-flag activation reporting.
// The mutex guards the dedup sets and the underlying http.Header.Add,
// because gqlgen runs sibling field resolvers on parallel goroutines and
// http.Header is a plain map.
//
// There are two dedup sets because the two consumers need different keys:
//   - added is keyed on `flag[:variant]`, so distinct variants each get their
//     own response header value (see ReportFlagActivation).
//   - counted is keyed on the flag name alone, so upstream metrics count one
//     exposure per request per flag (see MarkCounted).
type reportedFlags struct {
	mu      sync.Mutex
	added   map[string]struct{}
	counted map[string]struct{}
}

// EnsureReportedFlags installs per-request state for ReportFlagActivation.
// Must be called from a middleware on routes that can fan out into parallel
// resolver goroutines, before any handler runs. The lazy init relies on the
// caller being single-goroutine, since gin.Context.Set is not safe against
// concurrent first-time inserts of the same key.
func EnsureReportedFlags(ctx *gin.Context) {
	if _, ok := ctx.Get(reportedFlagsKey); ok {
		return
	}
	ctx.Set(reportedFlagsKey, &reportedFlags{
		added:   map[string]struct{}{},
		counted: map[string]struct{}{},
	})
}

// FeatureFlagReporterMiddleware initializes per-request state for
// ReportFlagActivation. Must run before any handler that fans out into
// parallel resolver goroutines (e.g. gqlgen).
func FeatureFlagReporterMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		EnsureReportedFlags(c)
		c.Next()
	}
}

// ReportFlagActivation reports flag activation as a response header. Safe
// to call concurrently from sibling resolver goroutines; each (flag, variant)
// is written to the response header at most once per request.
//
// Requires EnsureReportedFlags to have been called from middleware. Without
// it the call is a silent no-op rather than racing on the bare header map.
func ReportFlagActivation(ctx *gin.Context, flag string, variant string) {
	if ctx == nil {
		return
	}
	val := flag
	if variant != "" {
		val = flag + ":" + variant
	}
	raw, ok := ctx.Get(reportedFlagsKey)
	if !ok {
		return
	}
	rf := raw.(*reportedFlags)
	rf.mu.Lock()
	defer rf.mu.Unlock()
	if _, already := rf.added[val]; already {
		return
	}
	rf.added[val] = struct{}{}
	ctx.Writer.Header().Add(featureFlagsHeader, val)
}

// MarkCounted claims the once-per-request right to count an exposure for flag,
// returning true only for the first caller. Later callers get false, so a
// request that consults the same flag many times (a query resolving 40 episode
// streams hits the stream-signer decision 40 times) contributes a single
// exposure rather than 40.
//
// The key is the flag name alone, deliberately excluding the variant: the on
// and off outcomes of one flag must not both be counted within a request.
//
// Safe to call concurrently from sibling resolver goroutines. Requires
// EnsureReportedFlags to have been called from middleware; without it this
// returns false, so callers report nothing rather than counting unbounded.
func MarkCounted(ctx *gin.Context, flag string) bool {
	if ctx == nil {
		return false
	}
	raw, ok := ctx.Get(reportedFlagsKey)
	if !ok {
		return false
	}
	rf := raw.(*reportedFlags)
	rf.mu.Lock()
	defer rf.mu.Unlock()
	if _, already := rf.counted[flag]; already {
		return false
	}
	rf.counted[flag] = struct{}{}
	return true
}
