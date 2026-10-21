package graph

import (
	"context"
	"database/sql"
	"errors"
	"fmt"
	"strings"
	"time"

	"github.com/bcc-code/bcc-media-platform/backend/graph/admin/model"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/google/uuid"
	"github.com/samber/lo"
	"gopkg.in/guregu/null.v4"
)

func formatTime(t null.Time) *string {
	if !t.Valid {
		return nil
	}
	s := t.Time.Format(time.RFC3339)
	return &s
}

func apiKeyToModel(k sqlc.ListApiKeysRow) *model.APIKey {
	out := &model.APIKey{
		ID:        k.ID.String(),
		Name:      k.Name,
		Prefix:    k.KeyPrefix,
		CreatedAt: k.CreatedAt.Format(time.RFC3339),
		ExpiresAt: formatTime(k.ExpiresAt),
		RevokedAt: formatTime(k.RevokedAt),
	}
	if k.CreatedBy.Valid {
		out.CreatedBy = lo.ToPtr(k.CreatedBy.UUID.String())
	}
	return out
}

func (r *Resolver) getAPIKey(ctx context.Context, id uuid.UUID) (*model.APIKey, error) {
	k, err := r.Queries.GetApiKey(ctx, id)
	if errors.Is(err, sql.ErrNoRows) {
		return nil, fmt.Errorf("api key not found")
	}
	if err != nil {
		return nil, err
	}
	return apiKeyToModel(sqlc.ListApiKeysRow(k)), nil
}

func (r *Resolver) getRole(ctx context.Context, id uuid.UUID) (*model.Role, error) {
	role, err := r.Queries.GetDirectusRole(ctx, id)
	if errors.Is(err, sql.ErrNoRows) {
		return nil, fmt.Errorf("role not found")
	}
	if err != nil {
		return nil, err
	}
	return &model.Role{ID: role.ID.String(), Name: role.Name}, nil
}

// permissionOwner is either an API key or a Directus role.
type permissionOwner struct {
	apiKeyID uuid.NullUUID
	roleID   uuid.NullUUID
}

// replacePermissions runs prepare and then swaps the owner's grants for rows, in one transaction.
func (r *Resolver) replacePermissions(ctx context.Context, rows []permissionRow, prepare func(q *sqlc.Queries) (permissionOwner, error)) error {
	tx, err := r.DB.BeginTx(ctx, nil)
	if err != nil {
		return err
	}
	defer tx.Rollback() //nolint:errcheck
	q := r.Queries.WithTx(tx)

	owner, err := prepare(q)
	if err != nil {
		return err
	}
	if owner.apiKeyID.Valid {
		err = q.DeleteAdminPermissionsForApiKey(ctx, owner.apiKeyID)
	} else {
		err = q.DeleteAdminPermissionsForRole(ctx, owner.roleID)
	}
	if err != nil {
		return err
	}
	for _, row := range rows {
		err := q.InsertAdminPermission(ctx, sqlc.InsertAdminPermissionParams{
			ApiKeyID:       owner.apiKeyID,
			DirectusRoleID: owner.roleID,
			Resource:       row.resource,
			Access:         row.access,
			Scope:          row.scope,
		})
		if err != nil {
			return err
		}
	}
	return tx.Commit()
}

func parseAPIKeyInput(input model.APIKeyInput) (string, null.Time, []permissionRow, error) {
	name := strings.TrimSpace(input.Name)
	if name == "" {
		return "", null.Time{}, nil, fmt.Errorf("name is required")
	}
	var expiresAt null.Time
	if input.ExpiresAt != nil {
		t, err := time.Parse(time.RFC3339, *input.ExpiresAt)
		if err != nil {
			return "", null.Time{}, nil, fmt.Errorf("expiresAt must be RFC3339: %w", err)
		}
		expiresAt = null.TimeFrom(t)
	}
	rows, err := permissionRowsFromInput(input.Permissions)
	return name, expiresAt, rows, err
}

