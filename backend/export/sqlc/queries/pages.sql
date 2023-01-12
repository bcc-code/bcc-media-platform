-- name: InsertPage :exec
INSERT INTO pages (id, code, title, description, images, section_ids)
VALUES (?,?,?,?,?,?);
