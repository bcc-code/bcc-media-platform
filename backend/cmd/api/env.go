package main

import (
	"os"
)

type postgres struct {
	ConnectionString string
}

type envConfig struct {
	DB   postgres
	Port string
}

func getEnvConfig() envConfig {
	port := os.Getenv("PORT")

	return envConfig{
		DB: postgres{
			ConnectionString: os.Getenv("DB_CONNECTION"),
		},
		Port: port,
	}
}
