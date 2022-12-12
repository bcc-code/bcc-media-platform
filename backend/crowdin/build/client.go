package build

import (
	"github.com/go-resty/resty/v2"
)

// Config for the client
type Config struct {
	Token      string
	ProjectIDs []int
}

// Client for crowdin interactions
type Client struct {
	c      *resty.Client
	config Config
}

// New client for requests
func New(config Config) *Client {
	c := resty.New().
		SetBaseURL("https://api.crowdin.com/api/v2/").
		SetAuthToken(config.Token)
	return &Client{
		c:      c,
		config: config,
	}
}
