package graph

import (
	"context"
	"encoding/json"
	"net/http/httptest"
	"testing"

	"github.com/99designs/gqlgen/graphql"
	"github.com/bcc-code/bcc-media-platform/backend/graph/admin/model"
	"github.com/bcc-code/bcc-media-platform/backend/search"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"github.com/gin-gonic/gin"
	"github.com/samber/lo"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"github.com/vektah/gqlparser/v2"
	"github.com/vektah/gqlparser/v2/ast"
)

func TestSchema_RootFieldsDeclareAccess(t *testing.T) {
	schema, err := gqlparser.LoadSchema(&ast.Source{Name: "schema.graphqls", Input: mustReadSchema(t)})
	require.NoError(t, err)

	for _, root := range []*ast.Definition{schema.Query, schema.Mutation} {
		for _, f := range root.Fields {
			if f.Name == "auth" || f.Name[:2] == "__" {
				continue
			}
			ok := f.Directives.ForName("access") != nil || f.Directives.ForName("superuser") != nil
			assert.True(t, ok, "%s.%s must declare @access or @superuser", root.Name, f.Name)
		}
	}
}

func searchGrant(level model.AccessLevel, forced string) permissionRow {
	return permissionRow{resource: "search", access: string(level), forcedFilter: json.RawMessage(forced)}
}

func TestPrincipal_Allows(t *testing.T) {
	var none *Principal
	assert.False(t, none.allows(model.AdminResourceSearch, model.AccessLevelRead))

	su := &Principal{superuser: true}
	assert.True(t, su.allows(model.AdminResourceStatistics, model.AccessLevelWrite))

	reader := newPrincipal([]permissionRow{searchGrant(model.AccessLevelRead, "{}"), {resource: "gone", access: "read"}})
	assert.True(t, reader.allows(model.AdminResourceSearch, model.AccessLevelRead))
	assert.False(t, reader.allows(model.AdminResourceSearch, model.AccessLevelWrite))
	assert.False(t, reader.allows(model.AdminResourcePreview, model.AccessLevelRead))

	writer := newPrincipal([]permissionRow{searchGrant(model.AccessLevelWrite, "{}")})
	assert.True(t, writer.allows(model.AdminResourceSearch, model.AccessLevelRead), "write implies read")
}

func TestPrincipal_ForcedFilter(t *testing.T) {
	p := newPrincipal([]permissionRow{searchGrant(model.AccessLevelRead, `{"search":{"group":"bcc-members","types":["episode"]}}`)})
	f := p.forcedFilter(model.AdminResourceSearch)
	require.NotNil(t, f)
	assert.Equal(t, "bcc-members", *f.Search.Group)
	assert.Equal(t, []model.SearchType{model.SearchTypeEpisode}, f.Search.Types)

	assert.Nil(t, newPrincipal([]permissionRow{searchGrant(model.AccessLevelRead, "{}")}).forcedFilter(model.AdminResourceSearch))
	assert.Nil(t, (&Principal{superuser: true}).forcedFilter(model.AdminResourceSearch))

	broken := newPrincipal([]permissionRow{searchGrant(model.AccessLevelRead, `{"search":`)})
	assert.False(t, broken.allows(model.AdminResourceSearch, model.AccessLevelRead), "unreadable restriction drops the grant")
}

func TestPermissionRowsFromInput(t *testing.T) {
	group := "bcc-members"
	pinned := &model.ForcedFilterInput{Search: &model.ForcedSearchFilterInput{Group: &group}}

	rows, err := permissionRowsFromInput([]*model.PermissionInput{
		{Resource: model.AdminResourceSearch, Level: model.AccessLevelRead, ForcedFilter: pinned},
		{Resource: model.AdminResourcePreview, Level: model.AccessLevelWrite},
	})
	require.NoError(t, err)
	require.Len(t, rows, 2)
	assert.JSONEq(t, `{"search":{"group":"bcc-members"}}`, string(rows[0].forcedFilter))
	assert.JSONEq(t, `{}`, string(rows[1].forcedFilter))

	_, err = permissionRowsFromInput([]*model.PermissionInput{
		{Resource: model.AdminResourcePreview, Level: model.AccessLevelRead, ForcedFilter: pinned},
	})
	assert.Error(t, err, "search filter on another resource")

	_, err = permissionRowsFromInput([]*model.PermissionInput{
		{Resource: model.AdminResourceSearch, Level: model.AccessLevelRead},
		{Resource: model.AdminResourceSearch, Level: model.AccessLevelWrite},
	})
	assert.Error(t, err, "duplicate resource")
}

