package asset

import (
	"testing"

	"github.com/stretchr/testify/assert"
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
		res := SafeString(in)
		assert.Equal(t, res, out)
	}
}

func TestCalculateDuration(t *testing.T) {
	testData := map[string]int64{
		"lakjdwlkd":   0,
		"00:00:00:00": 0,
		"00:01:00:23": 60,
		"02:00:00:23": 2 * 60 * 60,
		"02:04:99:23": 2*60*60 + 4*60 + 99,
		"2:4:9:3":     2*60*60 + 4*60 + 9,
	}

	for in, out := range testData {
		a := assetIngestJSONMeta{
			Duration: in,
		}

		a.CalculateDuration()
		assert.Equal(t, out, a.DurationInS, in)
	}
}
