package liveapp

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestURLs(t *testing.T) {
	for _, base := range []string{"https://live.bcc-connect.org", "https://live.bcc-connect.org/"} {
		c := Config{BaseURL: base}
		assert.Equal(t, "https://live.bcc-connect.org/", c.RootURL())
		assert.Equal(t, "https://live.bcc-connect.org/replay/", c.ReplayURLPrefix())
	}
}

func TestConfigFromEnv(t *testing.T) {
	t.Setenv("LIVE_APP_BASE_URL", "")
	assert.Equal(t, defaultBaseURL, ConfigFromEnv().BaseURL)
	t.Setenv("LIVE_APP_BASE_URL", "http://localhost:3000")
	assert.Equal(t, "http://localhost:3000", ConfigFromEnv().BaseURL)
}
