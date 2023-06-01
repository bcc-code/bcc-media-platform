-- name: getUserCollections :many
SELECT c.id, c.applicationgroup_id, c.profile_id, c.updated_at, c.created_at, c.title, c.my_list
FROM users.collections c
WHERE id = ANY (@ids::uuid[]);

-- name: getUserCollectionEntries :many
SELECT ce.id, ce.collection_id, ce.updated_at, ce.created_at, ce.sort, ce.type, ce.item_id
FROM users.collectionentries ce
WHERE ce.id = ANY (@ids::uuid[]);

-- name: getMyListCollectionForProfileIDs :many
SELECT c.id, c.profile_id AS parent_id
FROM users.collections c
WHERE c.profile_id = ANY (@profile_ids::uuid[])
  AND my_list;

-- name: getUserCollectionIDsForProfileIDs :many
SELECT c.id, c.profile_id AS parent_id
FROM users.collections c
WHERE c.profile_id = ANY (@profile_ids::uuid[])
  AND my_list;

-- name: getUserCollectionEntryIDsForUserCollectionIDs :many
SELECT ce.id, ce.collection_id AS parent_id
FROM users.collectionentries ce
WHERE ce.collection_id = ANY (@collection_ids::uuid[])
ORDER BY ce.updated_at DESC;

-- name: UpsertUserCollection :exec
INSERT INTO users.collections (id, applicationgroup_id, profile_id, updated_at, created_at, my_list, title)
VALUES (@id, @applicationgroup_id, @profile_id, now(), now(), @my_list, @title)
ON CONFLICT (id) DO UPDATE SET updated_at = now(),
                               title      = EXCLUDED.title;

-- name: UpsertUserCollectionEntry :exec
INSERT INTO users.collectionentries (id, collection_id, sort, type, item_id, created_at, updated_at)
VALUES (@id, @collection_id, @sort, @type, @item_id, now(), now())
ON CONFLICT(id) DO UPDATE SET sort       = EXCLUDED.sort,
                              updated_at = EXCLUDED.updated_at;

-- name: DeleteUserCollectionEntry :exec
DELETE
FROM users.collectionentries
WHERE id = $1;
