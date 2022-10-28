-- name: InsertPage :exec
INSERT INTO pages (id, code, title, description, image, section_ids)
VALUES (?,?,?,?,?,?);
