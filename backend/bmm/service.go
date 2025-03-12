package bmm

import (
	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/bmm-sdk-golang"
)

// Config is a configuration options for the BMM service
//
// You can use the BaseURL to point to a different BMM API, such as integration
// Auth is the same on prod and INT
type Config struct {
	Auth0BaseURL string
	ClientID     string
	ClientSecret string
	Audience     string

	// Prod: https://bmm-api.brunstad.org
	// Integration: https://int-bmm-api.brunstad.org
	BaseURL string

	Debug bool
}

// New generates a new BMM
func New(config Config) (*bmm.APIClient, error) {
	if config.BaseURL == "" {
		return nil, merry.New("BaseURL is required")
	}

	if config.Auth0BaseURL == "" {
		return nil, merry.New("Auth0BaseURL is required")
	}

	if config.ClientID == "" {
		return nil, merry.New("ClientID is required")
	}

	if config.ClientSecret == "" {
		return nil, merry.New("ClientSecret is required")
	}

	token, err := bmm.NewToken(config.Auth0BaseURL, config.ClientID, config.ClientSecret, config.Audience)
	if err != nil {
		return nil, err
	}

	client := bmm.NewApiClient(config.BaseURL, token)

	client.SetDebug(config.Debug)
	return client, nil
}
