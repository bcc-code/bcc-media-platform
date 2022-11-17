package main

import (
	"os"
	"strings"

	"github.com/bcc-code/brunstadtv/backend/utils"

	"github.com/bcc-code/brunstadtv/backend/members"
	"github.com/bcc-code/brunstadtv/backend/search"

	"github.com/bcc-code/brunstadtv/backend/auth0"
	"github.com/samber/lo"
)

type envConfig struct {
	Members   members.Config
	DB        postgres
	Algolia   search.Config
	Port      string
	Auth0     auth0.Config
	CDNConfig cdnConfig
	Secrets   serviceSecrets
	Redis     redisConfig
	AWS       awsConfig
	Tracing   utils.TracingConfig
}

type postgres struct {
	ConnectionString string
}

type cdnConfig struct {
	ImageCDNDomain    string
	Vod2Domain        string
	LegacyVODDomain   string
	FilesDomain       string
	AWSSigningKeyPath string
	AWSSigningKeyID   string
	AzureSigningKey   string
}

type awsConfig struct {
	TempBucket string // Things put here are autoremoved
	Region     string
}

type redisConfig struct {
	Address  string
	Username string
	Password string
	Database int
}

type serviceSecrets struct {
	Directus string
}

// GetVOD2Domain returns the configured VOD2Domain
func (c cdnConfig) GetVOD2Domain() string {
	return c.Vod2Domain
}

func (c cdnConfig) GetLegacyVODDomain() string {
	return c.LegacyVODDomain
}

// GetFilesCDNDomain returns the configured FilesCDNDomain
func (c cdnConfig) GetFilesCDNDomain() string {
	return c.FilesDomain
}

func (c cdnConfig) GetAwsSigningKeyPath() string {
	return c.AWSSigningKeyPath
}

func (c cdnConfig) GetAwsSigningKeyID() string {
	return c.AWSSigningKeyID
}

func (c cdnConfig) GetAzureSigningKey() string {
	return c.AzureSigningKey
}

func (a awsConfig) GetTempStorageBucket() string {
	return a.TempBucket
}

func getEnvConfig() envConfig {
	aud := lo.Map(strings.Split(os.Getenv("AUTH0_AUDIENCES"), ","),
		func(s string, _ int) string {
			return strings.TrimSpace(s)
		},
	)

	return envConfig{
		Members: members.Config{
			Domain: os.Getenv("MEMBERS_API_DOMAIN"),
		},
		DB: postgres{
			ConnectionString: os.Getenv("DB_CONNECTION_STRING"),
		},
		Auth0: auth0.Config{
			ClientID:     os.Getenv("AUTH0_CLIENT_ID"),
			ClientSecret: os.Getenv("AUTH0_CLIENT_SECRET"),
			Domain:       os.Getenv("AUTH0_DOMAIN"),
			Audiences:    aud,
		},
		AWS: awsConfig{
			TempBucket: os.Getenv("AWS_TEMP_BUCKET"),
			Region:     os.Getenv("AWS_DEFAULT_REGION"),
		},
		Port: os.Getenv("PORT"),
		Algolia: search.Config{
			AppID:  os.Getenv("ALGOLIA_APP_ID"),
			APIKey: os.Getenv("ALGOLIA_API_KEY"),
		},
		CDNConfig: cdnConfig{
			ImageCDNDomain:    os.Getenv("IMAGE_CDN_DOMAIN"),
			Vod2Domain:        os.Getenv("VOD2_CDN_DOMAIN"),
			FilesDomain:       os.Getenv("FILES_CDN_DOMAIN"),
			AWSSigningKeyID:   os.Getenv("CF_SIGNING_KEY_ID"),
			AWSSigningKeyPath: os.Getenv("CF_SIGNING_KEY_PATH"),
			AzureSigningKey:   os.Getenv("AZ_SIGNING_KEY"),
			LegacyVODDomain:   os.Getenv("LEGACY_CDN_DOMAIN"),
		},
		Secrets: serviceSecrets{
			Directus: os.Getenv("SERVICE_SECRET_DIRECTUS"),
		},
		Redis: redisConfig{
			Address:  os.Getenv("REDIS_ADDRESS"),
			Username: os.Getenv("REDIS_USERNAME"),
			Password: os.Getenv("REDIS_PASSWORD"),
			Database: utils.AsInt(os.Getenv("REDIS_DATABASE")),
		},
		Tracing: utils.TracingConfig{
			UptraceDSN:        os.Getenv("UPTRACE_DSN"),
			SamplingFrequency: os.Getenv("TRACE_SAMPLING_FREQUENCY"),
			TracePrettyPrint:  os.Getenv("TRACE_PRETTY"),
		},
	}
}
