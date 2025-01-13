-- name: AddShow :one

INSERT INTO public.shows (uuid, agerating_code, available_from, available_to, date_created, date_updated,
                          publish_date, status, type, user_created,
                          user_updated, default_episode_behaviour, publish_date_in_title, label, public_title,
                          translations_required)
VALUES (
		@uuid::uuid,
		@agerating_code::varchar,
        @available_from,
        @available_to,
        @date_created,
        @date_updated,
        @publish_date,
        @status,
        @type,
        @user_created::uuid,
        @user_updated::uuid,
        @default_episode_behaviour,
        @publish_date_in_title,
        @label,
        @public_title,
        @translations_required) RETURNING *;
