package main

import (
	"context"
	"database/sql"

	"github.com/bcc-code/mediabank-bridge/log"
)

func mustConnectToDB(ctx context.Context, config postgres) *sql.DB {
	log.L.Debug().Str("DBConnString", config.ConnectionString).Msg("Connection to DB")

	db, err := sql.Open("postgres", config.ConnectionString)
	if err != nil {
		log.L.Panic().Err(err).Msg("Unable to connect to DB")
	}

	db.SetMaxIdleConns(2)
	// TODO: What makes sense here? We should gather some metrics over time
	db.SetMaxOpenConns(10)

	err = db.PingContext(ctx)
	if err != nil {
		log.L.Panic().Err(err).Msg("Ping failed")
	}

	log.L.Info().Msg("Connected to DB")

	return db
}