func TestApplyForcedSearchFilter(t *testing.T) {
	group, forcedGroup := "public", "bcc-members"
	forced := &model.ForcedFilterInput{Search: &model.ForcedSearchFilterInput{
		Group: &forcedGroup,
		Types: []model.SearchType{model.SearchTypeEpisode, model.SearchTypeShow},
	}}

	f := search.AdminFilter{Group: &group}
	assert.True(t, applyForcedSearchFilter(&f, forced))
	assert.Equal(t, "bcc-members", *f.Group)
	assert.ElementsMatch(t, []string{"episode", "show"}, f.Types)

	f = search.AdminFilter{Types: []string{"show", "season"}}
	assert.True(t, applyForcedSearchFilter(&f, forced))
	assert.Equal(t, []string{"show"}, f.Types)

	f = search.AdminFilter{Types: []string{"season"}}
	assert.False(t, applyForcedSearchFilter(&f, forced))

	f = search.AdminFilter{Group: &group}
	assert.True(t, applyForcedSearchFilter(&f, nil))
	assert.Equal(t, "public", *f.Group)
}

func ctxWithPrincipal(p *Principal) context.Context {
	ginCtx, _ := gin.CreateTestContext(httptest.NewRecorder())
	if p != nil {
		ginCtx.Set(ctxPrincipal, p)
	}
	return utils.ContextWithGinContext(context.Background(), ginCtx)
}

func TestAccessDirective(t *testing.T) {
	next := func(context.Context) (any, error) { return "ok", nil }
	reader := newPrincipal([]permissionRow{searchGrant(model.AccessLevelRead, "{}")})

	res, err := AccessDirective(ctxWithPrincipal(reader), nil, next, model.AdminResourceSearch, model.AccessLevelRead)
	assert.NoError(t, err)
	assert.Equal(t, "ok", res)

	_, err = AccessDirective(ctxWithPrincipal(reader), nil, next, model.AdminResourceSearch, model.AccessLevelWrite)
	assert.Error(t, err)

	_, err = AccessDirective(ctxWithPrincipal(nil), nil, next, model.AdminResourceSearch, model.AccessLevelRead)
	assert.Error(t, err)
}

func TestSuperuserDirective(t *testing.T) {
	next := func(context.Context) (any, error) { return "ok", nil }

	_, err := SuperuserDirective(ctxWithPrincipal(&Principal{superuser: true}), nil, next)
	assert.NoError(t, err)

	writer := newPrincipal([]permissionRow{{resource: "preview", access: "write", forcedFilter: json.RawMessage("{}")}})
	_, err = SuperuserDirective(ctxWithPrincipal(writer), nil, next)
	assert.Error(t, err)

	_, err = SuperuserDirective(ctxWithPrincipal(nil), nil, next)
	assert.Error(t, err)
}

func runAuth(t *testing.T, ext AuthExtension, apiKey string) (*Principal, bool) {
	t.Helper()
	ginCtx, _ := gin.CreateTestContext(httptest.NewRecorder())
	ginCtx.Request = httptest.NewRequest("POST", "/admin", nil)
	if apiKey != "" {
		ginCtx.Request.Header.Set("x-api-key", apiKey)
	}
	ctx := utils.ContextWithGinContext(context.Background(), ginCtx)
	op := parseOperation(t, `query { search { query(query: "x") { total } } }`)
	err := ext.MutateOperationContext(ctx, &graphql.OperationContext{Operation: op})
	return principalFromCtx(ctx), err == nil
}

func TestAuthExtension_Keys(t *testing.T) {
	ext := AuthExtension{DirectusSecret: "directus"}

	p, ok := runAuth(t, ext, "directus")
	assert.True(t, ok)
	assert.True(t, lo.FromPtr(p).superuser)

	_, ok = runAuth(t, ext, "")
	assert.False(t, ok)

	// Not shaped like an API key, so rejected before any DB lookup.
	_, ok = runAuth(t, ext, "wrong")
	assert.False(t, ok)
}

func TestNewAPIKey(t *testing.T) {
	plain, hash, err := newAPIKey()
	require.NoError(t, err)
	assert.Regexp(t, `^bccm_[A-Za-z0-9_-]{43}$`, plain)
	assert.Equal(t, hashRefreshToken(plain), hash)
}
