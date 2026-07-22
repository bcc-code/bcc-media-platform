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

	// Live upstreams. Live is a separate MediaPackage origin behind its own CDN
	// distributions / ioriver stream, so it has its own hosts and key material.
	// Each field falls back to the VOD equivalent above when its env var is
	// unset, so a shared setup needs no live-specific config.
	LiveCDNDomainCloudFront string
	LiveCDNDomainIoriver    string

	CacheTTL     time.Duration
	LiveCacheTTL time.Duration
	SignTTL      time.Duration

	JWTSecret string
	JWTIssuer string

	CloudFrontSigning cloudfrontSigningConfig
	IoriverSigning    ioriverSigningConfig

	LiveCloudFrontSigning cloudfrontSigningConfig
	LiveIoriverSigning    ioriverSigningConfig

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

// envOr returns the value of env var key, or fallback when it is unset/empty.
// Used to let the live-specific signing config default to the VOD values.
func envOr(key, fallback string) string {
	if v := os.Getenv(key); v != "" {
		return v
	}
	return fallback
}

func getEnvConfig() envConfig {
	_ = godotenv.Load("backend/cmd/stream-proxy/.env")
	_ = godotenv.Load(".env")

	cdnDomainCloudFront := os.Getenv("STREAM_PROXY_CDN_DOMAIN_CLOUDFRONT")
	cdnDomainIoriver := os.Getenv("STREAM_PROXY_CDN_DOMAIN_IORIVER")

	cfSigning := cloudfrontSigningConfig{
		KeyPath: os.Getenv("CF_SIGNING_KEY_PATH"),
		KeyID:   os.Getenv("CF_SIGNING_KEY_ID"),
	}
	ioriverSigning := ioriverSigningConfig{
		KeyPath:             os.Getenv("IORIVER_SIGNING_KEY_PATH"),
		CloudFrontKeyID:     os.Getenv("IORIVER_CLOUDFRONT_KEY_ID"),
		FastlyKeyID:         os.Getenv("IORIVER_FASTLY_KEY_ID"),
		AkamaiKeyID:         os.Getenv("IORIVER_AKAMAI_KEY_ID"),
		AkamaiEncryptionKey: os.Getenv("IORIVER_AKAMAI_ENCRYPTION_KEY"),
	}

	return envConfig{
		Port:        os.Getenv("PORT"),
		Environment: os.Getenv("ENVIRONMENT"),

		CDNDomainCloudFront: cdnDomainCloudFront,
		CDNDomainIoriver:    cdnDomainIoriver,
		DefaultProvider:     streamtoken.Provider(os.Getenv("STREAM_PROXY_DEFAULT_PROVIDER")),

		LiveCDNDomainCloudFront: envOr("STREAM_PROXY_LIVE_CDN_DOMAIN_CLOUDFRONT", cdnDomainCloudFront),
		LiveCDNDomainIoriver:    envOr("STREAM_PROXY_LIVE_CDN_DOMAIN_IORIVER", cdnDomainIoriver),

		CacheTTL: parseDurationOr(os.Getenv("STREAM_PROXY_CACHE_TTL"), 10*time.Minute),
		// Live manifests are rewritten every segment, so they are cached only
		// briefly — just long enough for the per-key single-flight lock to
		// collapse simultaneous polling onto one upstream fetch. Defaults to 2s
		// so no env var is required; STREAM_PROXY_LIVE_CACHE_TTL can override.
		LiveCacheTTL: parseDurationOr(os.Getenv("STREAM_PROXY_LIVE_CACHE_TTL"), 2*time.Second),
		SignTTL:      parseDurationOr(os.Getenv("STREAM_PROXY_SIGN_TTL"), 6*time.Hour),

		JWTSecret: os.Getenv("STREAM_JWT_SECRET"),
		JWTIssuer: os.Getenv("STREAM_JWT_ISSUER"),

		CloudFrontSigning: cfSigning,
		IoriverSigning:    ioriverSigning,

		LiveCloudFrontSigning: cloudfrontSigningConfig{
			KeyPath: envOr("LIVE_CF_SIGNING_KEY_PATH", cfSigning.KeyPath),
			KeyID:   envOr("LIVE_CF_SIGNING_KEY_ID", cfSigning.KeyID),
		},

		LiveIoriverSigning: ioriverSigningConfig{
			KeyPath:             envOr("LIVE_IORIVER_SIGNING_KEY_PATH", ioriverSigning.KeyPath),
			CloudFrontKeyID:     envOr("LIVE_IORIVER_CLOUDFRONT_KEY_ID", ioriverSigning.CloudFrontKeyID),
			FastlyKeyID:         envOr("LIVE_IORIVER_FASTLY_KEY_ID", ioriverSigning.FastlyKeyID),
			AkamaiKeyID:         envOr("LIVE_IORIVER_AKAMAI_KEY_ID", ioriverSigning.AkamaiKeyID),
			AkamaiEncryptionKey: envOr("LIVE_IORIVER_AKAMAI_ENCRYPTION_KEY", ioriverSigning.AkamaiEncryptionKey),
		},

		Tracing: tracingConfig{
			UptraceDSN:        os.Getenv("UPTRACE_DSN"),
			SamplingFrequency: os.Getenv("TRACE_SAMPLING_FREQUENCY"),
			TracePrettyPrint:  os.Getenv("TRACE_PRETTY"),
		},
	}
}
