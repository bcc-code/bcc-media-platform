package members

import (
	"context"
	"github.com/sony/gobreaker"
)

type tokenProvider interface {
	GetToken(ctx context.Context, audience string) (string, error)
}

// Config contains configuration options for the client
type Config struct {
	Domain string
}

// Client is the base struct which contains methods for communicating with the members API
type Client struct {
	domain        string
	tokenProvider tokenProvider
	breaker       *gobreaker.CircuitBreaker
}

// New returns a new members client
func New(config Config, tokenProvider tokenProvider, breaker *gobreaker.CircuitBreaker) *Client {
	return &Client{
		domain:        config.Domain,
		tokenProvider: tokenProvider,
		breaker:       breaker,
	}
}
