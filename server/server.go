package main

import (
	"context"
	"fmt"
	"strconv"
	"strings"

	db "admin.brunstad.tv/app/db/sqlc"
	"github.com/doug-martin/goqu/v9"
	"github.com/doug-martin/goqu/v9/exp"
	"github.com/gin-gonic/gin"
	"github.com/jmoiron/sqlx"
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
	sort := strings.ToLower(c.Query("sort"))
	sortCol := goqu.C(sort)
	order := strings.ToLower(c.Query("order"))
	var orderedExpression exp.OrderedExpression
	if order == "asc" {
		orderedExpression = sortCol.Asc()
	} else if order == "desc" {
		orderedExpression = sortCol.Desc()
	}
	query := goqu.From("media")
	if orderedExpression != nil {
		query = query.Order(orderedExpression)
	}

	sql, _, _ := query.ToSQL()
	s.dbx.Rebind(sql)

	var results []db.Media
	err := s.dbx.Select(&results, sql)

	if err != nil {
		fmt.Println(err)
		return
	}

	c.JSON(200, results)
}
