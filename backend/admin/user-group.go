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

func (s *Server) GetUserGroups(c *gin.Context) {
	var params GetListQuery
	if err := c.ShouldBind(&params); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	sort := strings.ToLower(params.Sort)
	order := strings.ToLower(params.Order)

	query := goqu.Select().From("usergroup")
	if len(params.Ids) > 0 {
		query = query.Where(goqu.C("id").In(params.Ids))
	}
	if params.SearchQ != "" {
		query = query.Where(goqu.L("? <% immutable_concat_ws(' ', title, description, long_description)", params.SearchQ))
	}
	if col := JsonToDbName(reflect.TypeOf(db.Usergroup{}), sort); col != "" {
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
		if col := JsonToDbName(reflect.TypeOf(db.Usergroup{}), key); col != "" {
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

	results := []db.Usergroup{}
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
