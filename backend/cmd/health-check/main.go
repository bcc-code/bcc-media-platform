package main

import (
	_ "embed"
	"fmt"
	"github.com/gin-gonic/gin"
	"os"
)

//go:embed queries/application.graphql
var applicationQuery string

//go:embed queries/web.graphql
var webQuery string

//go:embed queries/app.graphql
var appQuery string

//go:embed queries/tvos.graphql
var tvosQuery string

type applicationResult struct {
	Application struct {
		ClientVersion string
		Page          struct {
			Code string
		}
	}
}

func main() {
	r := gin.Default()

	r.GET("test", func(ctx *gin.Context) {
		apiEndpoint := os.Getenv("API_ENDPOINT")
		var status int
		var app applicationResult
		status, app = executeQuery[applicationResult](apiEndpoint, applicationQuery, map[string]string{}, map[string]string{
			"x-application": "btv",
		})
		if status != 200 {
			ctx.Status(status)
			return
		}
		status, app = executeQuery[applicationResult](apiEndpoint, webQuery, map[string]string{
			"code": app.Application.Page.Code,
		}, map[string]string{
			"x-application": "btv",
		})
		if status != 200 {
			ctx.Status(status)
			return
		}
		status, app = executeQuery[applicationResult](apiEndpoint, appQuery, map[string]string{
			"code": app.Application.Page.Code,
		}, map[string]string{
			"x-application": "btv",
		})
		if status != 200 {
			ctx.Status(status)
			return
		}

		status, app = executeQuery[applicationResult](apiEndpoint, applicationQuery, map[string]string{}, map[string]string{
			"x-application": "tvos",
		})
		if status != 200 {
			ctx.Status(status)
			return
		}
		status, app = executeQuery[applicationResult](apiEndpoint, tvosQuery, map[string]string{
			"code": app.Application.Page.Code,
		}, map[string]string{
			"x-application": "tvos",
		})
		if status != 200 {
			ctx.Status(status)
			return
		}
	})

	_ = r.Run(fmt.Sprintf(":%s", os.Getenv("PORT")))
}
