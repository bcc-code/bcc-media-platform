// This package accepts messages from PUB-SUB and processes them based on certain rules
// The messages it accepts should be in the https://cloudevents.io/ format
package main

import (
	"context"
	awsSDKConfig "github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/mediapackagevod"
	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/bcc-code/bcc-media-platform/backend/auth0"
	"github.com/bcc-code/bcc-media-platform/backend/cmd/jobs/server"
	"github.com/bcc-code/bcc-media-platform/backend/events"
	"github.com/bcc-code/bcc-media-platform/backend/files"
	"github.com/bcc-code/bcc-media-platform/backend/loaders"
	"github.com/bcc-code/bcc-media-platform/backend/log"
	"github.com/bcc-code/bcc-media-platform/backend/members"
	"github.com/bcc-code/bcc-media-platform/backend/notifications"
	"github.com/bcc-code/bcc-media-platform/backend/push"
	"github.com/bcc-code/bcc-media-platform/backend/remotecache"
	"github.com/bcc-code/bcc-media-platform/backend/scheduler"
	"github.com/bcc-code/bcc-media-platform/backend/search"
	"github.com/bcc-code/bcc-media-platform/backend/signing"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/bcc-code/bcc-media-platform/backend/statistics"
	"github.com/bcc-code/bcc-media-platform/backend/translations"
	"github.com/bcc-code/bcc-media-platform/backend/translations/phrase"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"github.com/bcc-code/bcc-media-platform/backend/version"
	"github.com/bcc-code/bcc-media-platform/backend/videomanipulator"
	"github.com/bsm/redislock"
	"github.com/gin-gonic/gin"
	_ "github.com/lib/pq"
	"github.com/rs/zerolog"
	"github.com/sony/gobreaker"
	"go.opentelemetry.io/otel"
)

