package main

import "os"

type awsConfig struct {
	Region   string
	Endpoint string
}
type postgres struct {
	ConnectionString string
}

type envConfig struct {
	AWS           map[string]awsConfig
	PG            postgres
	IngestBucket  string
	JobsUserEmail string
}

func getEnvConfig() envConfig {
	return envConfig{
		AWS: map[string]awsConfig{
			"S3": {
				Region:   os.Getenv("AWS_REGION"),
				Endpoint: os.Getenv("AWS_S3_ENDPOINT"),
			},
		},
		PG: postgres{
			ConnectionString: os.Getenv("DB_CONNECTION"),
		},
		IngestBucket:  os.Getenv("AWS_INGEST_BUCKET"),
		JobsUserEmail: os.Getenv("JOBS_USER_EMAIL"),
	}
}
