package main

import (
	"database/sql"
	"time"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	_ "github.com/jackc/pgx/v4/stdlib"
	"github.com/jmoiron/sqlx"
	"github.com/rs/zerolog"

	db "go.bcc.media/brunstadtv/db/sqlc"
	"go.bcc.media/brunstadtv/log"
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
	log.ConfigureGlobalLogger(zerolog.DebugLevel)

	conn, err := sql.Open("pgx", "host=localhost user=postgres dbname=vod password=password sslmode=disable")
	if err != nil {
		log.L.Fatal().Err(err).Msg("Failed to establish DB connection")
		return
	}
	queries := db.New(conn)
	s := &Server{
		queries: queries,
		dbx:     sqlx.NewDb(conn, "pgx"),
	}
	media := &MediaServer{
		Server: s,
	}
	episode := &MediaServer{
		FilterByType: "episode",
		Server:       s,
	}
	season := &MediaServer{
		FilterByType: "season",
		Server:       s,
	}
	show := &MediaServer{
		FilterByType: "show",
		Server:       s,
	}
	standalone := &MediaServer{
		FilterByType: "standalone",
		Server:       s,
	}
	subclip := &MediaServer{
		FilterByType: "subclip",
		Server:       s,
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

	r.GET("/asset-versions", s.GetAssetVersions)
	r.GET("/assets", s.GetAssets)
	r.GET("/assets/:id", s.GetAsset)
	r.GET("/media", media.GetList)
	r.POST("/media", media.Create)
	r.GET("/media/:id", media.Get)
	r.PUT("/media/:id", media.Update)
	r.GET("/episode", episode.GetList)
	r.POST("/episode", episode.Create)
	r.GET("/episode/:id", episode.Get)
	r.PUT("/episode/:id", episode.Update)
	r.GET("/show", show.GetList)
	r.POST("/show", show.Create)
	r.GET("/show/:id", show.Get)
	r.PUT("/show/:id", show.Update)
	r.GET("/season", season.GetList)
	r.POST("/season", season.Create)
	r.GET("/season/:id", season.Get)
	r.PUT("/season/:id", season.Update)
	r.GET("/standalone", standalone.GetList)
	r.POST("/standalone", standalone.Create)
	r.GET("/standalone/:id", standalone.Get)
	r.PUT("/standalone/:id", standalone.Update)
	r.GET("/subclip", subclip.GetList)
	r.POST("/subclip", subclip.Create)
	r.GET("/subclip/:id", subclip.Get)
	r.PUT("/subclip/:id", subclip.Update)
	r.Run() // listen and serve on 0.0.0.0:8080 (for windows "localhost:8080")
}
