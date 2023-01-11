-- name: InsertShow :exec
INSERT INTO shows (id, type, legacy_id, title, description, images, default_episode) VALUES (?, ?, ?, ?, ?, ?, ?);

