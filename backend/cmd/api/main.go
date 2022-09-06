package main

import (
	"context"
	"crypto/rsa"
	"database/sql"
	"github.com/99designs/gqlgen/graphql/handler"
	"github.com/99designs/gqlgen/graphql/playground"
	"github.com/aws/aws-sdk-go/service/cloudfront/sign"
	"github.com/bcc-code/brunstadtv/backend/asset"
	"github.com/bcc-code/brunstadtv/backend/auth0"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/graph"
	"github.com/bcc-code/brunstadtv/backend/graph/generated"
	gqladmin "github.com/bcc-code/brunstadtv/backend/graphadmin"
	gqladmingenerated "github.com/bcc-code/brunstadtv/backend/graphadmin/generated"
	"github.com/bcc-code/brunstadtv/backend/items/collection"
	"github.com/bcc-code/brunstadtv/backend/items/episode"
	"github.com/bcc-code/brunstadtv/backend/items/page"
	"github.com/bcc-code/brunstadtv/backend/items/season"
	"github.com/bcc-code/brunstadtv/backend/items/section"
	"github.com/bcc-code/brunstadtv/backend/items/show"
	"github.com/bcc-code/brunstadtv/backend/search"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/brunstadtv/backend/user"
	"github.com/bcc-code/brunstadtv/backend/utils"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	_ "github.com/lib/pq"
	"github.com/rs/zerolog"
	"go.opentelemetry.io/contrib/instrumentation/github.com/gin-gonic/gin/otelgin"
	"go.opentelemetry.io/otel"
)

// Defining the Graphql handler
func graphqlHandler(queries *sqlc.Queries, loaders *common.BatchLoaders, searchService *search.Service, urlSigner *sign.URLSigner, config envConfig) gin.HandlerFunc {

	resolver := graph.Resolver{
		Queries:       queries,
		Loaders:       loaders,
		SearchService: searchService,
		APIConfig:     config.CDNConfig,
		URLSigner:     urlSigner,
	}

	// NewExecutableSchema and Config are in the generated.go file
	// Resolver is in the resolver.go file
	h := handler.NewDefaultServer(generated.NewExecutableSchema(generated.Config{Resolvers: &resolver}))

	return func(c *gin.Context) {
		h.ServeHTTP(c.Writer, c.Request)
	}
}

func adminGraphqlHandler(config envConfig, db *sql.DB, queries *sqlc.Queries, loaders *common.BatchLoaders) gin.HandlerFunc {

	resolver := gqladmin.Resolver{
		DB:      db,
		Queries: queries,
		Loaders: loaders,
	}

	// NewExecutableSchema and Config are in the generated.go file
	// Resolver is in the resolver.go file
	h := handler.NewDefaultServer(gqladmingenerated.NewExecutableSchema(gqladmingenerated.Config{Resolvers: &resolver}))

	directusSecret := config.Secrets.Directus
	if directusSecret == "" {
		log.L.Debug().Msg("No secret for Directus found in environment. Disabling endpoint")
		return func(c *gin.Context) {
			c.AbortWithStatus(404)
			return
		}
	}

	return func(c *gin.Context) {
		headerValue := c.GetHeader("x-api-key")
		if headerValue != directusSecret {
			c.AbortWithStatus(403)
			return
		}

		h.ServeHTTP(c.Writer, c.Request)
	}
}

// Defining the Playground handler
func playgroundHandler() gin.HandlerFunc {
	h := playground.Handler("GraphQL", "/query")

	return func(c *gin.Context) {
		h.ServeHTTP(c.Writer, c.Request)
	}
}

