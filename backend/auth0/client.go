package auth0

// Config is the configuration for the client
type Config struct {
	ClientID           string
	ClientSecret       string
	Domain             string
	ManagementAudience string
	Audiences          []string
}

// Client is the auth client
type Client struct {
	config Config
	// secondaryValidator, when set, is tried for a bearer token that fails the
	// Auth0 validators. If it returns true the request is treated as
	// authenticated instead of being rejected. Used to accept Directus-issued
	// admin tokens without teaching this package about Directus.
	secondaryValidator func(token string) bool
}

// New creates a new auth client with the given config
func New(config Config) *Client {
	return &Client{
		config: config,
	}
}

// SetSecondaryValidator registers a fallback token validator that is consulted
// when the Auth0 validators reject a bearer token.
func (c *Client) SetSecondaryValidator(f func(token string) bool) {
	c.secondaryValidator = f
}
