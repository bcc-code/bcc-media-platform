-- name: ListCollections :many
SELECT * FROM collections_expanded;

-- name: GetCollections :many
SELECT * FROM collections_expanded c WHERE c.id = ANY($1::int[]);
