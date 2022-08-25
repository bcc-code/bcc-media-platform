-- name: getAppConfig :one
SELECT id, app_version, live FROM appconfig LIMIT 1;
