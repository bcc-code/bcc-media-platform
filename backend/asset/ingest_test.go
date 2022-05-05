package asset_test

import (
	"testing"

	"github.com/bcc-code/brunstadtv/backend/asset"
	"github.com/go-playground/assert/v2"
)

func TestSafeString(t *testing.T) {
	pairs := map[string]string{
		"":             "",
		"918237981273": "918237981273",
		":":            "_",
		"		InTrO S01:E033": "INTRO_S01_E033",
		"INTRO_S01_E033":  "INTRO_S01_E033",
		"INTR😄O_S01_E033": "INTRO_S01_E033",
		"😄😄😄😄😄":           "",
	}

	for in, out := range pairs {
		res := asset.SafeString(in)
		assert.Equal(t, res, out)
	}
}
