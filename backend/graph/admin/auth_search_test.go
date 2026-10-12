package graph

import (
	"context"
	"net/http/httptest"
	"testing"

	"github.com/99designs/gqlgen/graphql"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
)

const searchQuery = `query { search { query(query: "x", filter: {group: "public"}) { total group hits { id type item { ... on Episode { id title availability { published } } } } } } }`

func TestIsSearchOnlyOperation(t *testing.T) {
	cases := []struct {
		name  string
		query string
		want  bool
	}{
		{"search", searchQuery, true},
		{"search with typename", `query { __typename search { query(query: "x") { total } } }`, true},
		{"search and statistics", `query { search { query(query: "x") { total } } preview { asset(id: "1") { url } } }`, false},
		{"preview", `query { preview { collection(filter: "{}") { items { id } } } }`, false},
		{"fragment at root", `query { ...F } fragment F on QueryRoot { search { query(query: "x") { total } } }`, false},
		{"mutation", `mutation { auth { logout } }`, false},
	}
	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			assert.Equal(t, tc.want, isSearchOnlyOperation(parseOperation(t, tc.query)))
		})
	}
}

func runAuth(t *testing.T, ext AuthExtension, apiKey, query string) (*gin.Context, bool) {
	t.Helper()
	ginCtx, _ := gin.CreateTestContext(httptest.NewRecorder())
	ginCtx.Request = httptest.NewRequest("POST", "/admin", nil)
	ginCtx.Request.Header.Set("x-api-key", apiKey)
	ctx := utils.ContextWithGinContext(context.Background(), ginCtx)
	err := ext.MutateOperationContext(ctx, &graphql.OperationContext{Operation: parseOperation(t, query)})
	return ginCtx, err == nil
}

func TestAuthExtension_SearchKeys(t *testing.T) {
	ext := AuthExtension{
		DirectusSecret: "directus",
		SearchKeys:     map[string]string{"pinned": "bcc-members"},
	}

	ginCtx, ok := runAuth(t, ext, "pinned", searchQuery)
	assert.True(t, ok)
	assert.Equal(t, "bcc-members", ginCtx.GetString(ctxForcedSearchGroup))

	_, ok = runAuth(t, ext, "pinned", `query { preview { asset(id: "1") { url } } }`)
	assert.False(t, ok, "search keys must not grant access to other operations")

	ginCtx, ok = runAuth(t, ext, "directus", searchQuery)
	assert.True(t, ok)
	assert.Empty(t, ginCtx.GetString(ctxForcedSearchGroup))

	_, ok = runAuth(t, ext, "", searchQuery)
	assert.False(t, ok)

	_, ok = runAuth(t, ext, "wrong", searchQuery)
	assert.False(t, ok)
}
