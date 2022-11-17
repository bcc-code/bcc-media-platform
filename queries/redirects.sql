-- name: GetRedirectByCode :one
SELECT * FROM redirects WHERE status = 'published' AND code = $1;
