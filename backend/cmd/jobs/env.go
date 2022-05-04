package main

import "os"

type awsConfig struct {
	Region                string
	PackagingGroupARN     string
	MediapackageRoleARN   string
	MediapackageSourceARN string
	IngestBucket          string
}

type postgres struct {
	ConnectionString string
}

type envConfig struct {
	AWS awsConfig
}

func getEnvConfig() envConfig {
	return envConfig{
		AWS: awsConfig{
			Region:                os.Getenv("AWS_DEFAULT_REGION"),
			PackagingGroupARN:     os.Getenv("AWS_PACKAGING_GROUP"),
			MediapackageRoleARN:   os.Getenv("AWS_MEDIAPACKAGE_ROLE"),
			MediapackageSourceARN: os.Getenv("AWS_MEDIAPACKAGE_SOURCE"),
			IngestBucket:          os.Getenv("AWS_INGEST_BUCKET"),
		},
	}
}
