package tests

import (
	"fmt"
	"log"

	_ "github.com/golang-migrate/migrate/v4/database/postgres"
	_ "github.com/golang-migrate/migrate/v4/source/file"
	"github.com/ory/dockertest/v3"
	"github.com/ory/dockertest/v3/docker"
)

func SetupAdmin(ctx *DockerContext, dbUrl string) string {

	// pulls an image, creates a container based on it and runs it
	resource, err := ctx.pool.RunWithOptions(&dockertest.RunOptions{
		Repository: "brunstadtv-admin-test",
		Tag:        "",
		Env: []string{
			"listen_addresses = '*'",
			"POSTGRES_CONNECTIONSTRING=" + dbUrl + "",
			"PORT=8080",
		},
		ExposedPorts: []string{"8080"},
		Networks:     []*dockertest.Network{ctx.network},
	}, func(config *docker.HostConfig) {
		// set AutoRemove to true so that stopped container goes away by itself
		config.AutoRemove = true
		config.RestartPolicy = docker.RestartPolicy{Name: "no"}
		config.PublishAllPorts = true
	})
	if err != nil {
		log.Fatalf("Could not start resource: %s", err)
	}

	hostAndPort := resource.GetHostPort("8080/tcp")
	url := fmt.Sprintf("http://%s", hostAndPort)

	log.Println("Created admin container: ", url)

	resource.Expire(120) // Tell docker to hard kill the container in 120 seconds

	return url

	// You can't defer this because os.Exit doesn't care for defer
	/* if err := pool.Purge(resource); err != nil {
		log.Fatalf("Could not purge resource: %s", err)
	} */
}
