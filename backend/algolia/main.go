package main

import (
	"context"
	"database/sql"
	"github.com/algolia/algoliasearch-client-go/v3/algolia/search"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/mediabank-bridge/log"
	_ "github.com/lib/pq"
	"github.com/rs/zerolog"
)

type searchObject map[string]interface{}

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

func indexObjects(index *search.Index, objects []searchObject) error {
	//_, err := index.ClearObjects()
	//if err != nil {
	//	log.L.Error().Err(err).Msg("Failed to clear index")
	//}

	_, err := index.SaveObjects(objects)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to index objects")
	}
	return err
}

func index() {
	config := getEnvConfig()
	client := search.NewClient(config.Algolia.AppId, config.Algolia.ApiKey)
	index := client.InitIndex("global")
	ctx := context.Background()
	db, err := getDb()
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to init DB")
		return
	}
	queries := sqlc.New(db)

	log.L.Debug().Msg("Indexing shows")
	objects, err := getShowMapsToIndex(queries, ctx)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to retrieve objects to index")
		return
	}

	err = indexObjects(index, objects)

	if err != nil {
		log.L.Error().Err(err).Msg("Failed to index shows")
	}

	log.L.Debug().Msg("Indexing episodes")
	objects, err = getEpisodeMapsToIndex(queries, ctx)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to retrieve episodes to index")
		return
	}

	err = indexObjects(index, objects)

	if err != nil {
		log.L.Error().Err(err).Msg("Failed to index episodes")
	}

	log.L.Debug().Msg("Indexing seasons")
	objects, err = getSeasonMapsToIndex(queries, ctx)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to retrieve episodes to index")
		return
	}

	err = indexObjects(index, objects)

	if err != nil {
		log.L.Error().Err(err).Msg("Failed to index episodes")
	}
}

func main() {
	log.ConfigureGlobalLogger(zerolog.DebugLevel)

	index()
}
