package server

import (
	"database/sql"

	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/gin-gonic/gin"
)

// NewServer returns a new server for handling the HTTP requests
func NewServer(db *sql.DB) *server {
	return &server{
		rawDB: db,
		db:    sqlc.New(db),
	}
}

// Server is the base for all HTTP handler
type server struct {
	rawDB *sql.DB
	db    *sqlc.Queries
}

// IngestVod processes the message for ingesting a VOD asset
func (s server) IngestVod(c *gin.Context) {
}
