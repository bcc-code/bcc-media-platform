package utils

import (
	"strings"

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

// ReportFlagActivation reports flag activation as a header
func ReportFlagActivation(ctx *gin.Context, flag string, variant string) {
	ctx.Writer.Header().Add(featureFlagsHeader, flag+":"+variant)
}
