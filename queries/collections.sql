-- name: ListCollections :many
SELECT * FROM collections;

-- name: GetCollections :many
SELECT * FROM collections c WHERE c.id = ANY($1::int[]);

-- name: GetCollectionItems :many
SELECT * FROM collections_items ci WHERE ci.collection_id = ANY($1::int[]);