package main

import "os"

type awsConfig struct {
	Region                string
	PackagingGroupARN     string
	MediapackageRoleARN   string
	MediapackageSourceARN string
	IngestBucket          string
	StorageBucket         string
}

type postgres struct {
	ConnectionString string
}

type directusConfig struct {
	BaseURL string
	Key     string
}

type envConfig struct {
	AWS      awsConfig
	Directus directusConfig
	Port     string
}

func getEnvConfig() envConfig {
	return envConfig{
		Port: os.Getenv("PORT"),
		AWS: awsConfig{
			Region:                os.Getenv("AWS_DEFAULT_REGION"),
			PackagingGroupARN:     os.Getenv("AWS_PACKAGING_GROUP"),
			MediapackageRoleARN:   os.Getenv("AWS_MEDIAPACKAGE_ROLE"),
			MediapackageSourceARN: os.Getenv("AWS_MEDIAPACKAGE_SOURCE"),
			IngestBucket:          os.Getenv("AWS_INGEST_BUCKET"),
			StorageBucket:         os.Getenv("AWS_STORAGE_BUCKET"),
		},
		Directus: directusConfig{
			BaseURL: os.Getenv("DIRECTUS_URL"),
			Key:     os.Getenv("DIRECTUS_KEY"),
		},
	}
}
