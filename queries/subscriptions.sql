-- name: AddSubscription :exec
INSERT INTO users.subscriptions (key, profile_id)
VALUES (@key, @profile_id)
ON CONFLICT DO NOTHING;

-- name: RemoveSubscription :exec
DELETE
FROM users.subscriptions
WHERE key = @key
  AND profile_id = @profile_id;

-- name: ListSubscriptions :many
SELECT key
FROM users.subscriptions
WHERE profile_id = @profile_id;
