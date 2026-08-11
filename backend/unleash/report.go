package unleash

import (
	"strings"

	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"github.com/gin-gonic/gin"
)

const metricsReporterKey = "unleash-metrics-reporter"

// RolePrefix is the prefix under which incoming feature flags are synthesized
// into user roles, so a flag can gate content through the ordinary usergroup
// machinery. See user/middleware.getFeatureFlagRolesFromContext.
const RolePrefix = "feature-flag:"

// FlagRef identifies a flag, and the variant it resolved to if any.
type FlagRef struct {
	Key     string
	Variant string
}

// MetricsMiddleware makes reporter reachable from any handler holding the gin
// context, so decision points deep in the resolvers don't have to thread it
// through. Register it alongside utils.FeatureFlagReporterMiddleware, whose
// per-request state ReportConsidered also depends on.
//
// reporter may be nil (Unleash unconfigured); reporting then no-ops.
func MetricsMiddleware(reporter *MetricsReporter) gin.HandlerFunc {
	return func(c *gin.Context) {
		c.Set(metricsReporterKey, reporter)
		c.Next()
	}
}

func reporterFrom(ctx *gin.Context) *MetricsReporter {
	if ctx == nil {
		return nil
	}
	raw, ok := ctx.Get(metricsReporterKey)
	if !ok {
		return nil
	}
	reporter, _ := raw.(*MetricsReporter)
	return reporter
}

// ReportConsidered records that the backend consulted flag and acted on the
// answer, whether or not the flag was set. enabled is false for the control
// case — a request that reached the decision with the flag absent — which
// Unleash needs in order to show anything other than 100% adoption.
//
// Exposure is counted at most once per request per flag (see utils.MarkCounted),
// so a query that resolves forty streams still counts one.
//
// Set flags are additionally echoed back as an `x-feature-flags` response
// header, which is the existing way to see what the backend used from a bare
// `curl -i`.
//
// Safe to call with a nil context and from parallel resolver goroutines.
func ReportConsidered(ctx *gin.Context, flag string, variant string, enabled bool) {
	if ctx == nil || flag == "" {
		return
	}

	if enabled {
		utils.ReportFlagActivation(ctx, flag, variant)
	}

	if !utils.MarkCounted(ctx, flag) {
		return
	}
	reporterFrom(ctx).Count(flag, variant, enabled)
}

const roleCandidatesKey = "unleash-role-candidate-flags"

// SetRoleCandidates records the flags whose synthesized `feature-flag:` role
// could plausibly change a permission outcome on this request — meaning a
// usergroup with that code actually exists for content to be gated on. Flags
// without one are inert here and must not be recorded.
//
// Nothing is counted yet: whether these flags mattered depends on the request
// going on to run a role-filtered query. See ReportRoleCandidates.
func SetRoleCandidates(ctx *gin.Context, flags []FlagRef) {
	if ctx == nil || len(flags) == 0 {
		return
	}
	ctx.Set(roleCandidatesKey, flags)
}

// ReportRoleCandidates counts the flags recorded by SetRoleCandidates. Call it
// when the request is about to run a query filtered on the user's roles.
//
// This is the one approximation in the flag-usage reporting. The role-filtered
// loaders, the collection filters and the Elasticsearch role filter all filter
// server-side (`roles && '{...}'`), so unlike the Go-side intersections that
// ReportDecisive covers, there is no way to tell whether a specific row came
// back *because* of the flag without running every query twice. A usergroup
// named `feature-flag:X` exists only because an editor deliberately gated
// something on it, so "the flag was in play" is the tightest honest signal
// available here.
func ReportRoleCandidates(ctx *gin.Context) {
	if ctx == nil {
		return
	}
	raw, ok := ctx.Get(roleCandidatesKey)
	if !ok {
		return
	}
	flags, ok := raw.([]FlagRef)
	if !ok {
		return
	}
	for _, f := range flags {
		ReportConsidered(ctx, f.Key, f.Variant, true)
	}
}

// ReportDecisive reports the flags in granted that solely account for a
// permission being granted. granted is the result of intersecting a user's
// roles with an item's roles, so a flag in it changed the outcome only if no
// ordinary role is there to have granted the same thing anyway.
//
// There is no control case to report here: a flag that is off is simply absent
// from the user's roles, so a request never observes "reached this check with
// the flag unset".
func ReportDecisive(ctx *gin.Context, granted []string) {
	if ctx == nil {
		return
	}
	for _, f := range DecisiveFlags(granted) {
		ReportConsidered(ctx, f.Key, f.Variant, true)
	}
}

// DecisiveFlags returns the flags that solely account for granted, the
// intersection of a user's roles with the roles required for something. It
// returns nil when any ordinary role is present, because then the flag-derived
// roles changed nothing — access was already granted without them.
//
// Roles reach this function in several shapes. utils.FeatureFlags.List emits
// both `key` and `key:variant`, so both `feature-flag:key` and
// `feature-flag:key:variant` can appear for one flag. Intersections taken over
// Application.ComputedRoles are additionally prefixed with the app code and the
// normalized group label, e.g. `kids-mobile-feature-flag:key`. All of those
// collapse to one FlagRef per key, preferring the shape that carries a variant.
func DecisiveFlags(granted []string) []FlagRef {
	if len(granted) == 0 {
		return nil
	}

	byKey := map[string]string{}
	var order []string

	for _, role := range granted {
		key, variant, ok := parseFlagRole(role)
		if !ok {
			// An ordinary role granted this too, so no flag was decisive.
			return nil
		}
		if existing, seen := byKey[key]; seen {
			if existing == "" {
				byKey[key] = variant
			}
			continue
		}
		byKey[key] = variant
		order = append(order, key)
	}

	flags := make([]FlagRef, 0, len(order))
	for _, key := range order {
		flags = append(flags, FlagRef{Key: key, Variant: byKey[key]})
	}
	return flags
}

// parseFlagRole splits a flag-derived role into its flag key and variant.
// Accepts both the bare `feature-flag:key[:variant]` form and the
// app/group-prefixed `some-prefix-feature-flag:key[:variant]` form produced by
// Application.ComputedRoles. ok is false for any role that isn't flag-derived.
func parseFlagRole(role string) (key string, variant string, ok bool) {
	idx := strings.Index(role, RolePrefix)
	if idx < 0 {
		return "", "", false
	}
	// The prefix is either absent or an app/group label ending in a dash;
	// anything else is a role that merely happens to contain the substring.
	if idx > 0 && role[idx-1] != '-' {
		return "", "", false
	}

	rest := role[idx+len(RolePrefix):]
	if rest == "" {
		return "", "", false
	}

	key, variant, found := strings.Cut(rest, ":")
	if !found {
		return rest, "", true
	}
	if key == "" {
		return "", "", false
	}
	return key, variant, true
}
