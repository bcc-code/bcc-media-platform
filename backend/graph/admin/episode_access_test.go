package graph

import (
	"encoding/json"
	"testing"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/graph/admin/model"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func episodeAccessGrant(scope string) permissionRow {
	return permissionRow{resource: "episodeAccess", access: "write", scope: json.RawMessage(scope)}
}

func TestPrincipal_AllowedGroups(t *testing.T) {
	_, all := (&Principal{superuser: true}).allowedGroups()
	assert.True(t, all, "superuser")

	_, all = newPrincipal([]permissionRow{episodeAccessGrant("{}")}).allowedGroups()
	assert.True(t, all, "no scope")

	codes, all := newPrincipal([]permissionRow{episodeAccessGrant(`{"episodeAccess":{}}`)}).allowedGroups()
	assert.False(t, all, "stored scope without groups allows nothing")
	assert.Empty(t, codes)

	codes, all = newPrincipal([]permissionRow{episodeAccessGrant(`{"episodeAccess":{"groups":["public","kids-public"]}}`)}).allowedGroups()
	assert.False(t, all)
	assert.Equal(t, []string{"public", "kids-public"}, codes)
}

func TestPermissionRowsFromInput_EpisodeAccessScope(t *testing.T) {
	scope := &model.PermissionScopeInput{EpisodeAccess: &model.EpisodeAccessScopeInput{Groups: []string{"public"}}}

	rows, err := permissionRowsFromInput([]*model.PermissionInput{
		{Resource: model.AdminResourceEpisodeAccess, Level: model.AccessLevelWrite, Scope: scope},
	})
	require.NoError(t, err)
	assert.JSONEq(t, `{"episodeAccess":{"groups":["public"]}}`, string(rows[0].scope))

	// Round trip through storage: omitempty drops [] and the grant must stay restricted.
	rows, err = permissionRowsFromInput([]*model.PermissionInput{
		{Resource: model.AdminResourceEpisodeAccess, Level: model.AccessLevelWrite, Scope: &model.PermissionScopeInput{EpisodeAccess: &model.EpisodeAccessScopeInput{Groups: []string{}}}},
	})
	require.NoError(t, err)
	codes, all := newPrincipal(rows).allowedGroups()
	assert.False(t, all, "empty allowlist stays restricted; stored %s", rows[0].scope)
	assert.Empty(t, codes)
	assert.Equal(t, []string{}, permissionsToModel(rows)[0].Scope.EpisodeAccess.Groups, "read back as an empty list, not null")

	rows, err = permissionRowsFromInput([]*model.PermissionInput{
		{Resource: model.AdminResourceEpisodeAccess, Level: model.AccessLevelWrite, Scope: &model.PermissionScopeInput{EpisodeAccess: &model.EpisodeAccessScopeInput{}}},
	})
	require.NoError(t, err)
	assert.JSONEq(t, `{}`, string(rows[0].scope), "null groups is no scope")
	_, all = newPrincipal(rows).allowedGroups()
	assert.True(t, all)

	_, err = permissionRowsFromInput([]*model.PermissionInput{
		{Resource: model.AdminResourceSearch, Level: model.AccessLevelRead, Scope: scope},
	})
	assert.Error(t, err, "episodeAccess scope on another resource")

	group := "bcc-members"
	_, err = permissionRowsFromInput([]*model.PermissionInput{
		{Resource: model.AdminResourceEpisodeAccess, Level: model.AccessLevelWrite, Scope: &model.PermissionScopeInput{Search: &model.SearchScopeInput{Group: &group}}},
	})
	assert.Error(t, err, "search scope on episodeAccess")
}

func TestIsAutoGroup(t *testing.T) {
	apps := []common.Application{{Code: "kids-mobile", GroupLabel: "Bible Kids"}}

	for _, c := range []string{"public", "registered", "bcc-members", "non-bcc-members", "kids-mobile-public", "bible-kids-bcc-members"} {
		assert.True(t, isAutoGroup(c, apps), c)
	}
	for _, c := range []string{"my-custom-group", "kids-mobile-", "kids-mobile-custom", "other-app-public", "age-group:10-12"} {
		assert.False(t, isAutoGroup(c, apps), c)
	}
}
