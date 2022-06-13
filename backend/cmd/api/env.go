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

type envConfig struct {
	DB        postgres
	Port      string
	JWTConfig auth0.JWTConfig
}

func getEnvConfig() envConfig {
	port := os.Getenv("PORT")

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
		Port: port,
	}
}
