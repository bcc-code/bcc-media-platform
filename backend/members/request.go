package members

import (
	"context"
	"encoding/json"
	"fmt"
	"github.com/ansel1/merry/v2"
	"io"
	"net/http"
)

func sendRequest[t any](ctx context.Context, client *Client, req *http.Request) (*result[t], error) {
	req.Header.Set("Authorization", "Bearer "+client.tokenFactory(ctx))

	res, err := http.DefaultClient.Do(req)
	if err != nil {
		return nil, err
	}

	body, err := io.ReadAll(res.Body)
	if err != nil {
		return nil, err
	}

	if 200 > res.StatusCode || res.StatusCode > 299 {
		return nil, merry.New("error occured when trying to fetch data from members", merry.WithHTTPCode(res.StatusCode), merry.WithMessage(string(body)))
	}

	var data result[t]
	err = json.Unmarshal(body, &data)
	return &data, err
}

func get[t any](ctx context.Context, client *Client, endpoint string) (*t, error) {
	req, err := http.NewRequest("GET", fmt.Sprintf("https://%s/%s", client.domain, endpoint), nil)
	if err != nil {
		return nil, err
	}

	res, err := sendRequest[t](ctx, client, req)
	if err != nil {
		return nil, err
	}

	return &res.Data, nil
}
