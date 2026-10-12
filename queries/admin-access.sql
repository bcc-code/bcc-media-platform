-- name: GetActiveApiKeyByHash :one
SELECT id, name
FROM users.api_keys
WHERE key_hash = $1
  AND revoked_at IS NULL
  AND (expires_at IS NULL OR expires_at > now());

-- name: ListApiKeys :many
SELECT id, name, key_prefix, created_by, created_at, expires_at, revoked_at
FROM users.api_keys
ORDER BY created_at DESC;

-- name: GetApiKey :one
SELECT id, name, key_prefix, created_by, created_at, expires_at, revoked_at
FROM users.api_keys
WHERE id = $1;

-- name: CreateApiKey :one
INSERT INTO users.api_keys (name, key_prefix, key_hash, created_by, expires_at)
VALUES ($1, $2, $3, $4, $5)
RETURNING id;

-- name: UpdateApiKey :exec
UPDATE users.api_keys
SET name       = $2,
    expires_at = $3
WHERE id = $1;

-- name: RevokeApiKey :exec
UPDATE users.api_keys
SET revoked_at = now()
WHERE id = $1
  AND revoked_at IS NULL;

-- name: GetAdminPermissionsForApiKeys :many
SELECT api_key_id::uuid AS api_key_id, resource, access, forced_filter
FROM users.admin_permissions
WHERE api_key_id = ANY (sqlc.arg(ids)::uuid[]);

-- name: GetAdminPermissionsForRoles :many
SELECT directus_role_id::uuid AS directus_role_id, resource, access, forced_filter
FROM users.admin_permissions
WHERE directus_role_id = ANY (sqlc.arg(ids)::uuid[]);

-- name: DeleteAdminPermissionsForApiKey :exec
DELETE
FROM users.admin_permissions
WHERE api_key_id = $1;

-- name: DeleteAdminPermissionsForRole :exec
DELETE
FROM users.admin_permissions
WHERE directus_role_id = $1;

-- name: InsertAdminPermission :exec
INSERT INTO users.admin_permissions (api_key_id, directus_role_id, resource, access, forced_filter)
VALUES ($1, $2, $3, $4, $5);

-- name: ListDirectusRoles :many
SELECT id, name
FROM directus_roles
ORDER BY name;
