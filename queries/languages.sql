-- name: GetLanguages :many
SELECT * FROM languages WHERE code != '';

-- name: GetLanguageKeys :many
SELECT code FROM languages WHERE code != '';
