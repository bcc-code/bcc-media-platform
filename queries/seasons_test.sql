-- name: AddSeason :one

INSERT INTO seasons (agerating_code, available_from, available_to, date_created, date_updated, publish_date,
                     season_number, show_id, status, user_created, user_updated, label, public_title,
                     episode_number_in_title, uuid, translations_required)
VALUES (@agerating_code,
        @available_from,
        @available_to,
        @date_created,
        @date_updated,
        @publish_date,
        @season_number,
        @show_id,
        @status,
        @user_created::uuid,
        @user_updated::uuid,
        @label,
        @public_title,
        @episode_number_in_title::bool,
        @uuid::uuid,
        @translations_required)
RETURNING *;
