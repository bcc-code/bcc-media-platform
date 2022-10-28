-- name: InsertShow :exec
INSERT INTO shows (id, type, legacy_id, title, description, image, default_episode) VALUES (?, ?, ?, ?, ?, ?, ?);

