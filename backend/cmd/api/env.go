package main

import (
	"crypto/rand"
	"crypto/rsa"
	"crypto/x509"
	"encoding/pem"
	"github.com/bcc-code/bcc-media-platform/backend/email"
	"os"
	"strings"

	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/bcc-media-platform/backend/utils"

	"github.com/bcc-code/bcc-media-platform/backend/members"
	"github.com/bcc-code/bcc-media-platform/backend/search"

	"github.com/bcc-code/bcc-media-platform/backend/auth0"
	"github.com/samber/lo"
)

type env string

// Development checks if env is development
func (e env) Development() bool {
	switch e {
	case "development":
		return true
	}
	return false
}

// Production checks if env is production
func (e env) Production() bool {
	switch e {
	case "development", "test":
		return false
	}
	return true
}

// Test checks if env is test
func (e env) Test() bool {
	switch e {
	case "test":
		return true
	}
	return false
}

var environment = env(os.Getenv("ENVIRONMENT"))

type envConfig struct {
	Members       members.Config
	DB            utils.DatabaseConfig
	Algolia       search.Config
	Port          string
	Auth0         auth0.Config
	CDNConfig     cdnConfig
	Secrets       serviceSecrets
	Redis         utils.RedisConfig
	AWS           awsConfig
	Tracing       utils.TracingConfig
	AnalyticsSalt string
	Email         email.Config
	Redirect      *redirectConfig
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
	TempBucket string // Things put here are automatically removed
	Region     string
}

type serviceSecrets struct {
	Directus string
}

type redirectConfig struct {
	JWTPrivateKeyRaw string
	jwtPrivateKey    *rsa.PrivateKey
	KeyID            string
}

func toPrivateKey(key string) *rsa.PrivateKey {
	var privateKey *rsa.PrivateKey
	if environment.Production() || key != "" {
		// Parse the RSA Private KEY. The key should be in the pem format as delivered by Terraform
		block, _ := pem.Decode([]byte(key))
		if block == nil {
			panic(merry.New("Unable to parse PEM key, likely not set (REDIRECT_JWT_KEY)"))
		}

		var err error
		privateKey, err = x509.ParsePKCS1PrivateKey(block.Bytes)
		if err != nil {
			panic(merry.Wrap(err, merry.WithMessage("Unable to parse JWT private key (REDIRECT_JWT_KEY)")))
		}
	} else {
		privateKey, _ = rsa.GenerateKey(rand.Reader, 2048)
	}
	return privateKey
}

// GetPrivateKey returns the parsed private key
func (r *redirectConfig) GetPrivateKey() *rsa.PrivateKey {
	if r.jwtPrivateKey == nil {
		r.jwtPrivateKey = toPrivateKey(r.JWTPrivateKeyRaw)
	}
	return r.jwtPrivateKey
}

// GetVOD2Domain returns the configured VOD2Domain
func (c cdnConfig) GetVOD2Domain() string {
	return c.Vod2Domain
}

// GetLegacyVODDomain returns the legacy VOD domain
func (c cdnConfig) GetLegacyVODDomain() string {
	return c.LegacyVODDomain
}

// GetFilesCDNDomain returns the configured FilesCDNDomain
func (c cdnConfig) GetFilesCDNDomain() string {
	return c.FilesDomain
}

// GetAwsSigningKeyPath returns the path to the AWS signing key
func (c cdnConfig) GetAwsSigningKeyPath() string {
	return c.AWSSigningKeyPath
}

// GetAwsSigningKeyID returns the AWS signing key
func (c cdnConfig) GetAwsSigningKeyID() string {
	return c.AWSSigningKeyID
}

// GetAzureSigningKey returns the Azure signing key
func (c cdnConfig) GetAzureSigningKey() string {
	return c.AzureSigningKey
}

// GetTempStorageBucket returns the temporary storage bucket
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
		DB: utils.DatabaseConfig{
			ConnectionString:   os.Getenv("DB_CONNECTION_STRING"),
			MaxConnections:     utils.AsIntOrNil(os.Getenv("DB_MAX_CONS")),
			MaxIdleConnections: utils.AsIntOrNil(os.Getenv("DB_MAX_IDLE_CONS")),
		},
		Auth0: auth0.Config{
			ClientID:           os.Getenv("AUTH0_CLIENT_ID"),
			ClientSecret:       os.Getenv("AUTH0_CLIENT_SECRET"),
			Domain:             os.Getenv("AUTH0_DOMAIN"),
			Audiences:          aud,
			ManagementAudience: os.Getenv("AUTH0_MANAGEMENT_AUDIENCE"),
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
		Redis: utils.RedisConfig{
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
		Email: email.Config{
			ApiKey: os.Getenv("SENDGRID_API_KEY"),
		},
		Redirect: &redirectConfig{
			JWTPrivateKeyRaw: os.Getenv("REDIRECT_JWT_KEY"),
			KeyID:            os.Getenv("REDIRECT_JWT_KEY_ID"),
		},
		AnalyticsSalt: os.Getenv("ANALYTICS_SALT"),
	}
}
