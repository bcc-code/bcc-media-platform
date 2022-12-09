package crowdin2

import (
	"context"
	"encoding/json"
	"github.com/ansel1/merry/v2"
	"github.com/go-resty/resty/v2"
	"go.opentelemetry.io/otel"
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

func get[T any](ctx context.Context, client *Client, path string) (T, error) {
	ctx, span := otel.Tracer("crowdin").Start(ctx, "get")
	defer span.End()
	req := client.c.R()
	req.URL = path
	req.Method = "GET"
	return send[T](req)
}

func post[T any](ctx context.Context, client *Client, path string, body any) (T, error) {
	ctx, span := otel.Tracer("crowdin").Start(ctx, "post")
	defer span.End()
	req := client.c.R()
	req.URL = path
	req.Body = body
	req.Method = "POST"
	req.SetHeader("Content-Type", "application/json")
	return send[T](req)
}
