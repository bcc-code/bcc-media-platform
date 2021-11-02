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

func (s *Server) GetAssetVersions(c *gin.Context) {
	var params GetListQuery
	if err := c.ShouldBind(&params); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	sort := strings.ToLower(params.Sort)
	order := strings.ToLower(params.Order)

	query := goqu.From("asset_version")
	if len(params.Ids) > 0 {
		query = query.Where(goqu.C("id").In(params.Ids))
	}
	if col := JsonToDbName(reflect.TypeOf(db.AssetVersion{}), sort); col != "" {
		sortCol := goqu.C(col)
		if order == "asc" {
			query = query.Order(sortCol.Asc())
		} else if order == "desc" {
			query = query.Order(sortCol.Desc())
		}
	}
	if params.Start.Valid {
		query = query.Offset(uint(params.Start.Int64))
	}
	if params.End.Valid {
		query = query.Limit((uint)(params.End.Int64 - params.Start.ValueOrZero()))
	}

	q := c.Request.URL.Query()
	unhandled := GetUnhandledParams(q)
	for _, key := range unhandled {
		if col := JsonToDbName(reflect.TypeOf(db.AssetVersion{}), key); col != "" {
			query = query.Where(goqu.C(col).In(q.Get(key)))
		}
	}

	sql, _, _ := query.ToSQL()
	s.dbx.Rebind(sql)

	results := []db.AssetVersion{}
	if err := s.dbx.Select(&results, sql); err != nil {
		fmt.Println(err)
		return
	}

	var count int
	if err := s.dbx.Get(&count, "SELECT COUNT(*) FROM asset_version"); err != nil {
		fmt.Println(err)
		return
	}

	c.Header("X-Total-Count", strconv.Itoa(count))
	c.JSON(http.StatusOK, results)
}
