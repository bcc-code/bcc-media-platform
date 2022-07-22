-- name: ListCollections :many
SELECT * FROM collections;

-- name: GetCollections :many
SELECT * FROM collections c WHERE c.id = ANY($1::int[]);
