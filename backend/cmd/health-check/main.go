package main

import (
	_ "embed"
	"fmt"
	"github.com/gin-gonic/gin"
	"os"
)

//go:embed queries/web.graphql
var webQuery string

func main() {
	r := gin.Default()

	r.GET("test", func(ctx *gin.Context) {
		apiEndpoint := os.Getenv("API_ENDPOINT")
		executeQuery(apiEndpoint, webQuery, map[string]string{
			"code": "frontpage",
		})
	})

	_ = r.Run(fmt.Sprintf(":%s", os.Getenv("PORT")))
}
