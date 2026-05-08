package main

import (
	"net/http"
	"os"
	"time"

	"github.com/bcc-code/bcc-media-platform/backend/log"
	"github.com/bcc-code/bcc-media-platform/backend/signing"
	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	"github.com/rs/zerolog"
)

func main() {
	log.ConfigureGlobalLogger(zerolog.InfoLevel)

	cfg := getEnvConfig()

	if cfg.CDNDomainCloudFront == "" {
		log.L.Fatal().Msg("STREAM_PROXY_CDN_DOMAIN_CLOUDFRONT is required")
	}
	if cfg.CDNDomainIoriver == "" {
		log.L.Fatal().Msg("STREAM_PROXY_CDN_DOMAIN_IORIVER is required")
	}
	if cfg.JWTSecret == "" {
		log.L.Fatal().Msg("JWT_SECRET is required")
	}
	if !cfg.DefaultProvider.Valid() {
		log.L.Fatal().Str("value", os.Getenv("STREAM_PROXY_DEFAULT_PROVIDER")).Msg(`STREAM_PROXY_DEFAULT_PROVIDER must be "cloudfront" or "ioriver"`)
	}
	if cfg.CloudFrontSigning.KeyPath == "" {
		log.L.Fatal().Msg("CF_SIGNING_KEY_PATH is required")
	}
	if cfg.IoriverSigning.KeyPath == "" {
		log.L.Fatal().Msg("IORIVER_SIGNING_KEY_PATH is required")
	}

	cfSigner, err := signing.NewSigner(cfg.CloudFrontSigning)
	if err != nil {
		log.L.Fatal().Err(err).Msg("failed to init cloudfront signer")
	}
	ioriverSigner, err := signing.NewSigner(cfg.IoriverSigning)
	if err != nil {
		log.L.Fatal().Err(err).Msg("failed to init ioriver signer")
	}

	validator, err := newJWTValidator(cfg.JWTSecret, cfg.JWTIssuer)
	if err != nil {
		log.L.Fatal().Err(err).Msg("failed to init jwt validator")
	}

	httpc := &http.Client{Timeout: 10 * time.Second}

	handler := newProxyHandler(validator, cfSigner, ioriverSigner, httpc, cfg)

	if cfg.Environment != "development" {
		gin.SetMode(gin.ReleaseMode)
	}
	r := gin.New()
	r.Use(gin.Logger(), gin.Recovery())
	r.Use(cors.New(cors.Config{
		AllowAllOrigins: true,
		AllowMethods:    []string{http.MethodGet, http.MethodOptions},
		AllowHeaders:    []string{"Range"},
	}))
	r.NoRoute(handler.handle)

	port := cfg.Port
	if port == "" {
		port = "8081"
	}
	log.L.Info().Str("port", port).Msg("stream-proxy listening")
	if err := r.Run(":" + port); err != nil {
		log.L.Fatal().Err(err).Msg("server exited")
	}
}
