package main

import "os"

type envConfig struct {
	WebEndpoint string
	APIEndpoint string
	Port        string
}

func getEnvConfig() envConfig {
	return envConfig{
		WebEndpoint: os.Getenv("WEB_ENDPOINT"),
		APIEndpoint: os.Getenv("API_ENDPOINT"),
		Port:        os.Getenv("PORT"),
	}
}
