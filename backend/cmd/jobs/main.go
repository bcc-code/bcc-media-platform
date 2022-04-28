// This package accepts messages from PUB-SUB and processes them based on certain rules
// The messages it accepts should be in the https://cloudevents.io/ format
package main

import (
	"context"
	"database/sql"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/s3"
	"github.com/bcc-code/brunstadtv/backend/cmd/jobs/server"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/brunstadtv/backend/utils"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/gin-gonic/gin"
	_ "github.com/lib/pq"
	"github.com/rs/zerolog"
	"go.opencensus.io/trace"
	"gopkg.in/guregu/null.v4"
)

func main() {
	ctx := context.Background()

	log.ConfigureGlobalLogger(zerolog.DebugLevel)
	log.L.Debug().Msg("Seting up tracing")

	// Here you can get a tracedHttpClient if useful anywhere
	_ = utils.MustSetupTracing()
	ctx, initTrace := trace.StartSpan(ctx, "init")

	config := getEnvConfig()

	rawDB, err := sql.Open("postgres", config.PG.ConnectionString)
	if err != nil {
		// TODO: Better messages
		panic(err)
	}

	sqlcQueries := sqlc.New(rawDB)

	jobsUserID, err := sqlcQueries.GetUserIDByEmail(ctx, null.StringFrom(config.JobsUserEmail))
	if err != nil {
		// TODO: Better messages
		panic(err)
	}

	serverConfig := server.ConfigData{
		IngestBucket: config.IngestBucket,
		JobsUserID:   jobsUserID.String(),
	}

	sess := session.Must(session.NewSession())
	sess.Config.Region = aws.String(config.AWS["S3"].Region)
	sess.Config.Endpoint = aws.String(config.AWS["S3"].Endpoint)
	s3Client := s3.New(sess)

	log.L.Debug().Msg("Set up HTTP server")
	router := gin.Default()

	handlers := server.NewServer(server.ExternalServices{
		RawDB:    rawDB,
		DB:       sqlcQueries,
		S3Client: s3Client,
	}, serverConfig)

	apiGroup := router.Group("api")
	{
		apiGroup.POST("message", handlers.ProcessMessage)
	}

	zGroup := router.Group("z")
	{
		zGroup.GET("db", handlers.ZDBStatus)
	}

	initTrace.End()

	router.Run(":8078")
}
