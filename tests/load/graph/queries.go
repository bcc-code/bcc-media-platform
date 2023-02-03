package graph

import (
	_ "embed"
	"github.com/bcc-code/brunstadtv/tests/load/request"
	"github.com/samber/lo"
	"log"
	"net/http"
	"net/url"
	"os"
)

func query(q string, vars map[string]any) any {
	return map[string]any{
		"query":     q,
		"variables": vars,
	}
}

type queryAndVars struct {
	p    *url.URL
	h    map[string]string
	q    string
	vars map[string]any
}

type queryResult struct {
	R   any
	Err error
}

func queryReq(q queryAndVars) chan queryResult {
	return lo.Async(func() queryResult {
		log.Print("EXEC QUERY")
		defer log.Print("EXECUTED QUERY")
		res, err := request.Post(http.DefaultClient, q.p, request.RequestOptions{
			Headers: q.h,
			Body:    query(q.q, q.vars),
		})
		return queryResult{
			R:   res,
			Err: err,
		}
	})
}

//go:embed queries/page.graphql
var pageQuery string

func Run() {
	path, _ := url.Parse(os.Getenv("API_ENDPOINT"))

	headers := map[string]string{
		"content-type": "application/json",
	}

	var channels []<-chan queryResult
	for i := 0; i < 100; i++ {
		channels = append(channels, queryReq(queryAndVars{
			h: headers,
			p: path,
			q: pageQuery,
			vars: map[string]any{
				"code": "frontpage",
			},
		}))
	}

	for _, c := range channels {
		<-c
	}
}
