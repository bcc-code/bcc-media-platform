package utils

import (
	"context"
	"strings"
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

const featureFlagsKey = "feature-flags"

// GetFeatureFlags returns flags for unleash
func GetFeatureFlags(ctx context.Context) FeatureFlags {
	ginCtx, err := GinCtx(ctx)
	if err != nil {
		return nil
	}
	flags, ok := ginCtx.Get(featureFlagsKey)
	if ok {
		return flags.(FeatureFlags)
	}

	var featureFlags FeatureFlags
	featureFlagsString := ginCtx.GetHeader("x-feature-flags")
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

	ginCtx.Set(featureFlagsKey, featureFlags)

	return featureFlags
}
