package crowdin2

import (
	"github.com/bcc-code/brunstadtv/backend/directus"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
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
	du     *directus.Handler
	config Config
	q      *sqlc.Queries
}

// New client for requests
func New(config Config, directusHandler *directus.Handler, queries *sqlc.Queries) *Client {
	c := resty.New().
		SetBaseURL("https://api.crowdin.com/api/v2/").
		SetAuthToken(config.Token)
	return &Client{
		du:     directusHandler,
		c:      c,
		config: config,
		q:      queries,
	}
}
