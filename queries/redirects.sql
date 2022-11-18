-- name: getRedirects :many
SELECT * FROM redirects WHERE status = 'published' AND id = ANY ($1::uuid[]);

-- name: getRedirectIDsForCodes :many
SELECT id, code FROM redirects WHERE status = 'published' AND code = ANY ($1::varchar[]);
