package main

import (
	"crypto/rand"
	"crypto/rsa"
	"crypto/x509"
	"encoding/pem"
	"os"
	"strings"

	"github.com/bcc-code/bcc-media-platform/backend/pubsub"

	"github.com/bcc-code/bcc-media-platform/backend/bmm"

	"github.com/bcc-code/bcc-media-platform/backend/analytics"

	"github.com/bcc-code/bcc-media-platform/backend/email"
	"github.com/bcc-code/bcc-media-platform/backend/log"

	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/bcc-media-platform/backend/utils"

	"github.com/bcc-code/bcc-media-platform/backend/members"
	"github.com/bcc-code/bcc-media-platform/backend/search"

	"github.com/bcc-code/bcc-media-platform/backend/auth0"
	"github.com/bcc-code/bcc-media-platform/backend/streamtoken"
	"github.com/joho/godotenv"
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
	Search        search.Config
	Port          string
	Auth0         auth0.Config
	CDNConfig     cdnConfig
	Livestream    livestreamConfig
	StreamProxy   streamProxyConfig
	Secrets       serviceSecrets
	Redis         utils.RedisConfig
	AWS           awsConfig
	Tracing       utils.TracingConfig
	AnalyticsSalt string
	Email         email.Config
	Redirect      *redirectConfig
	Analytics     analytics.Config
	BMM           bmm.Config
	PubSub        pubsub.Config
}

type cdnConfig struct {
	ImageCDNDomain    string
	Vod2Domain        string
	LegacyVODDomain   string
	FilesDomain       string
	AWSSigningKeyPath string
	AWSSigningKeyID   string
}

// livestreamConfig holds the CloudFront key pair used to sign the livestream
// manifest URL. This is a separate key pair from the VOD/file signing key in
// cdnConfig. It satisfies signing.CloudFrontConfig.
type livestreamConfig struct {
	SigningKeyPath string
	SigningKeyID   string
}

func (c livestreamConfig) GetAwsSigningKeyPath() string { return c.SigningKeyPath }
func (c livestreamConfig) GetAwsSigningKeyID() string   { return c.SigningKeyID }

type streamProxyConfig struct {
	JWTSecret       string
	JWTIssuer       string
	Domain          string
	PrimaryProvider streamtoken.Provider
}

func (c streamProxyConfig) GetStreamJWTSecret() string                     { return c.JWTSecret }
func (c streamProxyConfig) GetStreamJWTIssuer() string                     { return c.JWTIssuer }
func (c streamProxyConfig) GetStreamProxyDomain() string                   { return c.Domain }
func (c streamProxyConfig) GetStreamPrimaryProvider() streamtoken.Provider { return c.PrimaryProvider }

// parsePrimaryProvider maps the user-facing STREAM_PRIMARY_PROVIDER values
// ("cloudfront", "streamproxy") to the streamtoken.Provider used as the JWT
// `provider` claim. The claim values are different ("cloudfront", "ioriver")
// because they are the stream-proxy's internal vocabulary; the API exposes
// the same routing decision under a name that abstracts away the
// underlying signer technology. Empty raw → ProviderUnspecified (signer
// substitutes its own default). Unknown raw passes through so the signer's
// validity check rejects it with a clear error.
func parsePrimaryProvider(raw string) streamtoken.Provider {
	switch raw {
	case "":
		return streamtoken.ProviderUnspecified
	case "cloudfront":
		return streamtoken.ProviderCloudFront
	case "streamproxy":
		return streamtoken.ProviderIoriver
	}
	return streamtoken.Provider(raw)
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

type rudderstackConfig struct {
	Dataplane string
	Key       string
	Verbose   bool
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

// GetTempStorageBucket returns the temporary storage bucket
func (a awsConfig) GetTempStorageBucket() string {
	return a.TempBucket
}

func getEnvConfig() envConfig {
	err := godotenv.Load("backend/cmd/api/.env")
	if err == nil {
		log.L.Warn().Msg("Loaded backend/cmd/api/.env file")
	}

	err = godotenv.Load(".env")
	if err == nil {
		log.L.Warn().Msg("Loaded .env file")
	}

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
		Search: search.Config{
			Elastic: search.ElasticConfig{
				CloudID: os.Getenv("ELASTIC_CLOUDID"),
				ApiKey:  os.Getenv("ELASTIC_APIKEY"),

				URL:      os.Getenv("ELASTIC_URL"),
				Username: os.Getenv("ELASTIC_USERNAME"),
				Password: os.Getenv("ELASTIC_PASSWORD"),
			},
		},
		CDNConfig: cdnConfig{
			ImageCDNDomain:    os.Getenv("IMAGE_CDN_DOMAIN"),
			Vod2Domain:        os.Getenv("VOD2_CDN_DOMAIN"),
			FilesDomain:       os.Getenv("FILES_CDN_DOMAIN"),
			AWSSigningKeyID:   os.Getenv("CF_SIGNING_KEY_ID"),
			AWSSigningKeyPath: os.Getenv("CF_SIGNING_KEY_PATH"),
			LegacyVODDomain:   os.Getenv("LEGACY_CDN_DOMAIN"),
		},
		Livestream: livestreamConfig{
			SigningKeyID:   os.Getenv("LIVESTREAM_SIGNING_KEY_ID"),
			SigningKeyPath: os.Getenv("LIVESTREAM_SIGNING_KEY_PATH"),
		},
		StreamProxy: streamProxyConfig{
			JWTSecret:       os.Getenv("STREAM_JWT_SECRET"),
			JWTIssuer:       os.Getenv("STREAM_JWT_ISSUER"),
			Domain:          os.Getenv("STREAM_PROXY_DOMAIN"),
			PrimaryProvider: parsePrimaryProvider(os.Getenv("STREAM_PRIMARY_PROVIDER")),
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
			Provider:       os.Getenv("EMAIL_PROVIDER"),
			SendGridAPIKey: os.Getenv("SENDGRID_API_KEY"),
			ResendAPIKey:   os.Getenv("RESEND_API_KEY"),
			FromEmail:      os.Getenv("EMAIL_FROM"),
		},
		Redirect: &redirectConfig{
			JWTPrivateKeyRaw: os.Getenv("REDIRECT_JWT_KEY"),
			KeyID:            os.Getenv("REDIRECT_JWT_KEY_ID"),
		},
		AnalyticsSalt: os.Getenv("ANALYTICS_SALT"),
		Analytics: analytics.Config{
			DataPlane: os.Getenv("RUDDERSTACK_DATA_PLANE_URL"),
			WriteKey:  os.Getenv("RUDDERSTACK_WRITE_KEY"),
			Verbose:   strings.ToLower(os.Getenv("RUDDERSTACK_VERBOSE")) == "true",
		},
		BMM: bmm.Config{
			Auth0BaseURL: os.Getenv("BMM_AUTH0_BASE_URL"),
			ClientID:     os.Getenv("BMM_CLIENT_ID"),
			ClientSecret: os.Getenv("BMM_CLIENT_SECRET"),
			Audience:     os.Getenv("BMM_AUDIENCE"),
			BaseURL:      os.Getenv("BMM_BASE_URL"),
			Debug:        os.Getenv("BMM_DEBUG") == "true",
		},
		PubSub: pubsub.Config{
			PubSubProjectID: os.Getenv("PUBSUB_PROJECT_ID"),
			PubSubTopicID:   os.Getenv("PUBSUB_TOPIC_ID"),
		},
	}
}
