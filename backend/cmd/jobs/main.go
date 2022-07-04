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
	"github.com/bcc-code/brunstadtv/backend/crowdin"
	"github.com/bcc-code/brunstadtv/backend/directus"
	"github.com/bcc-code/brunstadtv/backend/search"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/brunstadtv/backend/utils"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/gin-gonic/gin"
	"github.com/go-resty/resty/v2"
	_ "github.com/lib/pq"
	"github.com/rs/zerolog"
	"go.opentelemetry.io/otel"
)

const debugDirectus = false

func initializeDirectusEventHandler(directusClient *resty.Client, searchService *search.Service, crowdinClient *crowdin.Client) *directus.EventHandler {
	eventHandler := directus.NewEventHandler()

	for _, event := range []string{directus.EventItemsCreate, directus.EventItemsUpdate} {
		eventHandler.On(event, func(ctx context.Context, collection string, id int) {
			err := searchService.IndexModel(ctx, collection, id)
			if err != nil {
				log.L.Error().Err(err).Msg("failed to index model for search")
				return
			}

			directusHandler := directus.NewHandler(directusClient)
			err = crowdinClient.HandleModelUpdate(ctx, directusHandler, collection, id)
			if err != nil {
				log.L.Error().Err(err).Msg("failed to handle model for crowdin")
				return
			}
		})
	}

	eventHandler.On(directus.EventItemsDelete, func(ctx context.Context, collection string, id int) {
		searchService.DeleteModel(collection, id)
		crowdinClient.HandleModelDelete(collection, id)
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
		CrowdinProjectIDs:  config.Crowdin.ProjectIDs,
		CrowdinToken:       config.Crowdin.Token,
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

	searchService := search.New(db, config.Algolia.AppId, config.Algolia.ApiKey, config.Algolia.SearchOnlyApiKey)
	crowdinClient := crowdin.New(config.Crowdin.Token, crowdin.ClientConfig{ProjectIDs: config.Crowdin.ProjectIDs})
	directusEventHandler := initializeDirectusEventHandler(directusClient, searchService, crowdinClient)

	log.L.Debug().Msg("Set up HTTP server")
	router := gin.Default()

	handlers := server.NewServer(server.ExternalServices{
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
	}

	span.End()

	err = router.Run(":" + config.Port)
	if err != nil {
		log.L.Error().Err(err).Msg("Couldn't start server")
		return
	}
}
