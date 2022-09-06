package auth0

import (
	"context"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"time"
)

// User is an Authenticated user
type User struct {
	ID            string    `json:"user_id"`
	CreatedAt     time.Time `json:"created_at"`
	UpdatedAt     time.Time `json:"updated_at"`
	Email         string    `json:"email"`
	EmailVerified bool      `json:"email_verified"`
	GivenName     string    `json:"given_name"`
	FamilyName    string    `json:"family_name"`
	Name          string    `json:"name"`
}

// GetUser retrieves the specific user.
func (c *Client) GetUser(ctx context.Context, userID string) (*User, error) {
	path := c.getBasePath() + fmt.Sprintf("users/%s", userID)
	req, err := http.NewRequest("GET", path, nil)
	if err != nil {
		return nil, err
	}
	res, err := c.sendRequest(ctx, req)
	if err != nil {
		return nil, err
	}

	body, err := io.ReadAll(res.Body)
	if err != nil {
		return nil, err
	}

	var user User
	err = json.Unmarshal(body, &user)
	if err != nil {
		return nil, err
	}

	return &user, nil
}
