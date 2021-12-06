package main

import (
	"database/sql"
	"os"
	"time"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	_ "github.com/jackc/pgx/v4/stdlib"
	"github.com/jmoiron/sqlx"
	"github.com/joho/godotenv"
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
	godotenv.Load("../.env")
	log.ConfigureGlobalLogger(zerolog.DebugLevel)

	pgConnStr := os.Getenv("POSTGRES_CONNECTIONSTRING")
	if pgConnStr == "" {
		pgConnStr = "host=localhost user=postgres dbname=postgres password=password sslmode=disable"
	}
	conn, err := sql.Open("pgx", pgConnStr)
	if err != nil {
		log.L.Fatal().Err(err).Msg("Failed to establish DB connection")
		return
	}
	queries := db.New(conn)
	s := &Server{
		queries: queries,
		dbx:     sqlx.NewDb(conn, "pgx"),
	}

	search := &SearchServer{
		Server:       s,
		TypesenseUrl: os.Getenv("TYPESENSE_SERVER"),
		ApiKey:       os.Getenv("TYPESENSE_API_KEY"),
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

	r.POST("/search/sync", search.Synchronize)
	r.GET("/tags", s.GetTags)
	r.GET("/tags/:id", s.GetTag)
	r.PUT("/tags/:id", s.UpsertTag)
	r.POST("/tags", s.UpsertTag)
	r.GET("/usergroups", s.GetUserGroups)
	r.GET("/asset-versions", s.GetAssetVersions)
	r.GET("/assets", s.GetAssets)
	r.GET("/assets/:id", s.GetAsset)
	r.GET("/medias", media.GetList)
	r.POST("/medias", media.Create)
	r.GET("/medias/:id", media.Get)
	r.PUT("/medias/:id", media.Update)
	r.GET("/pages", s.GetPages)
	r.POST("/pages", s.CreatePage)
	r.GET("/pages/:id", s.GetPage)
	r.PUT("/pages/:id", s.UpdatePage)
	r.GET("/episodes", episode.GetList)
	r.POST("/episodes", episode.Create)
	r.GET("/episodes/:id", episode.Get)
	r.PUT("/episodes/:id", episode.Update)
	r.GET("/shows", show.GetList)
	r.POST("/shows", show.Create)
	r.GET("/shows/:id", show.Get)
	r.PUT("/shows/:id", show.Update)
	r.GET("/seasons", season.GetList)
	r.POST("/seasons", season.Create)
	r.GET("/seasons/:id", season.Get)
	r.PUT("/seasons/:id", season.Update)
	r.GET("/standalones", standalone.GetList)
	r.POST("/standalones", standalone.Create)
	r.GET("/standalones/:id", standalone.Get)
	r.PUT("/standalones/:id", standalone.Update)
	r.GET("/subclips", subclip.GetList)
	r.POST("/subclips", subclip.Create)
	r.GET("/subclips/:id", subclip.Get)
	r.PUT("/subclips/:id", subclip.Update)
	r.Run("0.0.0.0:8080") // listen and serve on 0.0.0.0:8080 (for windows "localhost:8080")
}
