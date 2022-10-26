-- name: InsertSection :exec
INSERT INTO sections (id, sort, page_id, type, show_title, title, description, style, size, collection_id)
VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
