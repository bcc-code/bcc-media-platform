-- name: CreateAdminSession :exec
INSERT INTO users.admin_sessions (user_id, token_hash, expires_at)
VALUES ($1, $2, $3);

-- name: GetAdminSessionByTokenHash :one
SELECT id, user_id, token_hash, created_at, expires_at
FROM users.admin_sessions
WHERE token_hash = $1
  AND expires_at > now();

-- name: RotateAdminSession :exec
UPDATE users.admin_sessions
SET token_hash = $2,
    expires_at = $3
WHERE id = $1;

-- name: DeleteAdminSessionByTokenHash :exec
DELETE
FROM users.admin_sessions
WHERE token_hash = $1;

-- name: DeleteExpiredAdminSessions :exec
DELETE
FROM users.admin_sessions
WHERE expires_at < now();
