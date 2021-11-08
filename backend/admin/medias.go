package main

import (
	"context"
	"fmt"
	"net/http"
	"reflect"
	"strconv"
	"strings"

	"github.com/doug-martin/goqu/v9"
	"github.com/gin-gonic/gin"
	db "go.bcc.media/brunstadtv/db/sqlc"
	"gopkg.in/guregu/null.v4"
)

type MediaServer struct {
	FilterByType string
	Server       *Server
}

func (s *MediaServer) Get(c *gin.Context) {
	ctx := context.Background()
	idString, _ := c.Params.Get("id")
	id, err := strconv.ParseInt(idString, 10, 64)
	if err != nil {
		fmt.Println(err)
		return
	}
	media, err := s.Server.queries.GetMedia(ctx, id)
	if err != nil {
		fmt.Println(err)
		return
	}
	if s.FilterByType != "" && s.FilterByType != media.MediaType.String {
		c.JSON(http.StatusBadRequest, gin.H{"error": "This media has a different type: " + media.MediaType.String})
	}

	c.JSON(http.StatusOK, media)
}

// GET http://my.api.url/media?_sort=title&_order=ASC&_start=0&_end=24&title=bar
func (s *MediaServer) GetList(c *gin.Context) {
	var params GetListQuery
	if err := c.ShouldBind(&params); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	sort := strings.ToLower(params.Sort)
	order := strings.ToLower(params.Order)

	query := goqu.Select().From("media_collectable")
	if s.FilterByType != "" {
		query = query.Where(goqu.C("media_type").Eq(s.FilterByType))
	}
	if len(params.Ids) > 0 {
		query = query.Where(goqu.C("id").In(params.Ids))
	}
	if params.SearchQ != "" {
		query = query.Where(goqu.L("? <% immutable_concat_ws(' ', title, description, long_description)", params.SearchQ))
	}
	if col := JsonToDbName(reflect.TypeOf(db.MediaCollectable{}), sort); col != "" {
		sortCol := goqu.C(col)
		if order == "asc" {
			query = query.Order(sortCol.Asc())
		} else if order == "desc" {
			query = query.Order(sortCol.Desc())
		}
	}

	q := c.Request.URL.Query()
	unhandled := GetUnhandledParams(q)
	for _, key := range unhandled {
		if col := JsonToDbName(reflect.TypeOf(db.MediaCollectable{}), key); col != "" {
			query = query.Where(goqu.C(col).In(q.Get(key)))
		}
	}

	sqlBeforePagination, _, _ := query.ToSQL()
	countQuery := "SELECT COUNT(a.*) FROM (" + sqlBeforePagination + ") a"
	s.Server.dbx.Rebind(countQuery)

	if params.Start.Valid {
		query = query.Offset(uint(params.Start.Int64))
	}
	if params.End.Valid {
		query = query.Limit((uint)(params.End.Int64 - params.Start.ValueOrZero()))
	}

	sql, _, _ := query.ToSQL()
	s.Server.dbx.Rebind(sql)

	results := []db.MediaCollectable{}
	if err := s.Server.dbx.Select(&results, sql); err != nil {
		fmt.Println(err)
		return
	}

	var count int
	if err := s.Server.dbx.Get(&count, countQuery); err != nil {
		fmt.Println(err)
		return
	}

	c.Header("X-Total-Count", strconv.Itoa(count))
	c.JSON(http.StatusOK, results)
}

func (s *MediaServer) Create(c *gin.Context) {
	var params db.InsertMediaParams
	if err := c.ShouldBind(&params); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	if s.FilterByType == "" && params.MediaType.String == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "MediaType not set"})
		return
	}
	// Set in both but different from eachother
	if s.FilterByType != "" && params.MediaType.String != "" && s.FilterByType != params.MediaType.String {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Wrong endpoint for this mediaType."})
		return
	}
	if params.MediaType.String == "" {
		params.MediaType = null.StringFrom(s.FilterByType)
	}
	// os.Getenv("DATABASE_URL")
	ctx := context.Background()
	media, err := s.Server.queries.InsertMedia(ctx, params)
	if err != nil {
		fmt.Println(err)
		return
	}

	c.JSON(http.StatusOK, media)
}

func (s *MediaServer) Update(c *gin.Context) {
	var params db.UpsertMediaParams
	if err := c.ShouldBind(&params); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	if s.FilterByType == "" && params.MediaType.String == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "MediaType not set"})
		return
	}
	// Set in both but different from eachother
	if s.FilterByType != "" && params.MediaType.String != "" && s.FilterByType != params.MediaType.String {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Wrong endpoint for this mediaType."})
	}
	if params.MediaType.String == "" {
		params.MediaType = null.StringFrom(s.FilterByType)
		return
	}
	// os.Getenv("DATABASE_URL")
	ctx := context.Background()
	media, err := s.Server.queries.UpsertMedia(ctx, params)
	if err != nil {
		fmt.Println(err)
		return
	}

	c.JSON(http.StatusOK, media)
}
