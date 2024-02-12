-- name: InsertStream :exec
INSERT INTO streams (id, episode_id, url, audio_languages, subtitle_languages, type, video_language) VALUES (?,?,?,?,?,?,?);
