-- name: InsertSeason :exec
INSERT INTO seasons (id, legacy_id, tag_ids, number, age_rating, title, description, show_id, images)
VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);