func main() {
	ctx := context.Background()

	log.ConfigureGlobalLogger(zerolog.DebugLevel)
	log.L.Debug().Msg("Setting up tracing!")

	// Here you can get a tracedHttpClient if useful anywhere
	utils.MustSetupTracing()
	ctx, span := otel.Tracer("api/core").Start(ctx, "init")

	config := getEnvConfig()
	log.L.Debug().Str("DBConnString", config.DB.ConnectionString).Msg("Connection to DB")
	db, err := sql.Open("postgres", config.DB.ConnectionString)
	if err != nil {
		log.L.Panic().Err(err).Msg("Unable to connect to DB")
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

	collectionLoader := common.NewBatchLoader(queries.GetCollections)
	// Set up urlSigner for CDN urls access
	var key *rsa.PrivateKey
	key, err = sign.LoadPEMPrivKeyFile(config.CDNConfig.AWSSigningKeyPath)
	if err != nil {
		log.L.Error().Err(err).Msg("Unable to load PEM file")
	}
	urlSigner := sign.NewURLSigner(config.CDNConfig.AWSSigningKeyID, key)

	loaders := &common.BatchLoaders{
		// Item
		PageLoader:              common.NewBatchLoader(queries.GetPages),
		PageIDFromCodeLoader:    common.NewConversionBatchLoader(queries.GetPageIDsForCodes),
		SectionLoader:           common.NewBatchLoader(queries.GetSections),
		ShowLoader:              common.NewBatchLoader(queries.GetShows),
		SeasonLoader:            common.NewBatchLoader(queries.GetSeasons),
		EpisodeLoader:           common.NewBatchLoader(queries.GetEpisodes),
		EventLoader:             common.NewBatchLoader(queries.GetEvents),
		CalendarEntryLoader:     common.NewBatchLoader(queries.GetCalendarEntries),
		FilesLoader:             asset.NewBatchFilesLoader(*queries),
		StreamsLoader:           asset.NewBatchStreamsLoader(*queries),
		CollectionLoader:        collectionLoader,
		CollectionItemIdsLoader: collection.NewCollectionItemIdsLoader(db, collectionLoader),
		CollectionItemLoader:    collection.NewItemListBatchLoader(*queries),
		ImageFileLoader:         common.NewBatchLoader(queries.GetFiles),
		// Relations
		SeasonsLoader:  common.NewRelationBatchLoader(queries.GetSeasonIDsForShows),
		EpisodesLoader: common.NewRelationBatchLoader(queries.GetEpisodeIDsForSeasons),
		SectionsLoader: common.NewRelationBatchLoader(queries.GetSectionIDsForPages),
		// Permissions
		ShowPermissionLoader:    show.NewPermissionLoader(*queries),
		SeasonPermissionLoader:  season.NewPermissionLoader(*queries),
		EpisodePermissionLoader: episode.NewPermissionLoader(*queries),
		PagePermissionLoader:    page.NewPermissionLoader(*queries),
		SectionPermissionLoader: section.NewPermissionLoader(*queries),
		FAQCategoryLoader:       common.NewBatchLoader(queries.GetFAQCategories),
		QuestionLoader:          common.NewBatchLoader(queries.GetQuestions),
		QuestionsLoader:         common.NewRelationBatchLoader(queries.GetQuestionIDsForCategories),
	}

	authClient := auth0.New(config.JWTConfig)

	log.L.Debug().Msg("Set up HTTP server")
	r := gin.Default()
	r.Use(utils.GinContextToContextMiddleware())
	r.Use(cors.New(cors.Config{
		AllowAllOrigins:  true,
		AllowMethods:     []string{"POST", "GET"},
		AllowHeaders:     []string{"content-type", "authorization", "accept-language"},
		AllowCredentials: true,
	}))
	r.Use(otelgin.Middleware("api")) // Open
	r.Use(authClient.EnsureValidToken())
	r.Use(user.NewUserMiddleware(queries, authClient))

	searchService := search.New(db, config.Algolia.AppId, config.Algolia.ApiKey)
	r.POST("/query", graphqlHandler(queries, loaders, searchService, urlSigner, config))

	r.GET("/", playgroundHandler())

	r.POST("/admin", adminGraphqlHandler(config, db, queries, loaders))

	log.L.Debug().Msgf("connect to http://localhost:%s/ for GraphQL playground", config.Port)

	span.End()

	err = r.Run(":" + config.Port)
	if err != nil {
		return
	}
}
