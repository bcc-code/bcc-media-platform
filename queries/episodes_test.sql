-- name: AddEpisode :one

INSERT INTO episodes (asset_id, episode_number,
                      publish_date, season_id, user_created, user_updated, publish_date_in_title, label,
                      production_date, public_title, prevent_public_indexing, uuid, content_type, audience,
                      status,  available_from, available_to, mediaitem_id)
VALUES (@asset_id,
        @episode_number,
        @publish_date::timestamp,
        @season_id,
        @user_created::uuid,
        @user_updated::uuid,
        @publish_date_in_title,
        @label,
        @production_date,
        @public_title,
        @prevent_public_indexing::bool,
        @uuid::uuid,
        @content_type,
        @audience,
        @status,
    @available_from::timestamp,
    @available_to::timestamp,
    @mediaitem_id::uuid
       )
RETURNING *;


-- name: AddMediaItem :one

INSERT INTO mediaitems (id, user_created, date_created, user_updated, date_updated, label, title, description, asset_id,
                        parent_episode_id, parent_starts_at, parent_ends_at, published_at, production_date, parent_id,
                        content_type, audience, agerating_code, available_from, available_to, primary_episode_id, type)
VALUES (@id,
        @user_created::uuid,
        @date_created,
        @user_updated::uuid,
        @date_updated,
        @label,
        @title,
        @description,
        @asset_id,
        @parent_episode_id,
        @parent_starts_at,
        @parent_ends_at,
        @published_at,
        @production_date,
        @parent_id,
        @content_type,
        @audience,
        @agerating_code,
        @available_from,
        @available_to, @primary_episode_id, @type) RETURNING id;
