package main

import (
	"context"
	"fmt"
	"net/http"
	"reflect"
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
	Ids   []int  `form:"id"`
	Sort  string `form:"_sort"`
	Order string `form:"_order"`
}

func (q GetMediaListQuery) GetFieldNames() []string {
	val := reflect.ValueOf(q)
	var result []string
	for i := 0; i < val.Type().NumField(); i++ {
		result = append(result, val.Type().Field(i).Tag.Get("form"))
	}
	return result
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
	q := c.Request.URL.Query()
	fieldNames := params.GetFieldNames()
QueryStringLoop:
	for key, element := range q {
		for _, fieldName := range fieldNames {
			if key[0] == '_' || strings.ToLower(fieldName) == strings.ToLower(key) {
				continue QueryStringLoop
			}
		}
		mediaStructFields := db.MediaCollectable{}.GetFields()
		for _, field := range mediaStructFields {
			if field.Tag.Get("json") != key {
				continue
			}
			col := field.Tag.Get("db")
			if col == "" {
				continue QueryStringLoop
			}
			query = query.Where(goqu.C(col).In(element))
			break
		}
	}
	if orderedExpression != nil {
		query = query.Order(orderedExpression)
	}

	sql, _, _ := query.ToSQL()
	s.dbx.Rebind(sql)

	results := []db.MediaCollectable{}
	err := s.dbx.Select(&results, sql)

	if err != nil {
		fmt.Println(err)
		return
	}

	c.Header("X-Total-Count", strconv.Itoa(len(results)))
	c.JSON(200, results)
}

func (s *Server) CreateMedia(c *gin.Context) {
	var params db.InsertMediaParams
	if err := c.ShouldBind(&params); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	// os.Getenv("DATABASE_URL")
	ctx := context.Background()
	media, err := s.queries.InsertMedia(ctx, params)
	if err != nil {
		fmt.Println(err)
		return
	}

	c.JSON(200, media)
}

func (s *Server) UpdateMedia(c *gin.Context) {
	var params db.UpsertMediaParams
	if err := c.ShouldBind(&params); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	// os.Getenv("DATABASE_URL")
	ctx := context.Background()
	media, err := s.queries.UpsertMedia(ctx, params)
	if err != nil {
		fmt.Println(err)
		return
	}

	c.JSON(200, media)
}
