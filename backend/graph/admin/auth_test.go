package graph

import (
	"os"
	"testing"
	"time"

	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/google/uuid"
	"github.com/lestrrat-go/jwx/v2/jwa"
	"github.com/lestrrat-go/jwx/v2/jwt"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"github.com/vektah/gqlparser/v2"
	"github.com/vektah/gqlparser/v2/ast"
	null_v4 "gopkg.in/guregu/null.v4"
)

var authTestSecret = []byte("admin-test-secret")

func authTestUser() sqlc.GetDirectusUserByIDRow {
	return sqlc.GetDirectusUserByIDRow{
		ID:        uuid.MustParse("11111111-1111-1111-1111-111111111111"),
		Email:     null_v4.StringFrom("admin@example.com"),
		FirstName: null_v4.StringFrom("Ada"),
		LastName:  null_v4.StringFrom("Admin"),
		Role:      uuid.NullUUID{UUID: uuid.MustParse("22222222-2222-2222-2222-222222222222"), Valid: true},
		RoleName:  null_v4.StringFrom("Administrator"),
		Status:    "active",
	}
}

func TestMintValidateRoundtrip(t *testing.T) {
	u := authTestUser()
	token, expiresAt, err := mintAccessToken(authTestSecret, u, time.Now())
	require.NoError(t, err)
	assert.WithinDuration(t, time.Now().Add(accessTokenTTL), expiresAt, 5*time.Second)

	userID, err := validateAccessToken(authTestSecret, token)
	require.NoError(t, err)
	assert.Equal(t, u.ID, userID)

	tok, err := jwt.ParseInsecure([]byte(token))
	require.NoError(t, err)
	assert.Equal(t, authIssuer, tok.Issuer())
	email, _ := tok.Get("email")
	assert.Equal(t, "admin@example.com", email)
	name, _ := tok.Get("name")
	assert.Equal(t, "Ada Admin", name)
	roleName, _ := tok.Get("role_name")
	assert.Equal(t, "Administrator", roleName)
	roleID, _ := tok.Get("role_id")
	assert.Equal(t, "22222222-2222-2222-2222-222222222222", roleID)
}

func TestValidate_WrongSecret(t *testing.T) {
	token, _, err := mintAccessToken(authTestSecret, authTestUser(), time.Now())
	require.NoError(t, err)

	_, err = validateAccessToken([]byte("a-different-secret"), token)
	assert.Error(t, err)
}

func TestValidate_WrongIssuer(t *testing.T) {
	tok, err := jwt.NewBuilder().
		Issuer("someone-else").
		Subject(authTestUser().ID.String()).
		IssuedAt(time.Now()).
		Expiration(time.Now().Add(time.Hour)).
		Build()
	require.NoError(t, err)
	signed, err := jwt.Sign(tok, jwt.WithKey(jwa.HS256, authTestSecret))
	require.NoError(t, err)

	_, err = validateAccessToken(authTestSecret, string(signed))
	assert.Error(t, err)
}

func TestValidate_Expired(t *testing.T) {
	token, _, err := mintAccessToken(authTestSecret, authTestUser(), time.Now().Add(-time.Hour))
	require.NoError(t, err)

	_, err = validateAccessToken(authTestSecret, token)
	assert.Error(t, err)
}

func TestRefreshTokens(t *testing.T) {
	plain1, hash1, err := newRefreshToken()
	require.NoError(t, err)
	plain2, hash2, err := newRefreshToken()
	require.NoError(t, err)

	assert.NotEqual(t, plain1, plain2)
	assert.NotEqual(t, hash1, hash2)
	assert.Equal(t, hashRefreshToken(plain1), hash1)
	assert.Len(t, plain1, 43) // 32 bytes base64url, no padding
}

// parseOperation parses a query against the real admin schema and returns the
// (single) operation definition, exactly what the auth extension sees.
func parseOperation(t *testing.T, query string) *ast.OperationDefinition {
	t.Helper()
	schema, err := gqlparser.LoadSchema(&ast.Source{Name: "schema.graphqls", Input: mustReadSchema(t)})
	require.NoError(t, err)
	doc, errs := gqlparser.LoadQuery(schema, query)
	require.Empty(t, errs)
	require.Len(t, doc.Operations, 1)
	return doc.Operations[0]
}

func mustReadSchema(t *testing.T) string {
	t.Helper()
	b, err := os.ReadFile("schema.graphqls")
	require.NoError(t, err)
	return string(b)
}

func TestIsAuthOnlyOperation(t *testing.T) {
	cases := []struct {
		name  string
		query string
		want  bool
	}{
		{"login", `mutation { auth { login(email: "a", password: "b") { accessToken expiresInMs user { id email } } } }`, true},
		{"refresh", `mutation { auth { refresh { accessToken expiresInMs user { id email } } } }`, true},
		{"logout with typename", `mutation { __typename auth { logout } }`, true},
		{"query", `query { preview { collection(filter: "{}") { items { id } } } }`, false},
		{"introspection", `query { __schema { types { name } } }`, false},
	}
	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			assert.Equal(t, tc.want, isAuthOnlyOperation(parseOperation(t, tc.query)))
		})
	}
}
