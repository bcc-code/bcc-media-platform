-- name: InsertEpisode :exec
INSERT INTO episodes ( id, legacy_id, legacy_program_id, age_rating, title, description, extra_description, image, image_url, production_date, season_id, duration, number)
VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
