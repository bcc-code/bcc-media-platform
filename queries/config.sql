-- name: getGlobalConfig :one
SELECT id, live_online, npaw_enabled FROM globalconfig LIMIT 1;
