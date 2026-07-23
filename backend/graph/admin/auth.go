package graph

import (
	"context"
	"crypto/rand"
	"crypto/sha256"
	"encoding/base64"
	"encoding/hex"
	"fmt"
	"net/http"
	"strings"
	"time"

	"github.com/99designs/gqlgen/graphql"
	"github.com/bcc-code/bcc-media-platform/backend/directus"
	"github.com/bcc-code/bcc-media-platform/backend/graph/admin/model"
	"github.com/bcc-code/bcc-media-platform/backend/log"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/lestrrat-go/jwx/v2/jwa"
	"github.com/lestrrat-go/jwx/v2/jwt"
	"github.com/vektah/gqlparser/v2/ast"
	"github.com/vektah/gqlparser/v2/gqlerror"
)

// The admin API mints its own credentials: a short-lived HS256 access token
// sent as a Bearer on /admin requests, and an opaque refresh token in an
// httpOnly cookie. Directus tokens are never accepted from clients.
const (
	// authIssuer is the `iss` claim of access tokens this service mints.
	authIssuer = "bccm-admin"
	// accessTokenTTL — short-lived; the refresh cookie does the heavy
	// lifting.
	accessTokenTTL = 15 * time.Minute
	// refreshTokenTTL is the sliding session lifetime (extended on each
	// rotation).
	refreshTokenTTL = 7 * 24 * time.Hour

	refreshCookieName = "admin_session"
	// refreshCookiePath scopes the cookie to the admin GraphQL endpoint,
	// where the auth mutations live.
	refreshCookiePath = "/admin"
)

// logFieldAdminUserID is the structured-log field for the Directus user id in
// admin auth logging.
const logFieldAdminUserID = "admin_user_id"

// AuthConfig wires the admin auth mutations and the request guard.
type AuthConfig struct {
	// Directus proxies /auth mutations' credentials to the Directus login
	// endpoint. nil disables the auth mutations.
	Directus *directus.Client
	// JWTSecret is the HS256 key for access tokens THIS service mints.
	JWTSecret []byte
	// DirectusURL is used to build unauthenticated asset URLs (avatar).
	DirectusURL string
	// SecureCookie sets the Secure attribute on the refresh cookie (false
	// only for local http dev).
	SecureCookie bool
}

func (c AuthConfig) enabled() bool {
	return c.Directus != nil && len(c.JWTSecret) > 0
}

// mintAccessToken signs an HS256 access token for the given Directus user.
// Role claims are included so the frontend (and future per-field authz) can
// read them without extra lookups.
func mintAccessToken(secret []byte, u sqlc.GetDirectusUserByIDRow, now time.Time) (string, time.Time, error) {
	expiresAt := now.Add(accessTokenTTL)

	b := jwt.NewBuilder().
		Issuer(authIssuer).
		Subject(u.ID.String()).
		IssuedAt(now).
		Expiration(expiresAt).
		Claim("email", u.Email.String)

	if name := strings.TrimSpace(strings.TrimSpace(u.FirstName.String) + " " + strings.TrimSpace(u.LastName.String)); name != "" {
		b = b.Claim("name", name)
	}
	if u.Role.Valid {
		b = b.Claim("role_id", u.Role.UUID.String())
	}
	if u.RoleName.Valid {
		b = b.Claim("role_name", u.RoleName.String)
	}

	tok, err := b.Build()
	if err != nil {
		return "", time.Time{}, fmt.Errorf("build admin token: %w", err)
	}
	signed, err := jwt.Sign(tok, jwt.WithKey(jwa.HS256, secret))
	if err != nil {
		return "", time.Time{}, fmt.Errorf("sign admin token: %w", err)
	}
	return string(signed), expiresAt, nil
}

// validateAccessToken verifies an access token minted by this service and
// returns the user id from the sub claim.
func validateAccessToken(secret []byte, raw string) (uuid.UUID, error) {
	tok, err := jwt.Parse([]byte(raw),
		jwt.WithKey(jwa.HS256, secret),
		jwt.WithValidate(true),
		jwt.WithIssuer(authIssuer),
		jwt.WithAcceptableSkew(time.Minute),
	)
	if err != nil {
		return uuid.Nil, err
	}
	return uuid.Parse(tok.Subject())
}

// newRefreshToken returns a 256-bit random opaque token (base64url, no
// padding) and its storage hash.
func newRefreshToken() (plain string, hash string, err error) {
	var buf [32]byte
	if _, err := rand.Read(buf[:]); err != nil {
		return "", "", fmt.Errorf("generate refresh token: %w", err)
	}
	plain = base64.RawURLEncoding.EncodeToString(buf[:])
	return plain, hashRefreshToken(plain), nil
}

// hashRefreshToken is sha256 hex — only the digest is stored, so a DB leak
// doesn't leak usable session tokens.
func hashRefreshToken(plain string) string {
	sum := sha256.Sum256([]byte(plain))
	return hex.EncodeToString(sum[:])
}

// SameSite=Lax suffices: admin-web and the API are same-site both locally
// (localhost:4000 → localhost:8077; ports don't affect same-site) and in
// production (*.brunstad.tv).
func setRefreshCookie(c *gin.Context, value string, secure bool) {
	c.SetSameSite(http.SameSiteLaxMode)
	c.SetCookie(refreshCookieName, value, int(refreshTokenTTL.Seconds()),
		refreshCookiePath, "", secure, true)
}

