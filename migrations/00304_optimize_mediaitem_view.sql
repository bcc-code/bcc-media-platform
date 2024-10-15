-- +goose Up
DROP VIEW IF EXISTS mediaitems_view_v2 CASCADE ;
create or replace view mediaitems_view_v2
            (id, assets, asset_id, original_title, original_description, title, description, images, parent_id,
             parent_episode_id, parent_starts_at, parent_ends_at, available_from, available_to, label, agerating_code,
             audience, content_type, production_date, published_at, translations_required, date_updated, duration,
             asset_date_updated, tag_ids)
as
SELECT mi.id,
       ma.assets,
       mi.asset_id,
       mi.title                                                                         AS original_title,
       mi.description                                                                   AS original_description,
       COALESCE(titles.title, '{}'::json)                                               AS title,
       COALESCE(descriptions.description, '{}'::json)                                   AS description,
       COALESCE(images.images, '{}'::json)                                              AS images,
       mi.parent_id,
       mi.parent_episode_id,
       mi.parent_starts_at,
       mi.parent_ends_at,
       COALESCE(mi.available_from, '1900-01-01 00:00:00'::timestamp without time zone)::timestamp without time zone  AS available_from,
       COALESCE(mi.available_to, '3000-01-01 00:00:00'::timestamp without time zone)::timestamp without time zone    AS available_to,
       mi.label,
       mi.agerating_code,
       mi.audience,
       mi.content_type,
       COALESCE(mi.production_date, '2000-01-01 00:00:00'::timestamp without time zone)::timestamp without time zone AS production_date,
       COALESCE(mi.published_at, '2000-01-01 00:00:00'::timestamp without time zone)::timestamp without time zone    AS published_at,
       mi.translations_required,
       COALESCE(mi.date_created, mi.date_updated)                                       AS date_updated,
       a.duration,
       a.date_updated                                                                   AS asset_date_updated,
       tags.tags::int[]                                                                        AS tag_ids
FROM mediaitems mi
         LEFT JOIN (SELECT ts.mediaitems_id,
                           json_object_agg(ts.languages_code, ts.title) AS title
                    FROM mediaitems_translations ts
                    GROUP BY ts.mediaitems_id) titles ON titles.mediaitems_id = mi.id
         LEFT JOIN (SELECT ts.mediaitems_id,
                           json_object_agg(ts.languages_code, ts.description) AS description
                    FROM mediaitems_translations ts
                    GROUP BY ts.mediaitems_id) descriptions ON descriptions.mediaitems_id = mi.id
         LEFT JOIN (SELECT simg.mediaitems_id,
                           json_agg(json_build_object('style', img.style, 'language', img.language, 'filename_disk',
                                                      df.filename_disk)) AS images
                    FROM mediaitems_styledimages simg
                             JOIN styledimages img ON img.id = simg.styledimages_id
                             JOIN directus_files df ON img.file = df.id
                    GROUP BY simg.mediaitems_id) images ON images.mediaitems_id = mi.id
         LEFT JOIN (SELECT ma_1.mediaitems_id,
                           json_object_agg(ma_1.language, ma_1.assets_id) AS assets
                    FROM mediaitems_assets ma_1
                    GROUP BY ma_1.mediaitems_id) ma ON ma.mediaitems_id = mi.id
         LEFT JOIN assets a ON a.id = mi.asset_id
         LEFT JOIN (SELECT t.mediaitems_id,
                           array_agg(t.tags_id) AS tags
                    FROM mediaitems_tags t
                    GROUP BY t.mediaitems_id) tags ON tags.mediaitems_id = mi.id;

grant select on mediaitems_view_v2 to api;

grant select on mediaitems_view_v2 to background_worker;

grant select on mediaitems_view_v2 to onsite_backup;

grant select on mediaitems_view_v2 to staging_sync;

-- +goose StatementBegin
create or replace function mediaitems_by_episodes_v2(episodeids integer[]) returns SETOF mediaitems_view_v2
    language plpgsql
