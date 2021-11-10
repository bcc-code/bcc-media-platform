package tests

import (
	"log"

	"github.com/ory/dockertest/v3"
)

type DockerContext struct {
	pool    *dockertest.Pool
	network *dockertest.Network
}

func SetupPool() *DockerContext {
	pool, err := dockertest.NewPool("")
	if err != nil {
		log.Fatalf("Could not connect to docker: %s", err)
	}
	network, err := pool.CreateNetwork("tests")
	if err != nil {
		log.Fatalf("Could not create docker network: %s", err)
	}
	return &DockerContext{
		pool:    pool,
		network: network,
	}
}
