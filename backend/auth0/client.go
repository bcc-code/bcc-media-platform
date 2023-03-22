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

// GetClientID returns the clientID for this application
func (c *Client) GetClientID() string {
	return c.config.ClientID
}

// New returns a new Auth client
func New(config Config) *Client {
	return &Client{
		config,
	}
}
