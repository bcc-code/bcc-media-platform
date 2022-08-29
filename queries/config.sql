-- name: getAppConfig :one
SELECT id, app_version FROM appconfig LIMIT 1;

-- name: getGlobalConfig :one
SELECT id, live_online, npaw_enabled FROM globalconfig LIMIT 1;
