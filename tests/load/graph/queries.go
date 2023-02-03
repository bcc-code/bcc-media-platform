package graph

import (
	_ "embed"
	"github.com/bcc-code/brunstadtv/tests/load/request"
	"io"
	"log"
	"net/http"
	"net/url"
	"os"
)

func defaults() (client *http.Client, endpoint *url.URL) {
	path, _ := url.Parse(os.Getenv("API_ENDPOINT"))
	return http.DefaultClient, path
}

func query(q string, vars map[string]any) (*http.Response, error) {
	client, endpoint := defaults()
	return request.Post(client, endpoint, request.RequestOptions{
		Headers: map[string]string{
			"content-type": "application/json",
		},
		Body: map[string]any{
			"query":     q,
			"variables": vars,
		},
	})
}

//go:embed queries/page.graphql
var pageQuery string

func Run() {
	res, err := query(pageQuery, map[string]any{
		"code": "frontpage",
	})
	if err != nil {
		panic(err)
	}
	str, _ := io.ReadAll(res.Body)
	log.Print(string(str))
}
