package crowdin

import (
	"encoding/json"
	"github.com/ansel1/merry/v2"
	"github.com/go-resty/resty/v2"
)

func send[T any](req *resty.Request) (T, error) {
	var body T
	res, err := req.Send()
	if err != nil {
		return body, err
	}
	if !res.IsSuccess() {
		return body, merry.New("Failed to send request to Crowdin")
	}
	_ = json.Unmarshal(res.Body(), &body)
	return body, nil
}

func get[T any](client *Client, path string) (T, error) {
	req := client.c.R()
	req.URL = path
	req.Method = "GET"
	return send[T](req)
}

func post[T any](client *Client, path string, body any) (T, error) {
	req := client.c.R()
	req.URL = path
	req.Body = body
	req.Method = "POST"
	req.SetHeader("Content-Type", "application/json")
	return send[T](req)
}
