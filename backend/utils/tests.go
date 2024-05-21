package utils

import (
	"os"
	"testing"
)

func SkipTestIfCI(t *testing.T) bool {
	if os.Getenv("CI") != "" {
		t.Skip("Skipping testing in CI environment")
		return true
	}
	return false
}
