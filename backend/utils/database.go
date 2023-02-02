package utils

import (
	"context"
	"database/sql"
	"github.com/XSAM/otelsql"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/samber/lo"
	semconv "go.opentelemetry.io/otel/semconv/v1.4.0"
)

// MustCreateDBClient returns also a channel for async pinging
func MustCreateDBClient(ctx context.Context, connectionString string) (*sql.DB, chan error) {
	log.L.Debug().Str("DBConnString", connectionString).Msg("Connection to DB")

	db, err := otelsql.Open("postgres", connectionString, otelsql.WithAttributes(
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

	asyncPing := lo.Async(func() error {

		db.SetMaxIdleConns(2)
		// TODO: What makes sense here? We should gather some metrics over time
		db.SetMaxOpenConns(10)

		err = db.PingContext(ctx)
		if err != nil {
			log.L.Panic().Err(err).Msg("Ping failed")
			return err
		}

		log.L.Info().Msg("Connected to DB")
		return nil
	})
	return db, asyncPing
}
