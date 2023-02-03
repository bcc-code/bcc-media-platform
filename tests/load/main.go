package main

import (
	"github.com/bcc-code/brunstadtv/tests/load/graph"
	"os"
)

func main() {
	os.Setenv("API_ENDPOINT", "http://localhost:8077/query")
	graph.Run()
}
