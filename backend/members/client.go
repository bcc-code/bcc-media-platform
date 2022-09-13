package members

import "context"

// Config contains configuration options for the client
type Config struct {
	Domain string
}

// Client is the base struct which contains methods for communicating with the members API
type Client struct {
	domain       string
	tokenFactory func(ctx context.Context) string
}

// New returns a new members client
func New(config Config, tokenFactory func(ctx context.Context) string) *Client {
	return &Client{
		domain:       config.Domain,
		tokenFactory: tokenFactory,
	}
}
