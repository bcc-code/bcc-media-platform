package main

import (
	"os"
	"time"

	"github.com/joho/godotenv"
)

type envConfig struct {
	Port        string
	Environment string

	CDNDomain string
	CacheTTL  time.Duration
	SignTTL   time.Duration

	JWTSecret string
	JWTIssuer string

	Signing signingConfig

	Tracing tracingConfig
}

type signingConfig struct {
	AWSSigningKeyPath   string
	AWSSigningKeyID     string
	FastlySigningKeyID  string
	AkamaiSigningKeyID  string
	AkamaiEncryptionKey string
}

func (c signingConfig) GetAwsSigningKeyPath() string   { return c.AWSSigningKeyPath }
func (c signingConfig) GetAwsSigningKeyID() string     { return c.AWSSigningKeyID }
func (c signingConfig) GetFastlySigningKeyID() string  { return c.FastlySigningKeyID }
func (c signingConfig) GetAkamaiSigningKeyID() string  { return c.AkamaiSigningKeyID }
func (c signingConfig) GetAkamaiEncryptionKey() string { return c.AkamaiEncryptionKey }

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

		CDNDomain: os.Getenv("STREAM_PROXY_CDN_DOMAIN"),
		CacheTTL:  parseDurationOr(os.Getenv("STREAM_PROXY_CACHE_TTL"), 10*time.Minute),
		SignTTL:   parseDurationOr(os.Getenv("STREAM_PROXY_SIGN_TTL"), 6*time.Hour),

		JWTSecret: os.Getenv("JWT_SECRET"),
		JWTIssuer: os.Getenv("JWT_ISSUER"),

		Signing: signingConfig{
			AWSSigningKeyPath:   os.Getenv("CF_SIGNING_KEY_PATH"),
			AWSSigningKeyID:     os.Getenv("CF_SIGNING_KEY_ID"),
			FastlySigningKeyID:  os.Getenv("FASTLY_SIGNING_KEY_ID"),
			AkamaiSigningKeyID:  os.Getenv("AKAMAI_SIGNING_KEY_ID"),
			AkamaiEncryptionKey: os.Getenv("AKAMAI_ENCRYPTION_KEY"),
		},

		Tracing: tracingConfig{
			UptraceDSN:        os.Getenv("UPTRACE_DSN"),
			SamplingFrequency: os.Getenv("TRACE_SAMPLING_FREQUENCY"),
			TracePrettyPrint:  os.Getenv("TRACE_PRETTY"),
		},
	}
}
