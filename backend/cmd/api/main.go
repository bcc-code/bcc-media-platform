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
	"github.com/go-co-op/gocron"
	_ "github.com/lib/pq"
	"github.com/rs/zerolog"
	"go.opentelemetry.io/contrib/instrumentation/github.com/gin-gonic/gin/otelgin"
	"go.opentelemetry.io/otel"
	"strconv"
	"time"
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

func indexHandler(client ISearchService) func() {
	return func() {
		client.Reindex()
	}
}

type directusEvent struct {
	Event          string   `json:"event"`
	Accountability any      `json:"accountability"`
	Payload        any      `json:"payload"`
	Collection     string   `json:"collection"`
	Keys           []string `json:"keys"`
	Key            int      `json:"key"`
}

const (
	itemCreatedEventKey = "items.create"
	itemUpdatedEventKey = "items.update"
	itemDeletedEventKey = "items.delete"
)

func getModelFromCollectionName(collection string) string {
	switch collection {
	case "episode", "episodes":
		return "episode"
	case "season", "seasons":
		return "season"
	case "show", "shows":
		return "show"
	}
	return ""
}

func authenticateDirectusRequest(c *gin.Context) (bool, error) {
	auth := c.Request.Header.Get("X-API-Key")

	if auth == getEnvConfig().DirectusSecret {
		return true, nil
	}

	var err error
	if auth == "" {
		err = errors.New("missing x-api-key header")
	} else {
		err = errors.New("failed to authenticate")
	}

	c.Status(401)
	_, _ = c.Writer.WriteString("Unauthorized")

	return false, err
}

func directusEventHandler(searchService ISearchService) func(c *gin.Context) {
	return func(c *gin.Context) {
		success, err := authenticateDirectusRequest(c)
		if !success {
			log.L.Error().Err(err).Msg("Failed to authenticate directus request")
			return
		}

		var event directusEvent
		err = c.BindJSON(&event)
		if err != nil {
			log.L.Error().Err(err)
			return
		}
		log.L.Debug().Msgf("Processing event: %s\nCollection: %s\n", event.Event, event.Collection)

		model := getModelFromCollectionName(event.Collection)
		if model == "" {
			log.L.Debug().Msg("Collection not supported yet")
			return
		}
		var id int64
		if len(event.Keys) > 0 {
			id, _ = strconv.ParseInt(event.Keys[0], 0, 32)
		} else {
			id = int64(event.Key)
		}

		switch event.Event {
		case itemUpdatedEventKey, itemCreatedEventKey:
			searchService.IndexModel(model, int(id))
		case itemDeletedEventKey:
			searchService.DeleteModel(model, int(id))
		}
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

	log.L.Debug().Msg("Setting up scheduler")
	scheduler := gocron.NewScheduler(time.UTC)
	searchService := search.NewService(config.Algolia.AppId, config.Algolia.ApiKey, db)
	// TODO: Move this to a google function (?)
	_, err = scheduler.Every(1).Day().At("00:00").Do(indexHandler(&searchService))
	if err != nil {
		return
	}

	scheduler.StartAsync()

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

	r.POST("/directus/webhook", directusEventHandler(&searchService))

	log.L.Debug().Msgf("connect to http://localhost:%s/ for GraphQL playground", config.Port)

	span.End()

	err = r.Run(":" + config.Port)
	if err != nil {
		return
	}
}
