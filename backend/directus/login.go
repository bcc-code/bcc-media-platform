// Package directus provides a server-to-server client for the Directus
// `/auth/login` endpoint. The API proxies admin-web credentials to Directus
// and then mints its own tokens; Directus JWTs never leave the backend.
package directus

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"strings"
	"time"

	"github.com/lestrrat-go/jwx/v2/jwt"
)

// issuer is the value Directus sets in the `iss` claim of the JWTs it signs.
const issuer = "directus"

// Claims holds the subset of the Directus access-token payload we care about.
type Claims struct {
	// UserID is the Directus user id (`id` claim), a UUID string.
	UserID string
	// Role is the Directus role id (`role` claim), a UUID string. May be empty.
	Role string
	// AppAccess reports whether the user is allowed to use the Directus app.
	AppAccess bool
	// AdminAccess reports whether the user has Directus admin privileges.
	AdminAccess bool
}

// Client is a server-to-server client for the Directus auth API.
type Client struct {
	baseURL    string
	httpClient *http.Client
}

// NewClient returns a client for the Directus instance at baseURL.
func NewClient(baseURL string) (*Client, error) {
	if baseURL == "" {
		return nil, fmt.Errorf("directus url is empty")
	}
	return &Client{
		baseURL:    strings.TrimSuffix(baseURL, "/"),
		httpClient: &http.Client{Timeout: 10 * time.Second},
	}, nil
}

// LoginError is an error reported by Directus itself (as opposed to a
// transport or decode failure). Code is the Directus `extensions.code` value,
// e.g. INVALID_CREDENTIALS or INVALID_OTP.
type LoginError struct {
	Code    string
	Message string
}

func (e *LoginError) Error() string {
	return fmt.Sprintf("directus login failed: %s (%s)", e.Message, e.Code)
}

// IsCredentialError reports whether the failure is the caller's fault (wrong
// email/password/otp) rather than a Directus-side problem.
func (e *LoginError) IsCredentialError() bool {
	return e.Code == "INVALID_CREDENTIALS" || e.Code == "INVALID_OTP"
}

// Login authenticates against {baseURL}/auth/login (mode "json") and returns
// the claims of the access token Directus issued. The token's signature is
// NOT verified — we received it directly from Directus over TLS, so parsing
// it insecurely is safe; these tokens are never accepted from clients. otp
// may be empty.
func (c *Client) Login(ctx context.Context, email, password, otp string) (*Claims, error) {
	reqBody := map[string]string{"email": email, "password": password, "mode": "json"}
	if otp != "" {
		reqBody["otp"] = otp
	}
	payload, err := json.Marshal(reqBody)
	if err != nil {
		return nil, fmt.Errorf("marshal login request: %w", err)
	}

	req, err := http.NewRequestWithContext(ctx, http.MethodPost, c.baseURL+"/auth/login", bytes.NewReader(payload))
	if err != nil {
		return nil, fmt.Errorf("build login request: %w", err)
	}
	req.Header.Set("Content-Type", "application/json")

	res, err := c.httpClient.Do(req)
	if err != nil {
		return nil, fmt.Errorf("directus login request: %w", err)
	}
	defer res.Body.Close()

	if res.StatusCode != http.StatusOK {
		var errBody struct {
			Errors []struct {
				Message    string `json:"message"`
				Extensions struct {
					Code string `json:"code"`
				} `json:"extensions"`
			} `json:"errors"`
		}
		if err := json.NewDecoder(res.Body).Decode(&errBody); err == nil && len(errBody.Errors) > 0 {
			return nil, &LoginError{
				Code:    errBody.Errors[0].Extensions.Code,
				Message: errBody.Errors[0].Message,
			}
		}
		return nil, fmt.Errorf("directus login returned status %d", res.StatusCode)
	}

	var body struct {
		Data struct {
			AccessToken string `json:"access_token"`
		} `json:"data"`
	}
	if err := json.NewDecoder(res.Body).Decode(&body); err != nil {
		return nil, fmt.Errorf("decode login response: %w", err)
	}
	if body.Data.AccessToken == "" {
		return nil, fmt.Errorf("login response contains no access token")
	}

	tok, err := jwt.ParseInsecure([]byte(body.Data.AccessToken))
	if err != nil {
		return nil, fmt.Errorf("parse directus token: %w", err)
	}
	if tok.Issuer() != issuer {
		return nil, fmt.Errorf("unexpected token issuer %q", tok.Issuer())
	}

	return claimsFromToken(tok)
}

// claimsFromToken extracts the Claims we use for authorization.
func claimsFromToken(tok jwt.Token) (*Claims, error) {
	raw, ok := tok.Get("id")
	userID, _ := raw.(string)
	if !ok || userID == "" {
		return nil, fmt.Errorf("token is missing the user id claim")
	}

	claims := &Claims{
		UserID:      userID,
		AppAccess:   boolClaim(tok, "app_access"),
		AdminAccess: boolClaim(tok, "admin_access"),
	}

	if raw, ok := tok.Get("role"); ok {
		if s, ok := raw.(string); ok {
			claims.Role = s
		}
	}

	return claims, nil
}

// boolClaim reads a boolean claim, defaulting to false when it is absent or not
// a boolean.
func boolClaim(tok jwt.Token, key string) bool {
	raw, ok := tok.Get(key)
	if !ok {
		return false
	}
	val, _ := raw.(bool)
	return val
}
