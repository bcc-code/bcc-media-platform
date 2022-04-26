package server

import "github.com/gin-gonic/gin"

// NewServer returns a new server for handling the HTTP requests
func NewServer() *server {
	return &server{}
}

// Server is the base for all HTTP handler
type server struct{}

// IngestVod processes the message for ingesting a VOD asset
func (s server) IngestVod(c *gin.Context) {
}
