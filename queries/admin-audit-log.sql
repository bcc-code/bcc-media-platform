-- name: InsertAdminAuditLog :exec
INSERT INTO users.admin_audit_log (action, arguments, auth_method, user_id, user_email, api_key_id, api_key_name,
                                   admin_user_header, success, error)
VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10);

-- name: ListAdminAuditLog :many
SELECT id,
       created_at,
       action,
       arguments,
       auth_method,
       user_id,
       user_email,
       api_key_id,
       api_key_name,
       admin_user_header,
       success,
       error
FROM users.admin_audit_log
WHERE (sqlc.narg(action)::text IS NULL OR action = sqlc.narg(action))
  AND (sqlc.narg(api_key_id)::uuid IS NULL OR api_key_id = sqlc.narg(api_key_id))
  AND (sqlc.narg(user_id)::uuid IS NULL OR user_id = sqlc.narg(user_id))
ORDER BY created_at DESC, id DESC
LIMIT sqlc.arg(lim) OFFSET sqlc.arg(off);

-- name: CountAdminAuditLog :one
SELECT count(*)
FROM users.admin_audit_log
WHERE (sqlc.narg(action)::text IS NULL OR action = sqlc.narg(action))
  AND (sqlc.narg(api_key_id)::uuid IS NULL OR api_key_id = sqlc.narg(api_key_id))
  AND (sqlc.narg(user_id)::uuid IS NULL OR user_id = sqlc.narg(user_id));

-- name: ListAdminAuditLogActions :many
SELECT DISTINCT action
FROM users.admin_audit_log
ORDER BY action;
