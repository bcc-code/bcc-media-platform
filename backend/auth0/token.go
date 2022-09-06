package auth0

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	cache "github.com/Code-Hex/go-generics-cache"
	"github.com/ansel1/merry/v2"
	"io"
	"net/http"
	"net/url"
	"time"
)

var tokenCache = cache.New[string, getTokenResponse]()

type getTokenResponse struct {
	AccessToken string `json:"access_token"`
	ExpiresIn   int    `json:"expires_in"`
	ExpiresAt   time.Time
	TokenType   string `json:"token_type"`
}

func sendTokenRequest[t any](ctx context.Context, body t, endpoint string) (getTokenResponse, error) {
	marshalled, err := json.Marshal(body)
	if err != nil {
		return getTokenResponse{}, err
	}

	res, err := http.Post(
		endpoint,
		"application/json",
		bytes.NewBuffer(marshalled),
	)
	if err != nil {
		return getTokenResponse{}, err
	}

	result, err := io.ReadAll(res.Body)
	if err != nil {
		return getTokenResponse{}, err
	}

	if res.StatusCode < 200 || res.StatusCode > 299 {
		return getTokenResponse{}, merry.New("failed to retrieve token", merry.WithHTTPCode(res.StatusCode), merry.WithMessage(string(result)))
	}

	var response getTokenResponse
	err = json.Unmarshal(result, &response)
	if err != nil {
		return getTokenResponse{}, err
	}
	response.ExpiresAt = time.Now().Add(time.Second * time.Duration(response.ExpiresIn))
	return response, nil
}

type getTokenRequest struct {
	GrantType    string `json:"grant_type"`
	ClientID     string `json:"client_id"`
	ClientSecret string `json:"client_secret"`
	Audience     string `json:"audience"`
}

func (c *Client) getNewToken(ctx context.Context) (getTokenResponse, error) {
	path, _ := url.Parse(fmt.Sprintf("https://%s/oauth/token", c.config.Domain))
	return sendTokenRequest(ctx, getTokenRequest{
		GrantType:    "client_credentials",
		ClientID:     c.config.ClientID,
		ClientSecret: c.config.ClientSecret,
		Audience:     fmt.Sprintf("https://%s/api/v2/", c.config.Domain),
	}, path.String())
}

func (c *Client) getToken(ctx context.Context) (string, error) {
	var err error
	t, ok := tokenCache.Get("t")
	if ok && t.ExpiresAt.After(time.Now()) {
		return t.AccessToken, nil
	} else {
		t, err = c.getNewToken(ctx)
	}
	if err != nil {
		return "", err
	}

	// Probably will never survive this long, but it's just in case.
	tokenCache.Set("t", t, cache.WithExpiration(time.Hour*24))

	return t.AccessToken, nil
}
