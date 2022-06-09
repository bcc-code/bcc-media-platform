package main

import (
	"context"
	"database/sql"
	"github.com/algolia/algoliasearch-client-go/v3/algolia/search"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/mediabank-bridge/log"
	_ "github.com/lib/pq"
	"github.com/rs/zerolog"
	"strconv"
)

var database *sql.DB

func getDb() (*sql.DB, error) {
	if database != nil {
		return database, nil
	}

	db, err := sql.Open("postgres", getEnvConfig().DB.ConnectionString)
	if err == nil {
		err = db.PingContext(context.Background())
	}
	if err == nil {
		database = db
	}
	return database, err
}

func index() {
	config := getEnvConfig()
	client := search.NewClient(config.Algolia.AppId, config.Algolia.ApiKey)
	db, err := getDb()
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to init DB")
		return
	}
	queries := sqlc.New(db)
	shows, err := queries.GetShows(context.Background())
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to retrieve shows")
		return
	}
	objects := make([]SearchItem, len(shows))
	for index, show := range shows {
		objects[index] = SearchItem{
			ID:    "show-" + strconv.Itoa(int(show.ID)),
			Title: "ttol",
		}
	}
	index := client.InitIndex("shows")
	_, err = index.SaveObjects(objects)

	if err != nil {
		log.L.Error().Err(err).Msg("Failed to index objects")
		return
	}
}

func main() {
	log.ConfigureGlobalLogger(zerolog.DebugLevel)
	log.L.Debug().Msg("Setting up tracing!")

	index()
}
