package graph

import (
	_ "embed"
	"encoding/json"
	"fmt"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/tests/load/request"
	"github.com/bcc-code/mediabank-bridge/log"
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

func GetRequestsForDevices(devices []request.Device) []request.Requests {
	path, _ := url.Parse(os.Getenv("API_ENDPOINT"))

	var result []request.Requests

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

		var requests []request.Request
		for _, input := range getInputs() {
			requests = append(requests, request.Request{
				Name: fmt.Sprintf("%s-%s", input.name, d.ID),
				R: toReq(queryAndVars{
					h:    h,
					p:    path,
					q:    input.query,
					vars: input.variables,
				}),
			})
		}

		result = append(result, request.Requests{
			DeviceID: d.ID,
			Requests: requests,
		})
	}

	return result
}
