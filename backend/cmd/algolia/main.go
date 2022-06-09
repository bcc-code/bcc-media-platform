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

func showToObjectMap(show sqlc.Show, translations []sqlc.ShowsTranslation) map[string]string {
	showId := int(show.ID)
	object := map[string]string{
		"objectID": "show-" + strconv.Itoa(showId),
	}

	for _, translation := range translations {
		values := map[string]string{
			"title":       translation.Title.ValueOrZero(),
			"description": translation.Description.ValueOrZero(),
		}
		for key, value := range values {
			if value != "" {
				object[key+"_"+translation.LanguagesCode] = value
			}
		}
	}

	return object
}

func index() {
	ctx := context.Background()
	config := getEnvConfig()
	client := search.NewClient(config.Algolia.AppId, config.Algolia.ApiKey)
	db, err := getDb()
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to init DB")
		return
	}
	queries := sqlc.New(db)
	shows, err := queries.GetShows(ctx)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to retrieve shows")
		return
	}
	translations, err := queries.GetShowTranslations(ctx)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to retrieve showTranslations")
		return
	}

	translationsByShow := map[int][]sqlc.ShowsTranslation{}

	for _, translation := range translations {
		showId := int(translation.ShowsID)
		translationsByShow[showId] = append(translationsByShow[showId], translation)
	}

	objects := make([]map[string]string, len(shows))
	for index, show := range shows {
		objects[index] = showToObjectMap(show, translationsByShow[int(show.ID)])
	}

	index := client.InitIndex("shows")
	_, err = index.ClearObjects()
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to clear index")
	}

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
