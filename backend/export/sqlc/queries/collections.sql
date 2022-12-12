-- name: InsertCollection :exec
INSERT INTO collections (id, name, collection_items)
VALUES (?,?,?);
