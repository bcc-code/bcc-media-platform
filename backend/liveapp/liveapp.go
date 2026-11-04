package liveapp

import (
	"os"
	"strconv"
	"strings"
)

const defaultBaseURL = "https://live.bcc-connect.org"

type Config struct {
	BaseURL string
}

func ConfigFromEnv() Config {
	if u := os.Getenv("LIVE_APP_BASE_URL"); u != "" {
		return Config{BaseURL: u}
	}
	return Config{BaseURL: defaultBaseURL}
}

func (c Config) base() string {
	return strings.TrimRight(c.BaseURL, "/")
}

func (c Config) RootURL() string {
	return c.base() + "/"
}

func (c Config) ReplayURL(entryID int) string {
	return c.base() + "/replay/" + strconv.Itoa(entryID)
}
