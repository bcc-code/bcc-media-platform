-- name: listCollections :many
SELECT * FROM collections;

-- name: getCollections :many
SELECT * FROM collections c WHERE c.id = ANY($1::int[]);

-- name: getCollectionItemsForCollections :many
SELECT * FROM collections_items ci WHERE ci.collection_id = ANY($1::int[]);