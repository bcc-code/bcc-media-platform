// This package accepts messages from PUB-SUB and processes them based on certain rules
// The messages it accepts should be in the https://cloudevents.io/ format
package main

import (
	"context"
	"database/sql"
	"github.com/bcc-code/brunstadtv/backend/events"
	"github.com/bcc-code/brunstadtv/backend/push"
	"github.com/bcc-code/brunstadtv/backend/version"

	awsSDKConfig "github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/mediapackagevod"
	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/bcc-code/brunstadtv/backend/cmd/jobs/server"
	"github.com/bcc-code/brunstadtv/backend/crowdin"
	"github.com/bcc-code/brunstadtv/backend/directus"
	"github.com/bcc-code/brunstadtv/backend/search"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/brunstadtv/backend/utils"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/gin-gonic/gin"
	_ "github.com/lib/pq"
	"github.com/rs/zerolog"
	"go.opentelemetry.io/otel"
)

const debugDirectus = false

func main() {
	ctx := context.Background()

	log.ConfigureGlobalLogger(zerolog.DebugLevel)
	log.L.Debug().Msg("Setting up tracing!")

	utils.MustSetupTracing()
	ctx, span := otel.Tracer("jobs/core").Start(ctx, "init")

	config := getEnvConfig()

	serverConfig := server.ConfigData{
		IngestBucket:          config.AWS.IngestBucket,
		StorageBucket:         config.AWS.StorageBucket,
		PackagingGroupID:      config.AWS.PackagingGroupARN,
		MediapackageRole:      config.AWS.MediapackageRoleARN,
		MediapackageSource:    config.AWS.MediapackageSourceARN,
		CrowdinProjectIDs:     config.Crowdin.ProjectIDs,
		CrowdinToken:          config.Crowdin.Token,
		DeleteIngestFilesFlag: config.DeleteIngestFiles,
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
	db.SetMaxIdleConns(2)
	// TODO: What makes sense here? We should gather some metrics over time
	db.SetMaxOpenConns(10)

	err = db.PingContext(ctx)
	if err != nil {
		log.L.Panic().Err(err).Msg("Ping failed")
		return
	}

	queries := sqlc.New(db)
	queries.SetImageCDNDomain(config.ImageCDNDomain)

	searchService := search.New(db, config.Algolia)
	directusEventHandler := directus.NewEventHandler()
	crowdinClient := crowdin.New(config.Crowdin, directus.NewHandler(directusClient), queries)
	pushService, err := push.NewService(ctx, config.Firebase.ProjectID, queries)
	if err != nil {
		log.L.Panic().Err(err).Msg("Failed to initialize push service")
	} else {
		directusEventHandler.On([]string{directus.EventItemsCreate, directus.EventItemsUpdate}, pushService.HandleModelUpdate)
	}

	eventService, err := events.NewService(ctx, config.Firebase.ProjectID)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to initialize event service, disabling")
	} else {
		directusEventHandler.On([]string{directus.EventItemsCreate, directus.EventItemsUpdate}, eventService.HandleModelUpdate)
	}

	directusEventHandler.On([]string{directus.EventItemsCreate, directus.EventItemsUpdate}, searchService.IndexModel)
	directusEventHandler.On([]string{directus.EventItemsCreate, directus.EventItemsUpdate}, crowdinClient.HandleModelUpdate)

	directusEventHandler.On([]string{directus.EventItemsDelete}, searchService.DeleteModel)
	directusEventHandler.On([]string{directus.EventItemsDelete}, crowdinClient.HandleModelDelete)

	log.L.Debug().Msg("Set up HTTP server")
	router := gin.Default()

	handlers := server.NewServer(server.ExternalServices{
		Database:             db,
		S3Client:             s3Client,
		MediaPackageVOD:      mediaPackageVOD,
		DirectusClient:       directusClient,
		SearchService:        searchService,
		DirectusEventHandler: directusEventHandler,
		Queries:              queries,
		CrowdinClient:        crowdinClient,
	}, serverConfig)

	apiGroup := router.Group("api")
	{
		apiGroup.POST("message", handlers.ProcessMessage)
		apiGroup.POST("aws", handlers.ProcessAwsMessage)
		apiGroup.POST("eventmeta", handlers.IngestEventMeta) // TODO: Protect the endpoint with a simple api key or soimething
	}

	router.GET("/versionz", version.GinHandler)

	span.End()

	err = router.Run(":" + config.Port)
	if err != nil {
		log.L.Error().Err(err).Msg("Couldn't start server")
		return
	}
}
