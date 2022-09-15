package main

import (
	"github.com/bcc-code/brunstadtv/backend/members"
	"github.com/bcc-code/brunstadtv/backend/search"
	"os"
	"strings"

	"github.com/bcc-code/brunstadtv/backend/auth0"
	"github.com/samber/lo"
)

type postgres struct {
	ConnectionString string
}

type envConfig struct {
	Members   members.Config
	DB        postgres
	Algolia   search.Config
	Port      string
	Auth0     auth0.Config
	CDNConfig cdnConfig
	Secrets   serviceSecrets
}

type cdnConfig struct {
	Vod2Domain          string
	FilesDomain         string
	AWSSigningKeyPath   string
	AWSSigningKeyID     string
	AzureSigningKeyPath string
}

type serviceSecrets struct {
	Directus string
}

// GetVOD2Domain returns the configured VOD2Domain
func (c cdnConfig) GetVOD2Domain() string {
	return c.Vod2Domain
}

// GetFilesCDNDomain returns the configured FilesCDNDomain
func (c cdnConfig) GetFilesCDNDomain() string {
	return c.FilesDomain
}

func (c cdnConfig) GetAwsSigningKeyPath() string {
	return c.AWSSigningKeyPath
}

func (c cdnConfig) GetAwsSigningKeyID() string {
	return c.AWSSigningKeyID
}

func (c cdnConfig) GetAzureSigningKeyPath() string {
	return c.AzureSigningKeyPath
}

func getEnvConfig() envConfig {
	aud := lo.Map(strings.Split(os.Getenv("AUTH0_AUDIENCES"), ","),
		func(s string, _ int) string {
			return strings.TrimSpace(s)
		},
	)

	return envConfig{
		Members: members.Config{
			Domain: os.Getenv("MEMBERS_API_DOMAIN"),
		},
		DB: postgres{
			ConnectionString: os.Getenv("DB_CONNECTION_STRING"),
		},
		Auth0: auth0.Config{
			ClientID:     os.Getenv("AUTH0_CLIENT_ID"),
			ClientSecret: os.Getenv("AUTH0_CLIENT_SECRET"),
			Domain:       os.Getenv("AUTH0_DOMAIN"),
			Audiences:    aud,
		},
		Port: os.Getenv("PORT"),
		Algolia: search.Config{
			AppID:  os.Getenv("ALGOLIA_APP_ID"),
			APIKey: os.Getenv("ALGOLIA_API_KEY"),
		},
		CDNConfig: cdnConfig{
			Vod2Domain:          os.Getenv("VOD2_CDN_DOMAIN"),
			FilesDomain:         os.Getenv("FILES_CDN_DOMAIN"),
			AWSSigningKeyID:     os.Getenv("CF_SIGNING_KEY_ID"),
			AWSSigningKeyPath:   os.Getenv("CF_SIGNING_KEY_PATH"),
			AzureSigningKeyPath: os.Getenv("AZ_SIGNING_KEY_PATH"),
		},
		Secrets: serviceSecrets{
			Directus: os.Getenv("SERVICE_SECRET_DIRECTUS"),
		},
	}
}
