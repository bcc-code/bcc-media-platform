package tests

import (
	"database/sql"
	"fmt"
	"log"
	"time"

	"github.com/golang-migrate/migrate/v4"
	_ "github.com/golang-migrate/migrate/v4/database/postgres"
	_ "github.com/golang-migrate/migrate/v4/source/file"
	"github.com/jmoiron/sqlx"
	"github.com/ory/dockertest/v3"
	"github.com/ory/dockertest/v3/docker"
)

func SetupDB(ctx *DockerContext) (*sql.DB, string) {
	// pulls an image, creates a container based on it and runs it
	resource, err := ctx.pool.RunWithOptions(&dockertest.RunOptions{
		Repository: "postgres",
		Tag:        "11",
		Env: []string{
			"POSTGRES_PASSWORD=secret",
			"POSTGRES_USER=postgres",
			"POSTGRES_DB=dbname",
			"listen_addresses = '*'",
		},
		Networks: []*dockertest.Network{ctx.network},
	}, func(config *docker.HostConfig) {
		// set AutoRemove to true so that stopped container goes away by itself
		config.AutoRemove = true
		config.RestartPolicy = docker.RestartPolicy{Name: "no"}
	})
	if err != nil {
		log.Fatalf("Could not start resource: %s", err)
	}

	hostAndPort := resource.GetHostPort("5432/tcp")
	databaseUrl := fmt.Sprintf("postgres://postgres:secret@%s/dbname?sslmode=disable", hostAndPort)
	dockerIp := resource.GetIPInNetwork(ctx.network)
	dockerUrl := fmt.Sprintf("host=%s user=postgres dbname=dbname password=secret sslmode=disable", dockerIp)

	log.Println("Connecting to database on url: ", databaseUrl)

	resource.Expire(120) // Tell docker to hard kill the container in 120 seconds

	// exponential backoff-retry, because the application in the container might not be ready to accept connections yet
	ctx.pool.MaxWait = 120 * time.Second
	var db *sql.DB
	if err = ctx.pool.Retry(func() error {
		db, err = sql.Open("postgres", databaseUrl)
		if err != nil {
			return err
		}
		return db.Ping()
	}); err != nil {
		log.Fatalf("Could not connect to docker: %s", err)
	}

	migrate, err := migrate.New(
		"file://../db/migrations",
		databaseUrl)
	if err != nil {
		log.Fatal(err)
	}

	err = migrate.Up()
	if err != nil {
		log.Fatal(err)
	}

	dbx := sqlx.NewDb(db, "postgres")
	_, err = dbx.Exec("INSERT INTO public.language (code, name) VALUES ('no', 'Norsk')")
	if err != nil {
		log.Fatal(err)
	}

	return db, dockerUrl

	// You can't defer this because os.Exit doesn't care for defer
	/* if err := pool.Purge(resource); err != nil {
		log.Fatalf("Could not purge resource: %s", err)
	} */
}
