package main

import (
	"context"
	"fmt"
	"net/http"
	"strconv"
	"strings"

	db "admin.brunstad.tv/app/db/sqlc"
	"github.com/doug-martin/goqu/v9"
	"github.com/doug-martin/goqu/v9/exp"
	"github.com/gin-gonic/gin"
	"github.com/jmoiron/sqlx"
	"gopkg.in/guregu/null.v4"
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
	idString, _ := c.Params.Get("id")
	id, err := strconv.ParseInt(idString, 10, 64)
	media, err := s.queries.GetMedia(ctx, id)
	if err != nil {
		fmt.Println(err)
		return
	}

	c.JSON(200, media)
}

type GetMediaListQuery struct {
	Ids              []int  `form:"id"`
	Sort             string `form:"sort"`
	Order            string `form:"order"`
	ReferenceMediaID string `form:"referenceMediaID"`
}

func (s *Server) GetMedias(c *gin.Context) {
	var params GetMediaListQuery
	if err := c.ShouldBind(&params); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	sort := strings.ToLower(c.Query("sort"))
	order := strings.ToLower(c.Query("order"))

	sortCol := goqu.C(sort)
	var orderedExpression exp.OrderedExpression
	if order == "asc" {
		orderedExpression = sortCol.Asc()
	} else if order == "desc" {
		orderedExpression = sortCol.Desc()
	}

	query := goqu.From("media_collectable")
	if len(params.Ids) > 0 {
		query = query.Where(goqu.C("id").In(params.Ids))
	}
	if params.ReferenceMediaID != "" {
		query = query.Where(goqu.C("reference_media_id").In(params.ReferenceMediaID))
	}

	if orderedExpression != nil {
		query = query.Order(orderedExpression)
	}

	sql, _, _ := query.ToSQL()
	s.dbx.Rebind(sql)

	var results []db.MediaCollectable
	err := s.dbx.Select(&results, sql)

	if err != nil {
		fmt.Println(err)
		return
	}

	c.Header("X-Total-Count", strconv.Itoa(len(results)))
	c.JSON(200, results)
}

func (s *Server) CreateMedia(c *gin.Context) {
	// os.Getenv("DATABASE_URL")
	ctx := context.Background()
	media, err := s.queries.InsertMedia(ctx, db.InsertMediaParams{
		MediaType: null.StringFrom("standalone"),
		Title:     null.StringFrom("Hei fra go"),
	})
	if err != nil {
		fmt.Println(err)
		return
	}

	c.JSON(200, media)
}