as
$$
BEGIN
    RETURN QUERY (WITH mids AS (
        SELECT mediaitem_id FROM episodes WHERE episodes.id = ANY(episodeids)
    )
                  SELECT mi.id,
                         COALESCE(ma.assets, '{}'::json)                                                  AS assets,
                         mi.asset_id,
                         mi.title                                                                         AS original_title,
                         mi.description                                                                   AS original_description,
                         COALESCE(titles.title, '{}'::json)                                               AS title,
                         COALESCE(descriptions.description, '{}'::json)                                   AS description,
                         COALESCE(images.images, '{}'::json)                                              AS images,
                         mi.parent_id,
                         mi.parent_episode_id,
                         mi.parent_starts_at,
                         mi.parent_ends_at,
                         COALESCE(mi.available_from, '1900-01-01 00:00:00'::timestamp without time zone)  AS available_from,
                         COALESCE(mi.available_to, '3000-01-01 00:00:00'::timestamp without time zone)    AS available_to,
                         mi.label,
                         mi.agerating_code,
                         mi.audience,
                         mi.content_type,
                         COALESCE(mi.production_date, '2000-01-01 00:00:00'::timestamp without time zone) AS production_date,
                         COALESCE(mi.published_at, '2000-01-01 00:00:00'::timestamp without time zone)    AS published_at,
                         mi.translations_required,
                         COALESCE(mi.date_created, mi.date_updated)                                       AS date_updated,
                         a.duration,
                         a.date_updated                                                                   AS asset_date_updated,
                         tags.tags                                                                        AS tag_ids
                  FROM mediaitems mi
                           JOIN episodes e ON e.mediaitem_id = mi.id
                           LEFT JOIN (SELECT ts.mediaitems_id,
                                             json_object_agg(ts.languages_code, ts.title) AS title
                                      FROM mediaitems_translations ts
                                      WHERE mediaitems_id IN (SELECT * FROM mids)
                                      GROUP BY ts.mediaitems_id) titles ON titles.mediaitems_id = mi.id
                           LEFT JOIN (SELECT ts.mediaitems_id,
                                             json_object_agg(ts.languages_code, ts.description) AS description
                                      FROM mediaitems_translations ts
                                      WHERE mediaitems_id IN (SELECT * FROM mids)
                                      GROUP BY ts.mediaitems_id) descriptions ON descriptions.mediaitems_id = mi.id
                           LEFT JOIN (SELECT simg.mediaitems_id,
                                             json_agg(json_build_object('style', img.style, 'language', img.language, 'filename_disk',
                                                                        df.filename_disk)) AS images
                                      FROM mediaitems_styledimages simg
                                               JOIN styledimages img ON img.id = simg.styledimages_id
                                               JOIN directus_files df ON img.file = df.id
                                      WHERE mediaitems_id IN (SELECT * FROM mids)
                                      GROUP BY simg.mediaitems_id) images ON images.mediaitems_id = mi.id
                           LEFT JOIN (SELECT ma_1.mediaitems_id,
                                             json_object_agg(ma_1.language, ma_1.assets_id) AS assets
                                      FROM mediaitems_assets ma_1
                                      WHERE mediaitems_id IN (SELECT * FROM mids)
                                      GROUP BY ma_1.mediaitems_id) ma ON ma.mediaitems_id = mi.id
                           LEFT JOIN assets a ON a.id = mi.asset_id
                           LEFT JOIN (SELECT t.mediaitems_id,
                                             array_agg(t.tags_id) AS tags
                                      FROM mediaitems_tags t
                                      WHERE mediaitems_id IN (SELECT * FROM mids)
                                      GROUP BY t.mediaitems_id) tags ON tags.mediaitems_id = mi.id
                  WHERE e.id = ANY(episodeids));
    END;
$$;
-- +goose StatementEnd


grant execute on function mediaitems_by_episodes(integer[]) to api;


-- +goose Down

DROP FUNCTION IF EXISTS mediaitems_by_episodes_v2;
DROP VIEW IF EXISTS mediaitems_view_v2;
