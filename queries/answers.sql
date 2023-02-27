-- name: GetAnswersSince :many
SELECT
	message,
	item_id,
	COALESCE(metadata->>'rating', '-1')::int + 1 as rating,
	age_group,
	org_id,
	updated_at as updated
FROM users.messages
WHERE created_at > @created_at::TIMESTAMP;

