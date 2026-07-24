-- name: CreateAdminSession :exec
INSERT INTO users.admin_sessions (user_id, token_hash, expires_at)
VALUES ($1, $2, $3);

-- name: RotateAdminSession :one
-- Atomic compare-and-swap: matching on the OLD hash means only one of
-- several concurrent refreshes with the same cookie can win; the losers
-- match zero rows.
UPDATE users.admin_sessions
SET token_hash = sqlc.arg(new_token_hash),
    expires_at = sqlc.arg(expires_at)
WHERE token_hash = sqlc.arg(old_token_hash)
  AND expires_at > now()
RETURNING id, user_id;

-- name: DeleteAdminSessionByID :exec
DELETE
FROM users.admin_sessions
WHERE id = $1;

-- name: DeleteAdminSessionByTokenHash :exec
DELETE
FROM users.admin_sessions
WHERE token_hash = $1;

-- name: DeleteExpiredAdminSessions :exec
DELETE
FROM users.admin_sessions
WHERE expires_at < now();
