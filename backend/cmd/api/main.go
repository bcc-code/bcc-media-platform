package main

import (
	"context"
	"database/sql"
	"encoding/json"
	"github.com/99designs/gqlgen/graphql/handler"
	"github.com/99designs/gqlgen/graphql/playground"
	"github.com/bcc-code/brunstadtv/backend/cmd/api/search"
	"github.com/bcc-code/brunstadtv/backend/graph"
	"github.com/bcc-code/brunstadtv/backend/graph/generated"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/brunstadtv/backend/utils"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/gin-gonic/gin"
	"github.com/go-co-op/gocron"
	_ "github.com/lib/pq"
	"github.com/rs/zerolog"
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

func indexHandler(client *search.Service) func() {
	return func() {
		client.Index()
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

func directusEventHandler(searchService *search.Service) func(c *gin.Context) {
	return func(c *gin.Context) {
		var event directusEvent
		data, _ := c.GetRawData()
		owh := string(data)
		err := json.Unmarshal(data, &event)
		if err != nil {
			log.L.Error().Err(err)
			return
		}
		log.L.Debug().Msg(owh)
		log.L.Debug().Msg("Processing event: " + event.Event + ". Collection: " + event.Collection)

		model := getModelFromCollectionName(event.Collection)
		if model == "" {
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
	log.L.Debug().Msg("Seting up tracing!")

	// Here you can get a tracedHttpClient if useful anywhere
	utils.MustSetupTracing()
	ctx, span := otel.Tracer("api/core").Start(ctx, "init")

	config := getEnvConfig()
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
	_, err = scheduler.Every(1).Day().At("00:00").Minutes().Do(indexHandler(&searchService))
	if err != nil {
		return
	}

	scheduler.StartAsync()

	log.L.Debug().Msg("Set up HTTP server")
	r := gin.Default()

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
