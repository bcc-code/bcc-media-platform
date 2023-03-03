-- name: getUserCollections :many
SELECT c.id, c.profile_id, c.updated_at, c.created_at, c.title, c.metadata
FROM users.collections c
WHERE id = ANY (@ids::uuid[]);

-- name: getUserCollectionEntries :many
SELECT ce.id, ce.collection_id, ce.updated_at, ce.created_at, ce.sort, ce.type, ce.item_id
FROM users.collectionentries ce
WHERE ce.id = ANY (@ids::uuid[]);

-- name: getUserCollectionIDsForProfileIDs :many
SELECT c.id, c.profile_id AS parent_id
FROM users.collections c
WHERE c.profile_id = ANY (@profile_ids::uuid[]);

-- name: getUserCollectionEntryIDsForUserCollectionIDs :many
SELECT ce.id, ce.collection_id AS parent_id
FROM users.collectionentries ce
WHERE ce.collection_id = ANY (@collection_ids::uuid[]);
