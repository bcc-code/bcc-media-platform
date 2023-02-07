package request

import (
	"bytes"
	"encoding/json"
	"net/http"
	"net/url"
	"time"
)

func headers(req *http.Request, headers map[string]string) {
	for key, value := range headers {
		req.Header.Set(key, value)
	}
}

type RequestOptions struct {
	Headers map[string]string
	Body    any
}

func Post(url *url.URL, opts RequestOptions) (*http.Request, error) {
	body, _ := json.Marshal(opts.Body)
	req, err := http.NewRequest(http.MethodPost, url.String(), bytes.NewReader(body))
	if err != nil {
		return nil, err
	}
	if opts.Headers != nil {
		headers(req, opts.Headers)
	}
	return req, nil
}

type Device struct {
	ID     string
	UserID string
}

type Request struct {
	Name string
	R    *http.Request
}

type Requests struct {
	DeviceID string
	Requests []Request
}

type RequestRun struct {
	DeviceID string
	Name     string
	Started  time.Time
	Ended    time.Time
	Error    error
}

func Do(client *http.Client, requests Requests) []RequestRun {
	var result []RequestRun
	for _, r := range requests.Requests {
		run := RequestRun{
			DeviceID: requests.DeviceID,
			Name:     r.Name,
			Started:  time.Now(),
		}

		res, err := client.Do(r.R)
		if err != nil {
			run.Error = err
		}

		defer res.Body.Close()

		run.Ended = time.Now()

		result = append(result, run)
	}
	return result
}
