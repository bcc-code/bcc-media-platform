package members

import (
	"context"
	"encoding/json"
	"fmt"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"io"
	"net/http"
	"time"

	"github.com/ansel1/merry/v2"
)

var httpClient = &http.Client{
	Timeout: time.Second * 3,
}

func sendRequest[t any](ctx context.Context, client *Client, req *http.Request) (*result[t], error) {
	body, err := client.breaker.Execute(func() (any, error) {
		token, err := client.tokenProvider.GetToken(ctx, client.domain)
		if err != nil {
			return nil, merry.Wrap(err, merry.WithUserMessage("unable to retrieve members token"))
		}
		req.Header.Set("Authorization", "Bearer "+token)

		res, err := httpClient.Do(req)
		if err != nil {
			return nil, err
		}
		defer utils.LogError(res.Body.Close)

		body, err := io.ReadAll(res.Body)
		if err != nil {
			return nil, err
		}

		if 200 > res.StatusCode || res.StatusCode > 299 {
			return nil, merry.New("error occurred when trying to fetch data from members", merry.WithHTTPCode(res.StatusCode), merry.WithMessage(string(body)))
		}

		return body, err
	})

	if err != nil {
		return nil, err
	}

	var data result[t]
	err = json.Unmarshal(body.([]byte), &data)
	return &data, err
}

func get[t any](ctx context.Context, client *Client, endpoint string) (*t, error) {
	url := fmt.Sprintf("https://%s/%s", client.domain, endpoint)
	req, err := http.NewRequest("GET", url, nil)
	if err != nil {
		return nil, merry.Wrap(err)
	}

	res, err := sendRequest[t](ctx, client, req)
	if err != nil {
		return nil, merry.Wrap(err)
	}

	return &res.Data, nil
}
