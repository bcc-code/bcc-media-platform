package main

import (
	"net/http"
	"time"

	"github.com/bcc-code/bcc-media-platform/backend/log"
	"github.com/bcc-code/bcc-media-platform/backend/signing"
	"github.com/gin-gonic/gin"
	"github.com/rs/zerolog"
)

func main() {
	log.ConfigureGlobalLogger(zerolog.InfoLevel)

	cfg := getEnvConfig()

	if cfg.CDNDomain == "" {
		log.L.Fatal().Msg("STREAM_PROXY_CDN_DOMAIN is required")
	}
	if cfg.JWTSecret == "" {
		log.L.Fatal().Msg("JWT_SECRET is required")
	}

	signer, err := signing.NewSigner(cfg.Signing)
	if err != nil {
		log.L.Fatal().Err(err).Msg("failed to init signer")
	}

	validator, err := newJWTValidator(cfg.JWTSecret, cfg.JWTIssuer)
	if err != nil {
		log.L.Fatal().Err(err).Msg("failed to init jwt validator")
	}

	httpc := &http.Client{Timeout: 10 * time.Second}

	handler := newProxyHandler(validator, signer, httpc, cfg)

	if cfg.Environment != "development" {
		gin.SetMode(gin.ReleaseMode)
	}
	r := gin.New()
	r.Use(gin.Logger(), gin.Recovery())
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
