-- name: InsertCollection :exec
INSERT INTO collections (id, name, type, collection_items)
VALUES (?,?,?,?);
