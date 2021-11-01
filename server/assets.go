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
)

func (s *Server) GetAsset(c *gin.Context) {
	// os.Getenv("DATABASE_URL")
	ctx := context.Background()
	idString, _ := c.Params.Get("id")
	id, err := strconv.ParseInt(idString, 10, 64)
	result, err := s.queries.GetAsset(ctx, id)
	if err != nil {
		fmt.Println(err)
		return
	}

	c.JSON(200, result)
}

func (s *Server) GetAssets(c *gin.Context) {
	var params GetListQuery
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

	query := goqu.From("asset")
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
		mediaStructFields := db.Asset{}.GetFields()
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

	results := []db.Asset{}
	err := s.dbx.Select(&results, sql)

	if err != nil {
		fmt.Println(err)
		return
	}

	c.Header("X-Total-Count", strconv.Itoa(len(results)))
	c.JSON(200, results)
}
