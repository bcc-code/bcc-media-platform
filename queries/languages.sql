-- name: GetLanguages :many
SELECT * FROM languages;

-- name: GetLanguageKeys :many
SELECT code FROM languages;