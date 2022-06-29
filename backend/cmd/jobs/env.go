package main

import (
	"github.com/samber/lo"
	"os"
	"strconv"
	"strings"
)

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

type algolia struct {
	AppId            string
	ApiKey           string
	SearchOnlyApiKey string
}

type directusConfig struct {
	BaseURL string
	Key     string
}

type crowdinConfig struct {
	Token      string
	ProjectIDs []int
}

type envConfig struct {
	AWS               awsConfig
	Directus          directusConfig
	Port              string
	DeleteIngestFiles bool
	DB                postgres
	Algolia           algolia
	Crowdin           crowdinConfig
}

func getEnvConfig() envConfig {

	deleteIngestFilesString := os.Getenv("DELETE_INGEST_FILES")
	// Error is intentionally ignored, if not set default to FALSE
	deleteIngestFilesStringBool, _ := strconv.ParseBool(deleteIngestFilesString)

	return envConfig{
		Port:              os.Getenv("PORT"),
		DeleteIngestFiles: deleteIngestFilesStringBool,
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
		DB: postgres{
			ConnectionString: os.Getenv("DB_CONNECTION_STRING"),
		},
		Algolia: algolia{
			AppId:            os.Getenv("ALGOLIA_APP_ID"),
			ApiKey:           os.Getenv("ALGOLIA_API_KEY"),
			SearchOnlyApiKey: os.Getenv("ALGOLIA_SEARCH_ONLY_API_KEY"),
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
