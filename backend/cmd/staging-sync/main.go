package main

import (
	"context"
	"database/sql"
	"os"
	"os/exec"
	"time"

	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"github.com/bcc-code/bcc-media-platform/migrations"
	"github.com/bcc-code/mediabank-bridge/log"
	_ "github.com/lib/pq"
	"github.com/pressly/goose/v3"
	"github.com/rs/zerolog"
)

func connectToDb(ctx context.Context, cfg utils.DatabaseConfig) (*sql.DB, error) {
	db, errChan := utils.MustCreateDBClient(ctx, cfg)
	err := <-errChan
	return db, err
}

func main() {
	log.ConfigureGlobalLogger(zerolog.DebugLevel)
	proxyPath := os.Getenv("AUTH_PROXY_PATH")

	if proxyInstance := os.Getenv("DEST_AUTH_PROXY_CONFIG"); proxyInstance != "" {
		cmd := exec.Command(proxyPath, "-instances", proxyInstance)
		cmd.Stdout = os.Stdout
		cmd.Stderr = os.Stderr
		if err := cmd.Start(); err != nil {
			panic(err)
		}
		defer cmd.Process.Kill()
		log.L.Info().Msg("Started the proxy to the destination database. Waiting a bit for connection to be made.")
		time.Sleep(time.Second * 5)
	}
	if proxyInstance := os.Getenv("SOURCE_AUTH_PROXY_CONFIG"); proxyInstance != "" {
		cmd := exec.Command(proxyPath, "-instances", proxyInstance)
		cmd.Stdout = os.Stdout
		cmd.Stderr = os.Stderr
		if err := cmd.Start(); err != nil {
			panic(err)
		}
		defer cmd.Process.Kill()
		log.L.Info().Msg("Started the proxy to the source database. Waiting a bit for connection to be made.")
		time.Sleep(time.Second * 5)
	}

	ctx := context.Background()

	if pgPass := os.Getenv("DEST_PG_PASSWORD"); pgPass != "" {
		_ = os.Setenv("PGPASSWORD", pgPass)
	}
	destConnectionString := os.Getenv("DEST_DB_CONNECTION_STRING")
	destDb, err := connectToDb(ctx, utils.DatabaseConfig{
		ConnectionString: destConnectionString,
	})
	if err != nil {
		panic(err)
	}
	if pgPass := os.Getenv("SOURCE_PG_PASSWORD"); pgPass != "" {
		_ = os.Setenv("PGPASSWORD", pgPass)
	}
	sourceConnectionString := os.Getenv("SOURCE_DB_CONNECTION_STRING")
	sourceDb, err := connectToDb(ctx, utils.DatabaseConfig{
		ConnectionString: sourceConnectionString,
	})
	if err != nil {
		panic(err)
	}

	goose.SetBaseFS(migrations.Migrations)
	sourceVersion, err := goose.GetDBVersion(sourceDb)
	if err != nil {
		panic(err)
	}

	currentVersion, err := goose.GetDBVersion(destDb)
	// This is in case the destination is not configured correctly
	if currentVersion < 0 || err != nil {
		_, _ = destDb.Exec("DROP SCHEMA public CASCADE")
		_, _ = destDb.Exec("DROP SCHEMA users CASCADE")
		_, _ = destDb.Exec("DROP SCHEMA stats CASCADE")
		_, _ = destDb.Exec("CREATE SCHEMA public")
		_, _ = destDb.Exec("ALTER SCHEMA public OWNER TO manager")
	}

	if sourceVersion < currentVersion {
		err = goose.DownTo(destDb, ".", sourceVersion)
		if err != nil {
			panic(err)
		}
	} else if sourceVersion > currentVersion {
		err = goose.UpTo(destDb, ".", sourceVersion)
		if err != nil {
			panic(err)
		}
	}

	// Do the sync
	scriptPath := dumpPublicSchema(sourceConnectionString)

	_, err = destDb.Exec("DROP SCHEMA public CASCADE")
	if err != nil {
		panic(err)
	}

	if pgPass := os.Getenv("DEST_PG_PASSWORD"); pgPass != "" {
		_ = os.Setenv("PGPASSWORD", pgPass)
	}
	executeScript(destConnectionString, scriptPath)
	if err = goose.Up(destDb, "."); err != nil {
		panic(err)
	}
}

func dumpPublicSchema(conStr string) string {
	file := "dump.sql"
	cmd := exec.Command("pg_dump", conStr, "-n", "public")
	cmd.Stderr = os.Stderr
	contents, err := cmd.Output()
	if err != nil {
		panic(err)
	}
	err = os.WriteFile(file, contents, 0666)
	if err != nil {
		panic(err)
	}
	return file
}

func executeScript(conStr, scriptPath string) {
	cmd := exec.Command("psql", conStr, "-f", scriptPath)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	err := cmd.Run()
	if err != nil {
		panic(err)
	}
}
