package utils

import (
	"context"
	"strings"
)

// FeatureFlag is a feature flag
type FeatureFlag struct {
	Key   string
	Value string
}

// FeatureFlags is a list of feature flags
type FeatureFlags []FeatureFlag

// Get returns a flag for unleash
func (f FeatureFlags) Get(key string) (string, bool) {
	for _, flag := range f {
		if flag.Key == key {
			return flag.Value, true
		}
	}
	return "", false
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
			ff.Value = featureFlag[1]
		}
		featureFlags = append(featureFlags, ff)
	}

	ginCtx.Set(featureFlagsKey, featureFlags)

	return featureFlags
}
