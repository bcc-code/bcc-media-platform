package main

import (
	"context"
	"fmt"
	"strconv"

	db "admin.brunstad.tv/app/db/sqlc"
	"github.com/gin-gonic/gin"
)

// ServerConfig for easier config of new server
type ServerConfig struct {
}

// Server holds shared resources for the webserver
// so they can be accessed by all requests
type Server struct {
	queries *db.Queries
}

func (s *Server) GetMedia(c *gin.Context) {
	// os.Getenv("DATABASE_URL")
	ctx := context.Background()
	id, err := strconv.ParseInt(c.Query("id"), 10, 64)
	media, err := s.queries.GetMedia(ctx, id)
	if err != nil {
		fmt.Println(err)
		return
	}

	c.JSON(200, media)
}

func (s *Server) GetMedias(c *gin.Context) {
	// os.Getenv("DATABASE_URL")
	ctx := context.Background()
	id, err := strconv.ParseInt(c.Query("id"), 10, 64)
	media, err := s.queries.GetMedias(ctx)
	if err != nil {
		fmt.Println(err)
		return
	}

	c.JSON(200, media)
}
