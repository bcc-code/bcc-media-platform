package testutils

import (
	"database/sql"
	"fmt"
	"os"
	"testing"

	"github.com/pressly/goose/v3"

	"github.com/bcc-code/bcc-media-platform/migrations"
	_ "github.com/lib/pq"
	"github.com/peterldowns/pgtestdb"
	"github.com/peterldowns/pgtestdb/migrators/goosemigrator"
)

func getEnv(key, fallback string) string {
	if value, ok := os.LookupEnv(key); ok {
		return value
	}
	return fallback
}

var testDBAccessible = true

func NewDB(t *testing.T) *sql.DB {
	t.Helper()

	if !testDBAccessible {
		t.Skip("Skipping DB dependent testing, database not accessible")
		return nil
	}

	user := getEnv("PG_TEST_USER", "postgres")
	pass := getEnv("PG_TEST_PASSWORD", "bccm123")
	host := getEnv("PG_TEST_HOST", "localhost")
	port := getEnv("PG_TEST_PORT", "54321")

	preMigrationsDB, err := sql.Open("postgres", fmt.Sprintf("host=%s port=%s user=%s password=%s sslmode=disable", host, port, user, pass))
	if err != nil {
		testDBAccessible = false
		t.Skip("Skipping DB dependent testing, database not accessible", err)
	}

	goose.SetBaseFS(migrations.PreMigrations)
	goose.SetTableName("goose_pre_migrations")

	if err := goose.SetDialect("postgres"); err != nil {
		testDBAccessible = false
		t.Skip("Skipping DB dependent testing, database not accessible", err)
	}

	if err := goose.Up(preMigrationsDB, "special/pre"); err != nil {
		testDBAccessible = false
		t.Skip("Skipping DB dependent testing, database not accessible", err)
	}

	conf := pgtestdb.Config{
		DriverName: "postgres",
		User:       user,
		Password:   pass,
		Host:       host,
		Port:       port,
		Options:    getEnv("PG_TEST_OPTIONS", "sslmode=disable"),
	}

	m := goosemigrator.New(".", goosemigrator.WithFS(migrations.Migrations))
	db := pgtestdb.New(t, conf, m)

	err = db.Ping()
	if err != nil {
		testDBAccessible = false
		t.Skip("Skipping DB dependent testing, database not accessible", err)
	}

	return db
}
