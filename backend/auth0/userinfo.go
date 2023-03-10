package auth0

import (
	"context"
	"encoding/json"
	"fmt"
	"github.com/ansel1/merry/v2"
	"net/http"
	"time"
)

// UserInfo contains information about a user
type UserInfo struct {
	Sub           string    `json:"sub"`
	Nickname      string    `json:"nickname"`
	Name          string    `json:"name"`
	Picture       string    `json:"picture"`
	UpdatedAt     time.Time `json:"updated_at"`
	Email         string    `json:"email"`
	EmailVerified bool      `json:"email_verified"`
	//ClaimsPersonId        null.Int    `json:"https://login.bcc.no/claims/personId"`
	//ClaimsHasMembership   bool        `json:"https://login.bcc.no/claims/hasMembership"`
	//ClaimsChurchId        null.Int    `json:"https://login.bcc.no/claims/churchId"`
	//ClaimsChurchName      null.String `json:"https://login.bcc.no/claims/churchName"`
	//ClaimsCountryIso2Code null.String `json:"https://login.bcc.no/claims/CountryIso2Code"`
	//AppMetadata           struct{}    `json:"https://members.bcc.no/app_metadata"`
}

// GetUserInfoForAuthHeader returns info for the user
func (c *Client) GetUserInfoForAuthHeader(ctx context.Context, authHeader string) (UserInfo, error) {
	var result UserInfo
	req, err := http.NewRequest(http.MethodGet, fmt.Sprintf("https://%s/userinfo", c.config.Domain), nil)
	if err != nil {
		return result, err
	}
	req.Header.Set("Authorization", authHeader)
	res, err := http.DefaultClient.Do(req)
	if err != nil {
		return result, err
	}
	if res.StatusCode < 200 || res.StatusCode > 299 {
		return result, merry.New("Error occurred trying to fetch user info for access token", merry.WithHTTPCode(res.StatusCode))
	}
	err = json.NewDecoder(res.Body).Decode(&result)
	return result, err
}
