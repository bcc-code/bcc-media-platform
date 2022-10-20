-- name: InsertApplication :exec
INSERT INTO applications (id, code, client_version, default_page_id)
VALUES (?,?,?,?);
