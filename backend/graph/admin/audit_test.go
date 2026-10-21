package graph

import (
	"errors"
	"testing"

	"github.com/99designs/gqlgen/graphql"
	"github.com/bcc-code/bcc-media-platform/backend/graph/admin/model"
	"github.com/google/uuid"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"github.com/vektah/gqlparser/v2"
	"github.com/vektah/gqlparser/v2/ast"
)

func TestSchema_WriteFieldsDeclareAudit(t *testing.T) {
	schema, err := gqlparser.LoadSchema(&ast.Source{Name: "schema.graphqls", Input: mustReadSchema(t)})
	require.NoError(t, err)

	for _, root := range schema.Mutation.Fields {
		if root.Name == "auth" || root.Name[:2] == "__" {
			continue
		}
		for _, f := range schema.Types[root.Type.Name()].Fields {
			assert.NotNil(t, f.Directives.ForName("audit"), "mutation %s.%s must declare @audit", root.Name, f.Name)
		}
	}

	for _, def := range schema.Types {
		for _, f := range def.Fields {
			access := f.Directives.ForName("access")
			if access == nil || access.Arguments.ForName("level").Value.Raw != string(model.AccessLevelWrite) {
				continue
			}
			assert.NotNil(t, f.Directives.ForName("audit"), "write field %s.%s must declare @audit", def.Name, f.Name)
		}
	}
}

func TestAuditAction(t *testing.T) {
	root := &graphql.FieldContext{Field: graphql.CollectedField{Field: &ast.Field{Name: "episodeAccess", Alias: "ea"}}}
	leaf := &graphql.FieldContext{Parent: root, Field: graphql.CollectedField{Field: &ast.Field{Name: "grant", Alias: "g"}}}
	assert.Equal(t, "episodeAccess.grant", auditAction(leaf))
}

func TestAuditEntry(t *testing.T) {
	keyID := uuid.New()
	args := map[string]any{"id": "abc"}

	t.Run("api key with admin user", func(t *testing.T) {
		p := &Principal{authMethod: model.AuditAuthMethodAPIKey, apiKeyID: uuid.NullUUID{UUID: keyID, Valid: true}, apiKeyName: "ci", adminUser: "someone@bcc.no"}
		e, err := auditEntry(p, "access.revokeApiKey", args, nil)
		require.NoError(t, err)
		assert.Equal(t, "apiKey", e.AuthMethod)
		assert.Equal(t, keyID, e.ApiKeyID.UUID)
		assert.Equal(t, "ci", e.ApiKeyName.String)
		assert.Equal(t, "someone@bcc.no", e.AdminUserHeader.String)
		assert.False(t, e.UserID.Valid)
		assert.JSONEq(t, `{"id":"abc"}`, string(e.Arguments))
		assert.True(t, e.Success)
		assert.False(t, e.Error.Valid)
	})

	t.Run("api key without admin user", func(t *testing.T) {
		p := &Principal{authMethod: model.AuditAuthMethodAPIKey, apiKeyID: uuid.NullUUID{UUID: keyID, Valid: true}, apiKeyName: "ci"}
		e, err := auditEntry(p, "access.revokeApiKey", args, nil)
		require.NoError(t, err)
		assert.False(t, e.AdminUserHeader.Valid)
	})

	t.Run("user", func(t *testing.T) {
		userID := uuid.New()
		p := &Principal{authMethod: model.AuditAuthMethodUser, userID: uuid.NullUUID{UUID: userID, Valid: true}, email: "admin@bcc.no"}
		e, err := auditEntry(p, "access.revokeApiKey", nil, nil)
		require.NoError(t, err)
		assert.Equal(t, "user", e.AuthMethod)
		assert.Equal(t, userID, e.UserID.UUID)
		assert.Equal(t, "admin@bcc.no", e.UserEmail.String)
		assert.False(t, e.ApiKeyID.Valid)
		assert.JSONEq(t, `{}`, string(e.Arguments))
	})

	t.Run("failed call", func(t *testing.T) {
		p := &Principal{superuser: true, authMethod: model.AuditAuthMethodDirectus}
		e, err := auditEntry(p, "episodes.importTimedMetadata", args, errors.New("forbidden"))
		require.NoError(t, err)
		assert.Equal(t, "directus", e.AuthMethod)
		assert.False(t, e.Success)
		assert.Equal(t, "forbidden", e.Error.String)
	})
}

func TestTruncate(t *testing.T) {
	assert.Equal(t, "ab", truncate("abc", 2))
	assert.Equal(t, "æø", truncate("æøå", 2))
	assert.Equal(t, "abc", truncate("abc", 5))
}
