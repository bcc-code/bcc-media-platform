package graph

import (
	_ "embed"
	"encoding/json"
	"fmt"
	"github.com/bcc-code/brunstadtv/backend/common"
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

func queryReq(qs []queryAndVars) chan []queryResult {
	return lo.Async(func() []queryResult {
		log.Print("execute queries")
		defer log.Print("executed queries")
		var result []queryResult
		for _, q := range qs {
			res, err := request.Post(http.DefaultClient, q.p, request.RequestOptions{
				Headers: q.h,
				Body:    query(q.q, q.vars),
			})
			result = append(result, queryResult{
				R:   res,
				Err: err,
			})
		}
		return result
	})
}

func Run() {
	path, _ := url.Parse(os.Getenv("API_ENDPOINT"))

	var channels []<-chan []queryResult
	for i := 0; i < 1000; i++ {
		h := map[string]string{
			"content-type": "application/json",
		}
		u := common.User{
			PersonID:  fmt.Sprintf("TEST_USER_%d", i),
			Email:     fmt.Sprintf("%d@test.local", i),
			ActiveBCC: i%2 == 0,
			Anonymous: false,
			Age:       i,
			Roles:     []string{"bcc-members"},
		}
		marshalled, _ := json.Marshal(u)
		h["x-user-data"] = string(marshalled)

		var queries []queryAndVars
		for _, input := range getInputs() {
			queries = append(queries, queryAndVars{
				h:    h,
				p:    path,
				q:    input.query,
				vars: input.variables,
			})
		}
		channels = append(channels, queryReq(queries))
	}

	for _, c := range channels {
		for _, r := range <-c {
			if r.Err != nil {
				log.Print(r.Err)
			}
		}
	}
}
