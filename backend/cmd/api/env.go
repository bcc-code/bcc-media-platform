package main

import (
	"os"
)

type postgres struct {
	ConnectionString string
}

type algolia struct {
	AppId  string
	ApiKey string
}

type envConfig struct {
	DB      postgres
	Algolia algolia
	Port    string
}

func getEnvConfig() envConfig {
	return envConfig{
		DB: postgres{
			ConnectionString: os.Getenv("DB_CONNECTION"),
		},
		Port: os.Getenv("PORT"),
		Algolia: algolia{
			AppId:  os.Getenv("ALGOLIA_APP_ID"),
			ApiKey: os.Getenv("ALGOLIA_API_KEY"),
		},
	}
}
