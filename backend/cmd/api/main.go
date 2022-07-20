package main

import (
	"context"
	"database/sql"
	"github.com/99designs/gqlgen/graphql/handler"
	"github.com/99designs/gqlgen/graphql/playground"
	"github.com/bcc-code/brunstadtv/backend/asset"
	"github.com/bcc-code/brunstadtv/backend/auth0"
	"github.com/bcc-code/brunstadtv/backend/graph"
	"github.com/bcc-code/brunstadtv/backend/graph/generated"
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
	"github.com/gin-gonic/gin"
	_ "github.com/lib/pq"
	"github.com/rs/zerolog"
	"go.opentelemetry.io/contrib/instrumentation/github.com/gin-gonic/gin/otelgin"
	"go.opentelemetry.io/otel"
)

// Defining the Graphql handler
func graphqlHandler(queries *sqlc.Queries, loaders *graph.BatchLoaders, searchService *search.Service) gin.HandlerFunc {

	resolver := graph.Resolver{
		Queries:       queries,
		Loaders:       loaders,
		SearchService: searchService,
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

	loaders := &graph.BatchLoaders{
		PageLoader:       page.NewBatchLoader(*queries),
		SectionLoader:    section.NewBatchLoader(*queries),
		CollectionLoader: collection.NewBatchLoader(*queries),
		ShowLoader:       show.NewBatchLoader(*queries),
		SeasonLoader:     season.NewBatchLoader(*queries),
		EpisodeLoader:    episode.NewBatchLoader(*queries),
		SeasonsLoader:    season.NewListBatchLoader(*queries),
		EpisodesLoader:   episode.NewListBatchLoader(*queries),
		FilesLoader:      asset.NewBatchFileLoader(*queries),
		StreamsLoader:    asset.NewBatchStreamLoader(*queries),
	}

	log.L.Debug().Msg("Set up HTTP server")
	r := gin.Default()
	r.Use(utils.GinContextToContextMiddleware())
	r.Use(otelgin.Middleware("api")) // OpenTelemetry
	r.Use(auth0.JWT(ctx, config.JWTConfig))
	r.Use(user.NewUserMiddleware(queries))

	searchService := search.New(db, config.Algolia.AppId, config.Algolia.ApiKey, config.Algolia.SearchOnlyApiKey)
	r.POST("/query", graphqlHandler(queries, loaders, searchService))

	r.GET("/", playgroundHandler())

	log.L.Debug().Msgf("connect to http://localhost:%s/ for GraphQL playground", config.Port)

	span.End()

	err = r.Run(":" + config.Port)
	if err != nil {
		return
	}
}
