package graph

import (
	_ "embed"
	"encoding/json"
	"fmt"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/tests/load/request"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/samber/lo"
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

func toReq(q queryAndVars) *http.Request {
	req, err := request.Post(q.p, request.RequestOptions{
		Headers: q.h,
		Body:    query(q.q, q.vars),
	})
	if err != nil {
		log.L.Panic().Err(err).Send()
	}
	return req
}

func GetRequestsForDevices(devices []request.Device) []request.Request {
	path, _ := url.Parse(os.Getenv("API_ENDPOINT"))

	var result []request.Request

	for i, d := range devices {
		h := map[string]string{
			"content-type": "application/json",
		}
		u := common.User{
			PersonID:  fmt.Sprintf("test_device_%s", d.ID),
			Email:     fmt.Sprintf("%s@test.local", d.ID),
			ActiveBCC: true,
			Anonymous: false,
			Age:       i,
			Roles:     []string{"bcc-members"},
		}
		marshalled, _ := json.Marshal(u)
		h["x-user-data"] = string(marshalled)

		var requests []*http.Request
		for _, input := range getInputs() {
			requests = append(requests, toReq(queryAndVars{
				taskID: fmt.Sprintf("%s-%s", input.name, d.ID),
				h:      h,
				p:      path,
				q:      input.query,
				vars:   input.variables,
			}))
		}

		result = append(result, lo.Map(requests, func(i *http.Request, _ int) request.Request {
			return request.Request{
				DeviceID: d.ID,
				Req:      i,
			}
		})...)
	}

	return result
}