func clearRefreshCookie(c *gin.Context, secure bool) {
	c.SetSameSite(http.SameSiteLaxMode)
	c.SetCookie(refreshCookieName, "", -1, refreshCookiePath, "", secure, true)
}

// loadActiveAdminUser fetches the Directus user and enforces the active
// check.
func loadActiveAdminUser(ctx context.Context, queries *sqlc.Queries, userID uuid.UUID) (sqlc.GetDirectusUserByIDRow, bool) {
	u, err := queries.GetDirectusUserByID(ctx, userID)
	if err != nil {
		log.L.Warn().Err(err).Str(logFieldAdminUserID, userID.String()).Msg("Admin user could not be loaded")
		return sqlc.GetDirectusUserByIDRow{}, false
	}
	if u.Status != "active" {
		log.L.Warn().Str(logFieldAdminUserID, userID.String()).Str("status", u.Status).Msg("Admin user is not active")
		return sqlc.GetDirectusUserByIDRow{}, false
	}
	return u, true
}

// buildAuthResult mints an access token and assembles the login/refresh
// result. The avatar URL is the unauthenticated Directus asset URL.
func buildAuthResult(cfg AuthConfig, u sqlc.GetDirectusUserByIDRow) (*model.AuthResult, error) {
	token, expiresAt, err := mintAccessToken(cfg.JWTSecret, u, time.Now())
	if err != nil {
		return nil, err
	}

	user := &model.AdminUser{
		ID:    u.ID.String(),
		Email: u.Email.String,
	}
	if u.FirstName.Valid {
		user.FirstName = &u.FirstName.String
	}
	if u.LastName.Valid {
		user.LastName = &u.LastName.String
	}
	if u.Avatar.Valid {
		url := strings.TrimSuffix(cfg.DirectusURL, "/") + "/assets/" + u.Avatar.UUID.String()
		user.AvatarURL = &url
	}

	return &model.AuthResult{
		AccessToken: token,
		ExpiresInMs: int(time.Until(expiresAt).Milliseconds()),
		User:        user,
	}, nil
}

// errUnauthenticated is returned for operations that require credentials.
// The extensions code lets admin-web distinguish auth failures from other
// errors and trigger a token refresh.
func errUnauthenticated(ctx context.Context) *gqlerror.Error {
	return &gqlerror.Error{
		Path:    graphql.GetPath(ctx),
		Message: "unauthenticated",
		Extensions: map[string]interface{}{
			"code": "UNAUTHENTICATED",
		},
	}
}

// AuthExtension enforces access to the admin GraphQL endpoint per operation:
// requests authenticate with the shared x-api-key (Directus endpoint-tools,
// server-to-server) or an access token this service minted (admin-web).
// Operations that consist solely of the `auth` mutation namespace execute
// without credentials — that's where clients obtain tokens.
type AuthExtension struct {
	Queries        *sqlc.Queries
	JWTSecret      []byte
	DirectusSecret string
}

var _ interface {
	graphql.HandlerExtension
	graphql.OperationContextMutator
} = AuthExtension{}

// ExtensionName implements graphql.HandlerExtension.
func (AuthExtension) ExtensionName() string {
	return "AdminAuth"
}

// Validate implements graphql.HandlerExtension.
func (a AuthExtension) Validate(graphql.ExecutableSchema) error {
	if a.Queries == nil {
		return fmt.Errorf("AuthExtension requires Queries")
	}
	return nil
}

// MutateOperationContext implements graphql.OperationContextMutator; it runs
// after the operation is parsed and rejects unauthenticated requests unless
// the operation only contains auth mutations.
func (a AuthExtension) MutateOperationContext(ctx context.Context, opCtx *graphql.OperationContext) *gqlerror.Error {
	if isAuthOnlyOperation(opCtx.Operation) {
		return nil
	}

	ginCtx, err := utils.GinCtx(ctx)
	if err != nil {
		log.L.Error().Err(err).Msg("Admin auth extension could not get the gin context")
		return errUnauthenticated(ctx)
	}

	// Server-to-server access from the Directus endpoint-tools extension.
	if a.DirectusSecret != "" && ginCtx.GetHeader("x-api-key") == a.DirectusSecret {
		return nil
	}

	// Browser access from admin-web with a token this service minted. The
	// user is re-checked so a deactivated account is rejected even while its
	// short-lived token is still cryptographically valid.
	if len(a.JWTSecret) > 0 {
		scheme, token, ok := strings.Cut(ginCtx.GetHeader("Authorization"), " ")
		if ok && strings.EqualFold(scheme, "Bearer") {
			userID, err := validateAccessToken(a.JWTSecret, token)
			if err != nil {
				log.L.Debug().Err(err).Msg("Rejected admin access token")
				return errUnauthenticated(ctx)
			}
			if _, ok := loadActiveAdminUser(ctx, a.Queries, userID); ok {
				return nil
			}
		}
	}

	return errUnauthenticated(ctx)
}

// isAuthOnlyOperation reports whether every root selection of the operation
// is the `auth` mutation namespace (plus introspection typename noise).
func isAuthOnlyOperation(op *ast.OperationDefinition) bool {
	if op == nil || op.Operation != ast.Mutation || len(op.SelectionSet) == 0 {
		return false
	}
	for _, sel := range op.SelectionSet {
		field, ok := sel.(*ast.Field)
		if !ok {
			return false
		}
		if field.Name != "auth" && field.Name != "__typename" {
			return false
		}
	}
	return true
}
