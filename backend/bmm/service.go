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
}

// New generates a new BMM
func New(option Config) (*bmm.APIClient, error) {
	if option.BaseURL == "" {
		return nil, merry.New("BaseURL is required")
	}

	if option.Auth0BaseURL == "" {
		return nil, merry.New("Auth0BaseURL is required")
	}

	if option.ClientID == "" {
		return nil, merry.New("ClientID is required")
	}

	if option.ClientSecret == "" {
		return nil, merry.New("ClientSecret is required")
	}

	token, err := bmm.NewToken(option.Auth0BaseURL, option.ClientID, option.ClientSecret, option.Audience)
	if err != nil {
		return nil, err
	}

	return bmm.NewApiClient(option.BaseURL, token), nil
}
