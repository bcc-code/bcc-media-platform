// This package accepts messages from PUB-SUB and processes them based on certain rules
// The messages it accepts should be in the https://cloudevents.io/ format
package main

import (
	"context"
	"database/sql"
	awsSDKConfig "github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/mediapackagevod"
	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/bcc-code/brunstadtv/backend/cmd/jobs/server"
	"github.com/bcc-code/brunstadtv/backend/directus"
	"github.com/bcc-code/brunstadtv/backend/search"
	"github.com/bcc-code/brunstadtv/backend/utils"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/gin-gonic/gin"
	_ "github.com/lib/pq"
	"github.com/rs/zerolog"
	"go.opentelemetry.io/otel"
)

const debugDirectus = false

func initializeDirectusEventHandler(searchService *search.Service) *directus.EventHandler {
	eventHandler := directus.NewEventHandler()

	indexEvents := []string{directus.EventItemsCreate, directus.EventItemsUpdate}

	eventHandler.On(indexEvents, func(ctx context.Context, model string, id int) {
		handler := searchService.NewRequestHandler(ctx)
		handler.IndexModel(model, id)
	})

	deleteEvents := []string{directus.EventItemsDelete}
	eventHandler.On(deleteEvents, func(ctx context.Context, model string, id int) {
		handler := searchService.NewRequestHandler(ctx)
		handler.DeleteModel(model, id)
	})

	return eventHandler
}

func main() {
	ctx := context.Background()

	log.ConfigureGlobalLogger(zerolog.DebugLevel)
	log.L.Debug().Msg("Setting up tracing!")

	utils.MustSetupTracing()
	ctx, span := otel.Tracer("jobs/core").Start(ctx, "init")

	config := getEnvConfig()

	serverConfig := server.ConfigData{
		IngestBucket:       config.AWS.IngestBucket,
		StorageBucket:      config.AWS.StorageBucket,
		PackagingGroupID:   config.AWS.PackagingGroupARN,
		MediapackageRole:   config.AWS.MediapackageRoleARN,
		MediapackageSource: config.AWS.MediapackageSourceARN,
	}

	awsConfig, err := awsSDKConfig.LoadDefaultConfig(ctx)
	if err != nil {
		// TODO: Better messages
		panic(err)
	}

	awsConfig.Region = config.AWS.Region

	s3Client := s3.NewFromConfig(awsConfig)
	mediaPackageVOD := mediapackagevod.NewFromConfig(awsConfig)

	directusClient := directus.New(config.Directus.BaseURL, config.Directus.Key, debugDirectus)

	db, err := sql.Open("postgres", config.DB.ConnectionString)
	if err != nil {
		log.L.Error().Err(err)
		return
	}

	searchService := search.New(db, config.Algolia.AppId, config.Algolia.ApiKey, config.Algolia.SearchOnlyApiKey)
	directusEventHandler := initializeDirectusEventHandler(searchService)

	log.L.Debug().Msg("Set up HTTP server")
	router := gin.Default()

	handlers := server.NewServer(server.ExternalServices{
		S3Client:             s3Client,
		MediaPackageVOD:      mediaPackageVOD,
		DirectusClient:       directusClient,
		SearchService:        searchService,
		DirectusEventHandler: directusEventHandler,
	}, serverConfig)

	apiGroup := router.Group("api")
	{
		apiGroup.POST("message", handlers.ProcessMessage)
	}

	span.End()
	err = router.Run(":" + config.Port)
	if err != nil {
		log.L.Error().Err(err).Msg("Couldn't start server")
		return
	}
}
