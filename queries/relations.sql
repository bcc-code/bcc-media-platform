-- name: getSongs :many
SELECT *
FROM songs
WHERE id = ANY (@ids::uuid[]);

-- name: getPersons :many
SELECT *
FROM persons
WHERE id = ANY (@ids::uuid[]);
