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
}

// New creates a new auth client with the given config
func New(config Config) *Client {
	return &Client{
		config,
	}
}
