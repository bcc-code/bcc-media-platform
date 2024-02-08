-- +goose Up

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
                    GROUP BY simg.mediaitems_id) images ON images.mediaitems_id = mi.id;


-- +goose Down

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
                    GROUP BY simg.mediaitems_id) images ON images.mediaitems_id = mi.id;

