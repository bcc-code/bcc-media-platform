-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-11-20T09:31:33.032Z             ***/
/***********************************************************/

--- BEGIN CREATE VIEW "public"."mediaitems_view" ---

CREATE OR REPLACE VIEW "public"."mediaitems_view" AS
SELECT mi.id,
       mi.title                                       AS original_title,
       mi.description                                 AS original_description,
       COALESCE(titles.title, '{}'::json)             AS title,
       COALESCE(descriptions.description, '{}'::json) AS description,
       COALESCE(images.images, '{}'::json)            AS images
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
               GROUP BY simg.mediaitems_id) images ON ((images.mediaitems_id = mi.id)))
         LEFT JOIN (SELECT t.mediaitems_id,
                           json_agg(tg.code)
                    FROM mediaitems_tags t
                             JOIN tags tg ON tg.id = t.id
                    GROUP BY t.mediaitems_id) tags ON ((tags.mediaitems_id = mi.id));

GRANT SELECT ON TABLE "public"."mediaitems_view" TO api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."mediaitems_view" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."mediaitems_view" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."mediaitems_view" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."mediaitems_view" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."mediaitems_view" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."mediaitems_view" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON VIEW "public"."mediaitems_view" IS NULL;

--- END CREATE VIEW "public"."mediaitems_view" ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-11-20T09:31:34.530Z             ***/
/***********************************************************/

--- BEGIN DROP VIEW "public"."mediaitems_view" ---

DROP VIEW IF EXISTS "public"."mediaitems_view";
--- END DROP VIEW "public"."mediaitems_view" ---
