package auth0

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"time"

	"github.com/ansel1/merry/v2"
)

var httpClient = &http.Client{
	Timeout: time.Second * 5,
}

func sendManagementRequest[T any](ctx context.Context, client *Client, method, path string, body any) (result T, err error) {
	var bodyReader io.Reader
	if body != nil {
		var stringBody []byte
		stringBody, err = json.Marshal(body)
		if err != nil {
			return
		}
		bodyReader = bytes.NewReader(stringBody)
	}

	managementUrl := fmt.Sprintf("https://%s/api/v2/", client.config.Domain)
	req, err := http.NewRequestWithContext(ctx, method, fmt.Sprintf("%s%s", managementUrl, path), bodyReader)
	if err != nil {
		return
	}

	token, err := client.GetToken(ctx, client.config.ManagementAudience)
	if err != nil {
		return
	}

	req.Header.Set("Authorization", fmt.Sprintf("Bearer %s", token))

	if body != nil {
		req.Header.Set("Content-Type", "application/json")
	}

	res, err := httpClient.Do(req)
	if err != nil {
		return
	}

	if res.StatusCode < 200 || res.StatusCode >= 300 {
		var str []byte
		str, err = io.ReadAll(res.Body)
		err = merry.New("Failed to fetch", merry.WithHTTPCode(res.StatusCode), merry.WithMessage(string(str)))
		return
	}
	err = json.NewDecoder(res.Body).Decode(&result)
	return
}

// GetUser returns userinfo for a specific subject
func (c *Client) GetUser(ctx context.Context, sub string) (UserInfo, error) {
	return sendManagementRequest[UserInfo](ctx, c, http.MethodGet, "users/"+sub, nil)
}

// UpdateUser updates user
func (c *Client) UpdateUser(ctx context.Context, sub string, info UserInfo, metadata UserMetadata) (UserInfo, error) {
	return sendManagementRequest[UserInfo](ctx, c, http.MethodPatch, "users/"+sub, map[string]any{
		"name":          info.Name,
		"given_name":    info.GivenName,
		"family_name":   info.FamilyName,
		"nickname":      info.Nickname,
		"user_metadata": metadata,
	})
}

type jobResponse struct {
	Status    string
	Type      string
	CreatedAt string `json:"created_at"`
	ID        string
}

// SendVerificationEmail sends a verification email to the specified user
func (c *Client) SendVerificationEmail(ctx context.Context, sub string) error {
	// TODO: implement verification emails for socials (should most likely not be necessary though)
	_, err := sendManagementRequest[jobResponse](ctx, c, http.MethodPost, "jobs/verification-email", map[string]any{
		"user_id":   sub,
		"client_id": c.config.ClientID,
	})
	return err
}
