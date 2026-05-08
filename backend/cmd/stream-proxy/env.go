package main

import (
	"os"
	"time"

	"github.com/bcc-code/bcc-media-platform/backend/streamtoken"
	"github.com/joho/godotenv"
)

type envConfig struct {
	Port        string
	Environment string

	CDNDomainCloudFront string
	CDNDomainIoriver    string
	DefaultProvider     streamtoken.Provider

	CacheTTL time.Duration
	SignTTL  time.Duration

	JWTSecret string
	JWTIssuer string

	CloudFrontSigning cloudfrontSigningConfig
	IoriverSigning    ioriverSigningConfig

	Tracing tracingConfig
}

// cloudfrontSigningConfig holds the direct-CloudFront key + key id. Fastly and
// Akamai fields are intentionally empty so the ioriver signer library only
// emits CloudFront query params for this signer.
type cloudfrontSigningConfig struct {
	KeyPath string
	KeyID   string
}

func (c cloudfrontSigningConfig) GetAwsSigningKeyPath() string   { return c.KeyPath }
func (c cloudfrontSigningConfig) GetAwsSigningKeyID() string     { return c.KeyID }
func (c cloudfrontSigningConfig) GetFastlySigningKeyID() string  { return "" }
func (c cloudfrontSigningConfig) GetAkamaiSigningKeyID() string  { return "" }
func (c cloudfrontSigningConfig) GetAkamaiEncryptionKey() string { return "" }

// ioriverSigningConfig holds the ioriver-issued key plus the per-sub-provider
// key ids. ioriver fans the same RSA key out into CloudFront, Fastly, and
// Akamai signature formats so any sub-provider it routes to can validate.
type ioriverSigningConfig struct {
	KeyPath             string
	CloudFrontKeyID     string
	FastlyKeyID         string
	AkamaiKeyID         string
	AkamaiEncryptionKey string
}

func (c ioriverSigningConfig) GetAwsSigningKeyPath() string   { return c.KeyPath }
func (c ioriverSigningConfig) GetAwsSigningKeyID() string     { return c.CloudFrontKeyID }
func (c ioriverSigningConfig) GetFastlySigningKeyID() string  { return c.FastlyKeyID }
func (c ioriverSigningConfig) GetAkamaiSigningKeyID() string  { return c.AkamaiKeyID }
func (c ioriverSigningConfig) GetAkamaiEncryptionKey() string { return c.AkamaiEncryptionKey }

type tracingConfig struct {
	UptraceDSN        string
	SamplingFrequency string
	TracePrettyPrint  string
}

func parseDurationOr(raw string, fallback time.Duration) time.Duration {
	if raw == "" {
		return fallback
	}
	d, err := time.ParseDuration(raw)
	if err != nil {
		return fallback
	}
	return d
}

func getEnvConfig() envConfig {
	_ = godotenv.Load("backend/cmd/stream-proxy/.env")
	_ = godotenv.Load(".env")

	return envConfig{
		Port:        os.Getenv("PORT"),
		Environment: os.Getenv("ENVIRONMENT"),

		CDNDomainCloudFront: os.Getenv("STREAM_PROXY_CDN_DOMAIN_CLOUDFRONT"),
		CDNDomainIoriver:    os.Getenv("STREAM_PROXY_CDN_DOMAIN_IORIVER"),
		DefaultProvider:     streamtoken.Provider(os.Getenv("STREAM_PROXY_DEFAULT_PROVIDER")),

		CacheTTL: parseDurationOr(os.Getenv("STREAM_PROXY_CACHE_TTL"), 10*time.Minute),
		SignTTL:  parseDurationOr(os.Getenv("STREAM_PROXY_SIGN_TTL"), 6*time.Hour),

		JWTSecret: os.Getenv("STREAM_JWT_SECRET"),
		JWTIssuer: os.Getenv("STREAM_JWT_ISSUER"),

		CloudFrontSigning: cloudfrontSigningConfig{
			KeyPath: os.Getenv("CF_SIGNING_KEY_PATH"),
			KeyID:   os.Getenv("CLOUDFRONT_DIRECT_SIGNING_KEY_ID"),
		},

		IoriverSigning: ioriverSigningConfig{
			KeyPath:             os.Getenv("IORIVER_SIGNING_KEY_PATH"),
			CloudFrontKeyID:     os.Getenv("IORIVER_CLOUDFRONT_KEY_ID"),
			FastlyKeyID:         os.Getenv("IORIVER_FASTLY_KEY_ID"),
			AkamaiKeyID:         os.Getenv("IORIVER_AKAMAI_KEY_ID"),
			AkamaiEncryptionKey: os.Getenv("IORIVER_AKAMAI_ENCRYPTION_KEY"),
		},

		Tracing: tracingConfig{
			UptraceDSN:        os.Getenv("UPTRACE_DSN"),
			SamplingFrequency: os.Getenv("TRACE_SAMPLING_FREQUENCY"),
			TracePrettyPrint:  os.Getenv("TRACE_PRETTY"),
		},
	}
}
