package graph

import (
	_ "embed"
	"encoding/json"
	"fmt"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/tests/load/request"
	"github.com/lib/pq"
	"github.com/samber/lo"
	"log"
	"net/http"
	"net/url"
	"os"
	"time"
)

func query(q string, vars map[string]any) any {
	return map[string]any{
		"query":     q,
		"variables": vars,
	}
}

type queryAndVars struct {
	taskID string
	p      *url.URL
	h      map[string]string
	q      string
	vars   map[string]any
}

type queryResult struct {
	TaskID        string
	R             any
	Err           error
	Started       time.Time
	Ended         time.Time
	ExecutionTime time.Duration
}

func queryReq(qs []queryAndVars) chan []queryResult {
	return lo.Async(func() []queryResult {
		log.Print("execute queries")
		defer log.Print("executed queries")
		var result []queryResult
		for _, q := range qs {
			qr := queryResult{
				TaskID:  q.taskID,
				Started: time.Now(),
			}

			qr.R, qr.Err = request.Post(http.DefaultClient, q.p, request.RequestOptions{
				Headers: q.h,
				Body:    query(q.q, q.vars),
			})

			qr.Ended = time.Now()
			qr.ExecutionTime = qr.Ended.Sub(qr.Started)

			result = append(result, qr)
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
				taskID: fmt.Sprintf("%s-%d", input.name, i),
				h:      h,
				p:      path,
				q:      input.query,
				vars:   input.variables,
			})
		}
		channels = append(channels, queryReq(queries))
	}

	csv := "task,start,end,duration,error"

	for _, c := range channels {
		for _, r := range <-c {
			errStr := ""
			if r.Err != nil {
				errStr = pq.QuoteLiteral(fmt.Sprint(r.Err))
			}

			csv += fmt.Sprintf("\n%s,%s,%s,%d,%v", r.TaskID, r.Started.Format(time.RFC3339Nano), r.Ended.Format(time.RFC3339Nano), r.ExecutionTime.Nanoseconds(), errStr)
		}
	}

	os.WriteFile("out.csv", []byte(csv), os.ModePerm)
}
