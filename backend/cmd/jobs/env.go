package main

import (
	"os"
	"strconv"

	"github.com/bcc-code/bcc-media-platform/backend/translations/phrase"
	"github.com/joho/godotenv"

	"github.com/bcc-code/bcc-media-platform/backend/auth0"
	"github.com/bcc-code/bcc-media-platform/backend/files"
	"github.com/bcc-code/bcc-media-platform/backend/log"
	"github.com/bcc-code/bcc-media-platform/backend/members"
	"github.com/bcc-code/bcc-media-platform/backend/search"
	"github.com/bcc-code/bcc-media-platform/backend/statistics"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
)

type awsConfig struct {
	Region                string
	PackagingGroupARN     string
	MediapackageRoleARN   string
	MediapackageSourceARN string
	IngestBucket          string
	StorageBucket         string
}

type firebase struct {
	ProjectID string
}

type cloudTasks struct {
	QueueID string
}

type videomanipulatorConfig struct {
	baseURL string
	apiKey  string
}

type envConfig struct {
	AWS               awsConfig
	AzureStorage      files.AzureConfig
	Port              string
	DeleteIngestFiles bool
	DB                utils.DatabaseConfig
	Search            search.Config
	Firebase          firebase
	ImageCDNDomain    string
	Tracing           utils.TracingConfig
	CloudTasks        cloudTasks
	ServiceUrl        string
	Redis             utils.RedisConfig
	Auth0             auth0.Config
	Members           members.Config
	BigQuery          statistics.BigQueryConfig
	VideoManipulator  videomanipulatorConfig
	Phrase            phrase.Config
}

func getEnvConfig() envConfig {
	err := godotenv.Load("backend/cmd/jobs/.env")
	if err == nil {
		log.L.Warn().Msg("Loaded .env file")
	}

	err = godotenv.Load(".env")
	if err == nil {
		log.L.Warn().Msg("Loaded .env file")
	}

	deleteIngestFilesString := os.Getenv("DELETE_INGEST_FILES")
	// Error is intentionally ignored, if not set default to FALSE
	deleteIngestFilesStringBool, _ := strconv.ParseBool(deleteIngestFilesString)

	return envConfig{
		Port:              os.Getenv("PORT"),
		DeleteIngestFiles: deleteIngestFilesStringBool,
		ImageCDNDomain:    os.Getenv("IMAGE_CDN_DOMAIN"),
		AWS: awsConfig{
			Region:                os.Getenv("AWS_DEFAULT_REGION"),
			PackagingGroupARN:     os.Getenv("AWS_PACKAGING_GROUP"),
			MediapackageRoleARN:   os.Getenv("AWS_MEDIAPACKAGE_ROLE"),
			MediapackageSourceARN: os.Getenv("AWS_MEDIAPACKAGE_SOURCE"),
			IngestBucket:          os.Getenv("AWS_INGEST_BUCKET"),
			StorageBucket:         os.Getenv("AWS_STORAGE_BUCKET"),
		},
		AzureStorage: files.AzureConfig{
			AccountName: os.Getenv("AZURE_STORAGE_ACCOUNT_NAME"),
			AccountKey:  os.Getenv("AZURE_STORAGE_ACCOUNT_KEY"),
			Container:   os.Getenv("AZURE_STORAGE_CONTAINER"),
		},
		DB: utils.DatabaseConfig{
			ConnectionString:   os.Getenv("DB_CONNECTION_STRING"),
			MaxConnections:     utils.AsIntOrNil(os.Getenv("DB_MAX_CONS")),
			MaxIdleConnections: utils.AsIntOrNil(os.Getenv("DB_MAX_IDLE_CONS")),
		},
		Search: search.Config{
			Algolia: search.AlgoliaConfig{
				AppID:  os.Getenv("ALGOLIA_APP_ID"),
				APIKey: os.Getenv("ALGOLIA_API_KEY"),
			},
			Elastic: search.ElasticConfig{
				CloudID: os.Getenv("ELASTIC_CLOUDID"),
				ApiKey:  os.Getenv("ELASTIC_APIKEY"),

				URL:      os.Getenv("ELASTIC_URL"),
				Username: os.Getenv("ELASTIC_USERNAME"),
				Password: os.Getenv("ELASTIC_PASSWORD"),
			},
		},
		Firebase: firebase{
			ProjectID: os.Getenv("FIREBASE_PROJECT_ID"),
		},
		Tracing: utils.TracingConfig{
			UptraceDSN:        os.Getenv("UPTRACE_DSN"),
			SamplingFrequency: os.Getenv("TRACE_SAMPLING_FREQUENCY"),
			TracePrettyPrint:  os.Getenv("TRACE_PRETTY"),
		},
		CloudTasks: cloudTasks{
			QueueID: os.Getenv("CLOUD_TASKS_QUEUE_ID"),
		},
		Redis: utils.RedisConfig{
			Address:  os.Getenv("REDIS_ADDRESS"),
			Username: os.Getenv("REDIS_USERNAME"),
			Password: os.Getenv("REDIS_PASSWORD"),
			Database: utils.AsInt(os.Getenv("REDIS_DATABASE")),
		},
		ServiceUrl: os.Getenv("SERVICE_URL"),
		Auth0: auth0.Config{
			ClientID:     os.Getenv("AUTH0_CLIENT_ID"),
			ClientSecret: os.Getenv("AUTH0_CLIENT_SECRET"),
			Domain:       os.Getenv("AUTH0_DOMAIN"),
		},
		Members: members.Config{
			Domain: os.Getenv("MEMBERS_API_DOMAIN"),
		},
		BigQuery: statistics.BigQueryConfig{
			ProjectID: os.Getenv("BIGQUERY_PROJECT"), // Export disabled if empty
			DatasetID: os.Getenv("BIGQUERY_DATASET"),
		},
		VideoManipulator: videomanipulatorConfig{
			baseURL: os.Getenv("VIDEOMANIPULATOR_BASE_URL"),
			apiKey:  os.Getenv("VIDEOMANIPULATOR_API_KEY"),
		},
		Phrase: phrase.Config{
			Username:    os.Getenv("PHRASE_USERNAME"),
			Password:    os.Getenv("PHRASE_PASSWORD"),
			UserUID:     os.Getenv("PHRASE_USER_UID"),
			ProjectUID:  os.Getenv("PHRASE_PROJECT_UID"),
			CallbackURL: os.Getenv("PHRASE_CALLBACK_URL"),
			Debug:       os.Getenv("PHRASE_DEBUG") == "true",
		},
	}
}
