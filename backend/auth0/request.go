package auth0

import (
	"context"
	"fmt"
	"net/http"
)

func (c *Client) sendRequest(ctx context.Context, req *http.Request) (*http.Response, error) {
	token, err := c.getToken(ctx)
	if err != nil {
		return nil, err
	}
	req.Header.Set("Authorization", "Bearer "+token)
	return http.DefaultClient.Do(req)
}

func (c *Client) getBasePath() string {
	return fmt.Sprintf("https://%s/api/v2/", c.config.Domain)
}
