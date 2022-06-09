package main

import (
	"os"
)

const envPort = "PORT"
const envDbConnectionString = "DB_CONNECTION_STRING"
const envAlgoliaAppId = "ALGOLIA_APP_ID"
const envAlgoliaApiKey = "ALGOLIA_API_KEY"

type postgres struct {
	ConnectionString string
}

type algolia struct {
	AppId  string
	ApiKey string
}

type envConfig struct {
	Port    string
	DB      postgres
	Algolia algolia
}

func getEnvConfig() envConfig {
	return envConfig{
		Port: os.Getenv(envPort),
		DB: postgres{
			ConnectionString: os.Getenv(envDbConnectionString),
		},
		Algolia: algolia{
			AppId:  os.Getenv(envAlgoliaAppId),
			ApiKey: os.Getenv(envAlgoliaApiKey),
		},
	}
}