func (r *Resolver) createAPIKey(ctx context.Context, input model.APIKeyInput) (*model.CreatedAPIKey, error) {
	caller := principalFromCtx(ctx)
	name, expiresAt, rows, err := parseAPIKeyInput(input)
	if err != nil {
		return nil, err
	}
	plain, hash, err := newAPIKey()
	if err != nil {
		return nil, err
	}

	var id uuid.UUID
	err = r.replacePermissions(ctx, rows, func(q *sqlc.Queries) (permissionOwner, error) {
		var err error
		id, err = q.CreateApiKey(ctx, sqlc.CreateApiKeyParams{
			Name:      name,
			KeyPrefix: plain[:len(apiKeyPrefix)+6],
			KeyHash:   hash,
			CreatedBy: caller.userID,
			ExpiresAt: expiresAt,
		})
		return permissionOwner{apiKeyID: uuid.NullUUID{UUID: id, Valid: true}}, err
	})
	if err != nil {
		return nil, err
	}

	key, err := r.getAPIKey(ctx, id)
	if err != nil {
		return nil, err
	}
	return &model.CreatedAPIKey{APIKey: key, Key: plain}, nil
}

func (r *Resolver) updateAPIKey(ctx context.Context, rawID string, input model.APIKeyInput) (*model.APIKey, error) {
	id, err := uuid.Parse(rawID)
	if err != nil {
		return nil, fmt.Errorf("invalid id: %w", err)
	}
	if _, err := r.getAPIKey(ctx, id); err != nil {
		return nil, err
	}
	name, expiresAt, rows, err := parseAPIKeyInput(input)
	if err != nil {
		return nil, err
	}

	err = r.replacePermissions(ctx, rows, func(q *sqlc.Queries) (permissionOwner, error) {
		err := q.UpdateApiKey(ctx, sqlc.UpdateApiKeyParams{ID: id, Name: name, ExpiresAt: expiresAt})
		return permissionOwner{apiKeyID: uuid.NullUUID{UUID: id, Valid: true}}, err
	})
	if err != nil {
		return nil, err
	}
	return r.getAPIKey(ctx, id)
}

func (r *Resolver) revokeAPIKey(ctx context.Context, rawID string) (bool, error) {
	id, err := uuid.Parse(rawID)
	if err != nil {
		return false, fmt.Errorf("invalid id: %w", err)
	}
	if _, err := r.getAPIKey(ctx, id); err != nil {
		return false, err
	}
	return true, r.Queries.RevokeApiKey(ctx, id)
}

func (r *Resolver) setRolePermissions(ctx context.Context, rawID string, permissions []*model.PermissionInput) (*model.Role, error) {
	id, err := uuid.Parse(rawID)
	if err != nil {
		return nil, fmt.Errorf("invalid id: %w", err)
	}
	role, err := r.getRole(ctx, id)
	if err != nil {
		return nil, err
	}
	rows, err := permissionRowsFromInput(permissions)
	if err != nil {
		return nil, err
	}

	err = r.replacePermissions(ctx, rows, func(*sqlc.Queries) (permissionOwner, error) {
		return permissionOwner{roleID: uuid.NullUUID{UUID: id, Valid: true}}, nil
	})
	return role, err
}

func (r *Resolver) listAPIKeys(ctx context.Context) ([]*model.APIKey, error) {
	keys, err := r.Queries.ListApiKeys(ctx)
	if err != nil {
		return nil, err
	}
	return lo.Map(keys, func(k sqlc.ListApiKeysRow, _ int) *model.APIKey { return apiKeyToModel(k) }), nil
}

func (r *Resolver) listRoles(ctx context.Context) ([]*model.Role, error) {
	roles, err := r.Queries.ListDirectusRoles(ctx)
	if err != nil {
		return nil, err
	}
	return lo.Map(roles, func(role sqlc.ListDirectusRolesRow, _ int) *model.Role {
		return &model.Role{ID: role.ID.String(), Name: role.Name}
	}), nil
}

func (r *Resolver) apiKeyPermissions(ctx context.Context, rawID string) ([]*model.Permission, error) {
	id, err := uuid.Parse(rawID)
	if err != nil {
		return nil, err
	}
	rows, err := apiKeyPermissionRows(ctx, r.Queries, id)
	return permissionsToModel(rows), err
}

func (r *Resolver) rolePermissions(ctx context.Context, rawID string) ([]*model.Permission, error) {
	id, err := uuid.Parse(rawID)
	if err != nil {
		return nil, err
	}
	rows, err := rolePermissionRows(ctx, r.Queries, id)
	return permissionsToModel(rows), err
}
