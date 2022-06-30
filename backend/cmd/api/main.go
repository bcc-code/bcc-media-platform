package main

import (
	"context"
	"database/sql"

	"github.com/99designs/gqlgen/graphql/handler"
	"github.com/99designs/gqlgen/graphql/playground"
	"github.com/bcc-code/brunstadtv/backend/auth0"
	"github.com/bcc-code/brunstadtv/backend/crowdin"
	"github.com/bcc-code/brunstadtv/backend/directus"
	"github.com/bcc-code/brunstadtv/backend/graph"
	"github.com/bcc-code/brunstadtv/backend/graph/generated"
	"github.com/bcc-code/brunstadtv/backend/search"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/brunstadtv/backend/user"
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

	log.L.Debug().Msg("Set up HTTP server")
	r := gin.Default()
	r.Use(graph.GinContextToContextMiddleware())
	r.Use(otelgin.Middleware("api")) // OpenTelemetry
	r.Use(auth0.JWT(ctx, config.JWTConfig))
	r.Use(user.NewUserMiddleware(queries))

	r.POST("/query", graphqlHandler(queries))

	// TODO: Should we have this in non-local envs?
	// What about auth?
	r.GET("/", playgroundHandler())

	log.L.Debug().Msgf("connect to http://localhost:%s/ for GraphQL playground", config.Port)

	if config.Algolia.AppId != "" {
		searchService := search.New(db, config.Algolia.AppId, config.Algolia.ApiKey, config.Algolia.SearchOnlyApiKey)

		searchGroup := r.Group("search")
		searchGroup.POST("query", searchQueryHandler(searchService))

		if config.Algolia.SearchOnlyApiKey != "" {
			searchGroup.GET("key", searchKeyHandler(searchService))
		}

		log.L.Debug().Msg("Setting up endpoint for scheduled search indexing")
		searchGroup.GET("index", searchIndexHandler(searchService))
	}

	dClient := directus.New(config.Directus.Host, config.Directus.Token, false)

	r.GET("/translations/sync", func(c *gin.Context) {
		dHandler := directus.NewHandler(ctx, dClient)
		crowdinClient := crowdin.New(config.Crowdin.Token, crowdin.ClientConfig{
			ProjectIDs: config.Crowdin.ProjectIDs,
		})
		crowdinClient.Sync(dHandler)
	})

	span.End()

	err = r.Run(":" + config.Port)
	if err != nil {
		return
	}
}
