package main

import (
	"context"
	"database/sql"
	"errors"
	"github.com/99designs/gqlgen/graphql/handler"
	"github.com/99designs/gqlgen/graphql/playground"
	"github.com/bcc-code/brunstadtv/backend/auth0"
	"github.com/bcc-code/brunstadtv/backend/base"
	"github.com/bcc-code/brunstadtv/backend/directus"
	"github.com/bcc-code/brunstadtv/backend/graph"
	"github.com/bcc-code/brunstadtv/backend/graph/generated"
	"github.com/bcc-code/brunstadtv/backend/search"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/brunstadtv/backend/utils"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/gin-gonic/gin"
	_ "github.com/lib/pq"
	"github.com/rs/zerolog"
	"go.opentelemetry.io/contrib/instrumentation/github.com/gin-gonic/gin/otelgin"
	"go.opentelemetry.io/otel"
)

// Defining the Graphql handler
func graphqlHandler(queries *sqlc.Queries) gin.HandlerFunc {

	resolver := graph.Resolver{
		Queries: queries,
	}

	// NewExecutableSchema and Config are in the generated.go file
	// Resolver is in the resolver.go file
	h := handler.NewDefaultServer(generated.NewExecutableSchema(generated.Config{Resolvers: &resolver}))

	return func(c *gin.Context) {
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

func indexHandler(apiKey string, client base.ISearchService) func(*gin.Context) {
	return func(c *gin.Context) {
		err := authenticateRequestWithXApiKey(apiKey, c)
		if err != nil {
			log.L.Error().Err(err).Msg("Failed to authenticate request")
			return
		}
		client.Reindex()
		_, _ = c.Writer.WriteString("Indexed all documents")
	}
}

func searchHandler(client base.ISearchService) func(*gin.Context) {
	return func(c *gin.Context) {
		var query base.SearchQuery
		// define default options
		query.Page = 0
		err := c.BindJSON(&query)
		if err != nil {
			log.L.Error().Err(err)
		}
		searchHandler := client.GetHandler("not a user but its a user")
		r, err := searchHandler.Search(&query)

		if err != nil {
			log.L.Error().Err(err).Msg("Searching failed")
			c.JSON(500, map[string]string{
				"error": "search failed",
			})
			return
		}

		c.JSON(200, r)
	}
}

func authenticateRequestWithXApiKey(apiKey string, c *gin.Context) error {
	a := c.Request.Header.Get("X-API-Key")
	if a == apiKey {
		return nil
	}

	var err error
	if a == "" {
		err = errors.New("missing x-api-key header")
	} else {
		err = errors.New("failed to authenticate")
	}

	c.Status(401)
	_, _ = c.Writer.WriteString("Unauthorized")

	return err
}

func directusEventHandler(apiKey string, searchService base.ISearchService) func(c *gin.Context) {
	eventHandler := directus.NewEventHandler()

	indexEvents := []string{directus.EventItemsCreate, directus.EventItemsUpdate}
	eventHandler.On(indexEvents, searchService.IndexModel)

	deleteEvents := []string{directus.EventItemsDelete}
	eventHandler.On(deleteEvents, searchService.DeleteModel)

	return func(c *gin.Context) {
		err := authenticateRequestWithXApiKey(apiKey, c)
		if err != nil {
			log.L.Error().Err(err).Msg("Failed to authenticate")
			return
		}
		eventHandler.Execute(c)
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

	log.L.Debug().Msg("Set up HTTP server")
	r := gin.Default()
	r.Use(graph.GinContextToContextMiddleware())
	r.Use(otelgin.Middleware("api")) // OpenTelemetry
	r.Use(auth0.JWT(ctx, config.JWTConfig))

	queries := sqlc.New(db)

	r.POST("/query", graphqlHandler(queries))

	// TODO: Should we have this in non-local envs?
	// What about auth?
	r.GET("/", playgroundHandler())

	// Hooks and scheduling for search indexing
	searchService := search.New(config.Algolia.AppId, config.Algolia.ApiKey, db)
	if config.SchedulerSecret != "" {
		log.L.Debug().Msg("Setting up endpoint for scheduled search indexing")
		r.GET("/search/index", indexHandler(config.SchedulerSecret, &searchService))
	} else {
		log.L.Debug().Msg("Missing secret for scheduler endpoint, skipping endpoint configuration")
	}

	if config.DirectusSecret != "" {
		log.L.Debug().Msg("Setting up endpoint for webhooks from Directus")
		r.POST("/directus/webhook", directusEventHandler(config.DirectusSecret, &searchService))
	} else {
		log.L.Debug().Msg("Missing secret for webhooks from Directus, skipping endpoint configuration")
	}
	r.POST("/search/query", searchHandler(&searchService))

	log.L.Debug().Msgf("connect to http://localhost:%s/ for GraphQL playground", config.Port)

	span.End()

	err = r.Run(":" + config.Port)
	if err != nil {
		return
	}
}
