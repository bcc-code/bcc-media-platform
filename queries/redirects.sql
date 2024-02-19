-- name: getRedirects :many
SELECT r.id, r.code, r.target_url, r.requires_authentication, COALESCE(r.include_token, true)::bool as include_token
FROM redirects r
WHERE r.status = 'published'
  AND r.id = ANY ($1::uuid[]);

-- name: getRedirectIDsForCodes :many
SELECT id, code
FROM redirects
WHERE status = 'published'
  AND code = ANY ($1::varchar[]);