func main() {
	ctx := context.Background()

	log.ConfigureGlobalLogger(zerolog.DebugLevel)
	log.L.Debug().Msg("Setting up tracing!")

	config := getEnvConfig()

	utils.MustSetupTracing("BTV-WORKER", config.Tracing)
	ctx, span := otel.Tracer("jobs/core").Start(ctx, "init")

	serverConfig := server.ConfigData{
		IngestBucket:          config.AWS.IngestBucket,
		StorageBucket:         config.AWS.StorageBucket,
		TempBucket:            config.AWS.TempBucket,
		PackagingGroupID:      config.AWS.PackagingGroupARN,
		MediapackageRole:      config.AWS.MediapackageRoleARN,
		MediapackageSource:    config.AWS.MediapackageSourceARN,
		DeleteIngestFilesFlag: config.DeleteIngestFiles,
	}

	awsConfig, err := awsSDKConfig.LoadDefaultConfig(ctx)
	if err != nil {
		log.L.Panic().Err(err).Msg("Failed to load AWS config")
	}

	awsConfig.Region = config.AWS.Region

	s3Client := s3.NewFromConfig(awsConfig)
	mediaPackageVOD := mediapackagevod.NewFromConfig(awsConfig)

	rdb, rdbChan := utils.MustCreateRedisClient(ctx, config.Redis)
	db, dbChan := utils.MustCreateDBClient(ctx, config.DB)

	queries := sqlc.New(db)
	queries.SetImageCDNDomain(config.ImageCDNDomain)

	searchService := search.New(queries, config.Search)
	eventHandler := events.NewHandler()
	statisticsHandler := statistics.NewHandler(ctx, config.BigQuery, queries)

	phraseClient := phrase.NewClient(rdb, config.Phrase)
	phraseClient.SetDebug(config.Phrase.Debug)
	err = phraseClient.Authenticate()
	if err != nil {
		log.L.Panic().Err(err).Msg("Failed to authenticate phrase")
	}
	translationsClient := translations.NewService(queries, phraseClient)

	sr := scheduler.New(config.ServiceUrl+"/api/tasks", config.CloudTasks.QueueID)

	pushService, err := push.NewService(ctx, config.Firebase.ProjectID, queries)
	if err != nil {
		log.L.Panic().Err(err).Msg("Failed to initialize push service")
		return
	}

	authClient := auth0.New(config.Auth0)

	breaker := gobreaker.NewCircuitBreaker(gobreaker.Settings{
		Name: "Members",
	})
	membersClient := members.New(config.Members, authClient, breaker)
	notificationUtils := notifications.NewUtils(queries)

	videomanipulatorService := videomanipulator.NewVideoManipulatorService(config.VideoManipulator.baseURL, config.VideoManipulator.apiKey)

	mh := &modelHandler{
		scheduler:         sr,
		push:              pushService,
		queries:           queries,
		remoteCache:       remotecache.New(rdb, redislock.New(rdb)),
		members:           membersClient,
		notificationUtils: notificationUtils,
	}

	sr.OnRequest(func(ctx context.Context, item scheduler.QueuedItem) error {
		return mh.handleModelUpdate(ctx, item.Collection, item.ID)
	})

	eventService, err := events.NewService(ctx, config.Firebase.ProjectID, queries)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to initialize event service, disabling")
	} else {
		eventHandler.On([]string{events.EventItemsCreate, events.EventItemsUpdate}, eventService.HandleModelUpdate)
	}

	eventHandler.On([]string{events.EventItemsCreate, events.EventItemsUpdate}, mh.handleModelUpdate)
	eventHandler.On([]string{events.EventItemsCreate, events.EventItemsUpdate}, searchService.IndexModel)
	eventHandler.On([]string{events.EventItemsDelete}, searchService.DeleteModel)

	if statisticsHandler != nil {
		log.L.Info().Msg("Registering BQ handler")
		// If we are unable to initialize BQ then we do not listen
		// Warning is emitted in the statistics.NewDirectusHandler call
		eventHandler.On([]string{events.EventItemsCreate, events.EventItemsUpdate, events.EventItemsDelete}, statisticsHandler.HandleDirectusEvent)
	}

	log.L.Debug().Msg("Set up HTTP server")
	router := gin.Default()

	locker := redislock.New(rdb)

	fileService, err := files.NewAzureFileService(queries, config.AzureStorage)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to initialize azure file service")
		return
	}

	urlSigner, err := signing.NewSigner(config.CDNConfig)
	if err != nil {
		log.L.Error().Err(err).Send()
	}

	services := server.ExternalServices{
		Database:                db,
		S3Client:                s3Client,
		MediaPackageVOD:         mediaPackageVOD,
		SearchService:           searchService,
		EventHandler:            eventHandler,
		Queries:                 queries,
		RemoteCache:             remotecache.New(rdb, locker),
		Scheduler:               sr,
		StatisticsHandler:       statisticsHandler,
		FileService:             fileService,
		VideoManipulatorService: videomanipulatorService,
		TranslationsService:     translationsClient,
		CDNConfigProvider:       config.CDNConfig,
		BatchLoaders:            loaders.InitBatchLoaders(queries, nil),
		URLSigner:               urlSigner,
	}

	handlers := server.NewServer(services, serverConfig)

	apiGroup := router.Group("api")
	{
		apiGroup.POST("message", handlers.ProcessMessage)
		apiGroup.POST("aws", handlers.ProcessAwsMessage)
		apiGroup.POST("eventmeta", handlers.IngestEventMeta) // TODO: Protect the endpoint with a simple api key or something
		apiGroup.POST("tasks", handlers.ProcessScheduledTask)
		apiGroup.POST("translations", handlers.ProcessTranslationMessage)
	}

	router.GET("/versionz", version.GinHandler)

	err = <-dbChan
	if err != nil {
		panic(err)
	}

	err = <-rdbChan
	if err != nil {
		panic(err)
	}

	span.End()

	err = router.Run(":" + config.Port)
	if err != nil {
		log.L.Error().Err(err).Msg("Couldn't start server")
		return
	}
}
