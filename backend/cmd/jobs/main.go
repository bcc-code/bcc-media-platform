// This package accepts messages from PUB-SUB and processes them based on certain rules
// The messages it accepts should be in the https://cloudevents.io/ format
package main

import (
	"context"
	"database/sql"

	"github.com/bcc-code/brunstadtv/backend/cmd/jobs/server"
	"github.com/bcc-code/brunstadtv/backend/utils"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/gin-gonic/gin"
	_ "github.com/lib/pq"
	"github.com/rs/zerolog"
	"go.opencensus.io/trace"
)

func main() {
	ctx := context.Background()

	log.ConfigureGlobalLogger(zerolog.DebugLevel)
	log.L.Debug().Msg("Seting up tracing")

	// Here you can get a tracedHttpClient if useful anywhere
	_ = utils.MustSetupTracing()

	// TODO: Proper auth and SSL verification for prod
	rawDB, err := sql.Open("postgres", "user=btv dbname=btv sslmode=disable")
	if err != nil {
		// TODO: Better messages
		panic(err)
	}

	ctx, initTrace := trace.StartSpan(ctx, "init")

	log.L.Debug().Msg("Set up HTTP server")

	router := gin.Default()

	server := server.NewServer(rawDB)

	apiGroup := router.Group("api")
	{
		apiGroup.POST("ingest-vod", server.IngestVod)
	}

	zGroup := router.Group("z")
	{
		zGroup.GET("db", server.ZDBStatus)
	}

	initTrace.End()

	router.Run(":8078")
}
