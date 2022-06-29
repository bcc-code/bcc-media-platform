package main

import (
	"os"
	"strconv"
	"strings"

	"github.com/bcc-code/brunstadtv/backend/auth0"
	"github.com/samber/lo"
)

type postgres struct {
	ConnectionString string
}

type algolia struct {
	AppId            string
	ApiKey           string
	SearchOnlyApiKey string
}

type directusConfig struct {
	Token string
	Host  string
}

type crowdinConfig struct {
	Token      string
	ProjectIDs []int
}

type envConfig struct {
	DB        postgres
	Algolia   algolia
	Port      string
	JWTConfig auth0.JWTConfig
	Directus  directusConfig
	Crowdin   crowdinConfig
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
			AppId:            os.Getenv("ALGOLIA_APP_ID"),
			ApiKey:           os.Getenv("ALGOLIA_API_KEY"),
			SearchOnlyApiKey: os.Getenv("ALGOLIA_SEARCH_ONLY_API_KEY"),
		},
		Directus: directusConfig{
			Token: os.Getenv("DU_TOKEN"),
			Host:  os.Getenv("DU_HOST"),
		},
		Crowdin: crowdinConfig{
			Token: os.Getenv("CROWDIN_TOKEN"),
			ProjectIDs: lo.Map(strings.Split(os.Getenv("CROWDIN_PROJECT_IDS"), ","),
				func(s string, _ int) int {
					r, _ := strconv.ParseInt(s, 10, 64)
					return int(r)
				}),
		},
	}
}
