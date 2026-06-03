-- name: getGlobalConfig :one
SELECT id, live_online, npaw_enabled, livestream_url FROM globalconfig LIMIT 1;
