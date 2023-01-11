-- name: InsertEpisode :exec
INSERT INTO episodes ( id, legacy_id, legacy_program_id, age_rating, title, description, extra_description, images, production_date, season_id, duration, number)
VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
