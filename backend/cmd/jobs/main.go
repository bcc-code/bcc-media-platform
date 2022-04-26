// This package accepts messages from PUB-SUB and processes them based on certain rules
// The messages it accepts should be in the https://cloudevents.io/ format
package main

import (
	"context"

	"github.com/bcc-code/brunstadtv/backend/cmd/jobs/server"
	"github.com/bcc-code/brunstadtv/backend/utils"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/gin-gonic/gin"
	"github.com/rs/zerolog"
	"go.opencensus.io/trace"
)

func main() {
	ctx := context.Background()

	log.ConfigureGlobalLogger(zerolog.DebugLevel)
	log.L.Debug().Msg("Seting up tracing")

	// Here you can get a tracedHttpClient if useful anywhere
	_ = utils.MustSetupTracing()

	ctx, initTrace := trace.StartSpan(ctx, "init")

	log.L.Debug().Msg("Set up HTTP server")

	router := gin.Default()

	server := server.NewServer()

	apiGroup := router.Group("api")
	{
		apiGroup.POST("ingest-vod", server.IngestVod)
	}

	initTrace.End()
}
