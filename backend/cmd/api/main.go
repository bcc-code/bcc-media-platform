package main

import (
	"context"
	"database/sql"
	"errors"
	"github.com/99designs/gqlgen/graphql/handler"
	"github.com/99designs/gqlgen/graphql/playground"
	"github.com/bcc-code/brunstadtv/backend/auth0"
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

	log.L.Debug().Msgf("connect to http://localhost:%s/ for GraphQL playground", config.Port)

	searchService := search.New(config.Algolia.AppId, config.Algolia.ApiKey, db)

	searchGroup := r.Group("search")
	searchGroup.POST("query", searchQueryHandler(&searchService))

	// Hooks and scheduling for search indexing
	if config.SchedulerSecret != "" {
		log.L.Debug().Msg("Setting up endpoint for scheduled search indexing")
		searchGroup.GET("index", searchIndexHandler(config.SchedulerSecret, &searchService))
	} else {
		log.L.Debug().Msg("Missing secret for scheduler endpoint, skipping endpoint configuration")
	}

	if config.DirectusSecret != "" {
		log.L.Debug().Msg("Setting up endpoint for webhooks from Directus")
		r.POST("/directus/webhook", directusEventHandler(config.DirectusSecret, &searchService))
	} else {
		log.L.Debug().Msg("Missing secret for webhooks from Directus, skipping endpoint configuration")
	}

	span.End()

	err = r.Run(":" + config.Port)
	if err != nil {
		return
	}
}
