-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-03-12T10:39:46.948Z             ***/
/***********************************************************/

--- BEGIN ALTER VIEW "public"."mediaitems_view" ---

DROP VIEW IF EXISTS "public"."mediaitems_view";
CREATE OR REPLACE VIEW "public"."mediaitems_view" AS
SELECT mi.id,
       ma.assets,
       mi.asset_id,
       mi.title                                                                            AS original_title,
       mi.description                                                                      AS original_description,
       COALESCE(titles.title, '{}'::json)                                                  AS title,
       COALESCE(descriptions.description, '{}'::json)                                      AS description,
       COALESCE(images.images, '{}'::json)                                                 AS images,
       mi.parent_id,
       mi.parent_episode_id,
       mi.parent_starts_at,
       mi.parent_ends_at,
       COALESCE(mi.available_from, '1900-01-01'::timestamp)::timestamp                     AS available_from,
       COALESCE(mi.available_to, '3000-01-01'::timestamp)::timestamp                       AS available_to,
       mi.label,
       mi.agerating_code,
       mi.audience,
       mi.content_type,
       COALESCE(mi.production_date, '2000-01-01'::timestamp)::timestamp                    AS production_date,
       COALESCE(mi.published_at, '2000-01-01'::timestamp)::timestamp                       AS published_at,
       mi.translations_required,
       COALESCE(mi.date_created, mi.date_updated)                                          AS date_updated,
       a.duration,
       a.date_updated                                                                      AS asset_date_updated,
       tags.tags::int[]                                                                    AS tag_ids,
       (SELECT array_agg(md.id ORDER BY md.seconds) AS array_agg
        FROM timedmetadata md
        WHERE ((mi.timedmetadata_from_asset AND (md.asset_id = mi.asset_id)) OR
               ((NOT mi.timedmetadata_from_asset) AND (md.mediaitem_id = mi.id))))::uuid[] AS timedmetadata_ids
FROM ((((((mediaitems mi
    LEFT JOIN (SELECT ts.mediaitems_id,
                      json_object_agg(ts.languages_code, ts.title) AS title
               FROM mediaitems_translations ts
               GROUP BY ts.mediaitems_id) titles ON ((titles.mediaitems_id = mi.id)))
    LEFT JOIN (SELECT ts.mediaitems_id,
                      json_object_agg(ts.languages_code, ts.description) AS description
               FROM mediaitems_translations ts
               GROUP BY ts.mediaitems_id) descriptions ON ((descriptions.mediaitems_id = mi.id)))
    LEFT JOIN (SELECT simg.mediaitems_id,
                      json_agg(json_build_object('style', img.style, 'language', img.language, 'filename_disk',
                                                 df.filename_disk)) AS images
               FROM ((mediaitems_styledimages simg
                   JOIN styledimages img ON ((img.id = simg.styledimages_id)))
                   JOIN directus_files df ON ((img.file = df.id)))
               GROUP BY simg.mediaitems_id) images ON ((images.mediaitems_id = mi.id)))
    LEFT JOIN (SELECT ma_1.mediaitems_id,
                      json_object_agg(ma_1.language, ma_1.assets_id) AS assets
               FROM mediaitems_assets ma_1
               GROUP BY ma_1.mediaitems_id) ma ON ((ma.mediaitems_id = mi.id)))
    LEFT JOIN assets a ON ((a.id = mi.asset_id)))
    LEFT JOIN (SELECT t.mediaitems_id,
                      array_agg(t.tags_id) AS tags
               FROM mediaitems_tags t
               GROUP BY t.mediaitems_id) tags ON ((tags.mediaitems_id = mi.id)));

GRANT SELECT ON TABLE "public"."mediaitems_view" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON VIEW "public"."mediaitems_view" IS NULL;

--- END ALTER VIEW "public"."mediaitems_view" ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-03-12T10:39:48.547Z             ***/
/***********************************************************/

--- BEGIN ALTER VIEW "public"."mediaitems_view" ---

DROP VIEW IF EXISTS "public"."mediaitems_view";
CREATE OR REPLACE VIEW "public"."mediaitems_view" AS
SELECT mi.id,
       mi.asset_id,
       mi.title                                       AS original_title,
       mi.description                                 AS original_description,
       COALESCE(titles.title, '{}'::json)             AS title,
       COALESCE(descriptions.description, '{}'::json) AS description,
       COALESCE(images.images, '{}'::json)            AS images,
       mi.parent_episode_id,
       mi.parent_starts_at,
       mi.parent_ends_at,
       mi.label,
       COALESCE(mi.date_created, mi.date_updated)     AS date_updated
FROM (((mediaitems mi
    LEFT JOIN (SELECT ts.mediaitems_id,
                      json_object_agg(ts.languages_code, ts.title) AS title
               FROM mediaitems_translations ts
               GROUP BY ts.mediaitems_id) titles ON ((titles.mediaitems_id = mi.id)))
    LEFT JOIN (SELECT ts.mediaitems_id,
                      json_object_agg(ts.languages_code, ts.description) AS description
               FROM mediaitems_translations ts
               GROUP BY ts.mediaitems_id) descriptions ON ((descriptions.mediaitems_id = mi.id)))
    LEFT JOIN (SELECT simg.mediaitems_id,
                      json_agg(json_build_object('style', img.style, 'language', img.language, 'filename_disk',
                                                 df.filename_disk)) AS images
               FROM ((mediaitems_styledimages simg
                   JOIN styledimages img ON ((img.id = simg.styledimages_id)))
                   JOIN directus_files df ON ((img.file = df.id)))
               GROUP BY simg.mediaitems_id) images ON ((images.mediaitems_id = mi.id)));

GRANT SELECT ON TABLE "public"."mediaitems_view" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON VIEW "public"."mediaitems_view" IS NULL;

--- END ALTER VIEW "public"."mediaitems_view" ---
