package request

import (
	"bytes"
	"encoding/json"
	"net/http"
	"net/url"
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
	DeviceID string
	Req      *http.Request
}
