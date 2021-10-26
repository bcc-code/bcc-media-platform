package main

import (
	"context"
	"fmt"

	db "admin.brunstad.tv/app/db/sqlc"
	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v4"
)

func main() {

	conn, err := pgx.Connect(context.Background(), "host=localhost user=postgres dbname=postgres password=password sslmode=disable")
	if err != nil {
		fmt.Println(err)
		return
	}
	queries := db.New(conn)
	s := &Server{
		queries: queries,
	}

	r := gin.Default()
	r.GET("/medias/:id", s.GetMedia)
	r.GET("/medias", s.GetMedias)
	r.Run() // listen and serve on 0.0.0.0:8080 (for windows "localhost:8080")
}
