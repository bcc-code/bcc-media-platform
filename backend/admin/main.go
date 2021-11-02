package main

import (
	"database/sql"
	"fmt"
	"time"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	_ "github.com/jackc/pgx/v4/stdlib"
	"github.com/jmoiron/sqlx"

	db "go.bcc.media/brunstadtv/db/sqlc"
)

// ServerConfig for easier config of new server
type ServerConfig struct {
}

// Server holds shared resources for the webserver
// so they can be accessed by all requests
type Server struct {
	queries *db.Queries
	dbx     *sqlx.DB
}

func main() {

	conn, err := sql.Open("pgx", "host=localhost user=postgres dbname=vod password=password sslmode=disable")
	if err != nil {
		fmt.Println(err)
		return
	}
	queries := db.New(conn)
	s := &Server{
		queries: queries,
		dbx:     sqlx.NewDb(conn, "pgx"),
	}

	r := gin.Default()
	r.Use(cors.New(cors.Config{
		AllowAllOrigins:  true,
		AllowMethods:     []string{"PUT", "PATCH", "POST"},
		AllowHeaders:     []string{"Origin", "content-type"},
		ExposeHeaders:    []string{"Content-Length", "X-Total-Count"},
		AllowCredentials: true,
		MaxAge:           12 * time.Hour,
	}))
	r.GET("/medias", s.GetMedias)
	r.GET("/asset-versions", s.GetAssetVersions)
	r.GET("/assets", s.GetAssets)
	r.GET("/assets/:id", s.GetAsset)
	r.POST("/medias", s.CreateMedia)
	r.GET("/medias/:id", s.GetMedia)
	r.PUT("/medias/:id", s.UpdateMedia)
	r.Run() // listen and serve on 0.0.0.0:8080 (for windows "localhost:8080")
}
