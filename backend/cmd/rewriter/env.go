package main

import (
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"os"
)

type envConfig struct {
	WebEndpoint string
	APIEndpoint string
	Port        string
	Tracing     utils.TracingConfig
}

func getEnvConfig() envConfig {
	return envConfig{
		WebEndpoint: os.Getenv("WEB_ENDPOINT"),
		APIEndpoint: os.Getenv("API_ENDPOINT"),
		Port:        os.Getenv("PORT"),
		Tracing: utils.TracingConfig{
			UptraceDSN:        os.Getenv("UPTRACE_DSN"),
			SamplingFrequency: os.Getenv("TRACE_SAMPLING_FREQUENCY"),
			TracePrettyPrint:  os.Getenv("TRACE_PRETTY"),
		},
	}
}
