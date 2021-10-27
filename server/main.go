package main

import (
	"database/sql"
	"fmt"
	"time"

	db "admin.brunstad.tv/app/db/sqlc"
	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	_ "github.com/jackc/pgx/v4/stdlib"
	"github.com/jmoiron/sqlx"
)

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
		AllowMethods:     []string{"PUT", "PATCH"},
		AllowHeaders:     []string{"Origin"},
		ExposeHeaders:    []string{"Content-Length", "X-Total-Count"},
		AllowCredentials: true,
		MaxAge:           12 * time.Hour,
	}))
	r.GET("/medias", s.GetMedias)
	r.GET("/medias/:id", s.GetMedia)
	r.Run() // listen and serve on 0.0.0.0:8080 (for windows "localhost:8080")
}
