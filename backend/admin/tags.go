package main

import (
	"fmt"
	"net/http"
	"reflect"
	"strconv"
	"strings"

	"github.com/doug-martin/goqu/v9"
	"github.com/gin-gonic/gin"

	db "go.bcc.media/brunstadtv/db/sqlc"
)

func (s *Server) GetTag(c *gin.Context) {
	ctx := c.Request.Context()
	idString, _ := c.Params.Get("id")
	id, err := strconv.ParseInt(idString, 10, 64)
	if err != nil {
		fmt.Println(err)
		return
	}
	result, err := s.queries.GetTag(ctx, id)
	if err != nil {
		fmt.Println(err)
		return
	}

	c.JSON(http.StatusOK, result)
}

func (s *Server) GetTags(c *gin.Context) {
	var params GetListQuery
	if err := c.ShouldBind(&params); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	sort := strings.ToLower(params.Sort)
	order := strings.ToLower(params.Order)

	query := goqu.Select().From("admin.tag")
	if len(params.Ids) > 0 {
		query = query.Where(goqu.C("id").In(params.Ids))
	}
	if params.SearchQ != "" {
		query = query.Where(goqu.L("? <% immutable_concat_ws(' ', name, id::text)", params.SearchQ))
	}
	if col := JsonToDbName(reflect.TypeOf(db.AdminTag{}), sort); col != "" {
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
		if col := JsonToDbName(reflect.TypeOf(db.AdminTag{}), key); col != "" {
			query = query.Where(goqu.C(col).In(q.Get(key)))
		}
	}

	sqlBeforePagination, _, _ := query.ToSQL()
	countQuery := "SELECT COUNT(a.*) FROM (" + sqlBeforePagination + ") a"
	s.dbx.Rebind(countQuery)

	if params.Start.Valid {
		query = query.Offset(uint(params.Start.Int64))
	}
	if params.End.Valid {
		query = query.Limit((uint)(params.End.Int64 - params.Start.ValueOrZero()))
	}

	sql, _, _ := query.ToSQL()
	s.dbx.Rebind(sql)

	results := []db.AdminTag{}
	if err := s.dbx.Select(&results, sql); err != nil {
		fmt.Println(err)
		return
	}

	var count int
	if err := s.dbx.Get(&count, countQuery); err != nil {
		fmt.Println(err)
		return
	}

	c.Header("X-Total-Count", strconv.Itoa(count))
	c.JSON(http.StatusOK, results)
}

func (s *Server) UpsertTag(c *gin.Context) {
	var params db.UpsertTagParams
	if err := c.ShouldBind(&params); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	ctx := c.Request.Context()
	result, err := s.queries.UpsertTag(ctx, params)
	if err != nil {
		fmt.Println(err)
		return
	}

	c.JSON(http.StatusOK, result)
}
