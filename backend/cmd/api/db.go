package main

import (
	"context"
	"database/sql"

	"github.com/XSAM/otelsql"
	"github.com/bcc-code/mediabank-bridge/log"
	semconv "go.opentelemetry.io/otel/semconv/v1.4.0"
)

func mustConnectToDB(ctx context.Context, config postgres) *sql.DB {
	log.L.Debug().Str("DBConnString", config.ConnectionString).Msg("Connection to DB")

	db, err := otelsql.Open("postgres", config.ConnectionString, otelsql.WithAttributes(
		semconv.DBSystemPostgreSQL,
	))
	if err != nil {
		log.L.Panic().Err(err).Msg("Unable to connect to DB")
	}

	err = otelsql.RegisterDBStatsMetrics(db, otelsql.WithAttributes(
		semconv.DBSystemPostgreSQL,
	))
	if err != nil {
		log.L.Panic().Err(err).Msg("Unable to instrument DB")
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
