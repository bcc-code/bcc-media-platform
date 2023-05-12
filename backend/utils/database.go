package utils

import (
	"context"
	"database/sql"
	"github.com/XSAM/otelsql"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/samber/lo"
	semconv "go.opentelemetry.io/otel/semconv/v1.4.0"
)

// DatabaseConfig contains configuration options for the database connection (Postgres)
type DatabaseConfig struct {
	ConnectionString   string
	MaxConnections     *int
	MaxIdleConnections *int
}

// MustCreateDBClient returns also a channel for async pinging
func MustCreateDBClient(ctx context.Context, config DatabaseConfig) (*sql.DB, <-chan error) {
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

	asyncPing := lo.Async(func() error {
		idle := 2
		if config.MaxIdleConnections != nil {
			idle = *config.MaxIdleConnections
		}
		max := 9
		if config.MaxConnections != nil {
			max = *config.MaxConnections
		}
		db.SetMaxIdleConns(idle)
		db.SetMaxOpenConns(max)

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
