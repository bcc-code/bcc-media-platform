package main

import (
	"os"
	"strings"

	"github.com/bcc-code/brunstadtv/backend/auth0"
	"github.com/samber/lo"
)

type postgres struct {
	ConnectionString string
}

type algolia struct {
	AppId  string
	ApiKey string
}

type envConfig struct {
	DB        postgres
	Algolia   algolia
	Port      string
	JWTConfig auth0.JWTConfig
	CDNConfig cdnConfig
	Secrets   serviceSecrets
}

type cdnConfig struct {
	Vod2Domain        string
	FilesDomain       string
	AWSSigningKeyPath string
	AWSSigningKeyID   string
}

type serviceSecrets struct {
	Directus string
}

func (c cdnConfig) GetVOD2Domain() string {
	return c.Vod2Domain
}

func (c cdnConfig) GetFilesCDNDomain() string {
	return c.FilesDomain
}

func getEnvConfig() envConfig {
	aud := lo.Map(strings.Split(os.Getenv("JWT_AUDIENCES"), ","),
		func(s string, _ int) string {
			return strings.TrimSpace(s)
		},
	)

	return envConfig{
		DB: postgres{
			ConnectionString: os.Getenv("DB_CONNECTION_STRING"),
		},
		JWTConfig: auth0.JWTConfig{
			Domain:    os.Getenv("JWT_DOMAIN"),
			Issuer:    os.Getenv("JWT_ISSUER"),
			Audiences: aud,
		},
		Port: os.Getenv("PORT"),
		Algolia: algolia{
			AppId:  os.Getenv("ALGOLIA_APP_ID"),
			ApiKey: os.Getenv("ALGOLIA_API_KEY"),
		},
		CDNConfig: cdnConfig{
			Vod2Domain:        os.Getenv("VOD2_CDN_DOMAIN"),
			FilesDomain:       os.Getenv("FILES_CDN_DOMAIN"),
			AWSSigningKeyID:   os.Getenv("CF_SIGNING_KEY_ID"),
			AWSSigningKeyPath: os.Getenv("CF_SIGNING_KEY_PATH"),
		},
		Secrets: serviceSecrets{
			Directus: os.Getenv("SERVICE_SECRET_DIRECTUS"),
		},
	}
}
