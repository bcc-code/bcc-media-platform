-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-02-13T06:53:33.999Z             ***/
/***********************************************************/

--- BEGIN DROP VIEW "public"."filter_dataset" ---

DROP VIEW IF EXISTS "public"."filter_dataset";
--- END DROP VIEW "public"."filter_dataset" ---

--- BEGIN CREATE MATERIALIZED VIEW "public"."filter_dataset" ---

CREATE MATERIALIZED VIEW IF NOT EXISTS "public"."filter_dataset" AS  WITH e_tags AS (
         SELECT et.episodes_id AS id,
            array_agg(tags.code) AS tags
           FROM (episodes_tags et
             JOIN tags ON ((tags.id = et.tags_id)))
          GROUP BY et.episodes_id
        ), s_tags AS (
         SELECT st.seasons_id AS id,
            array_agg(tags.code) AS tags
           FROM (seasons_tags st
             JOIN tags ON ((tags.id = st.tags_id)))
          GROUP BY st.seasons_id
        ), sh_tags AS (
         SELECT sht.shows_id AS id,
            array_agg(tags.code) AS tags
           FROM (shows_tags sht
             JOIN tags ON ((tags.id = sht.tags_id)))
          GROUP BY sht.shows_id
        )
 SELECT 'episodes'::text AS collection,
    e.id,
    e.season_id,
    se.show_id,
    COALESCE(e.agerating_code, se.agerating_code) AS agerating_code,
    e.type,
    e.publish_date,
    av.published,
    av.available_from,
    av.available_to,
    COALESCE(roles.roles, '{}'::character varying[]) AS roles,
    ARRAY( SELECT DISTINCT unnest(array_cat(e_tags.tags, array_cat(s_tags.tags, sh_tags.tags))) AS unnest) AS tags
   FROM ((((((episodes e
     LEFT JOIN episode_roles roles ON ((roles.id = e.id)))
     LEFT JOIN episode_availability av ON ((av.id = e.id)))
     LEFT JOIN e_tags ON ((e_tags.id = e.id)))
     LEFT JOIN seasons se ON ((se.id = e.season_id)))
     LEFT JOIN s_tags ON ((s_tags.id = e.season_id)))
     LEFT JOIN sh_tags ON ((sh_tags.id = se.show_id)))
UNION
 SELECT 'seasons'::text AS collection,
    se.id,
    NULL::integer AS season_id,
    se.show_id,
    NULL::character varying AS agerating_code,
    se.agerating_code AS type,
    se.publish_date,
    av.published,
    av.available_from,
    av.available_to,
    COALESCE(roles.roles, '{}'::character varying[]) AS roles,
    ARRAY( SELECT DISTINCT unnest(array_cat(s_tags.tags, sh_tags.tags)) AS unnest) AS tags
   FROM ((((seasons se
     LEFT JOIN season_roles roles ON ((roles.id = se.id)))
     LEFT JOIN season_availability av ON ((av.id = se.id)))
     LEFT JOIN s_tags ON ((s_tags.id = se.id)))
     LEFT JOIN sh_tags ON ((sh_tags.id = se.show_id)))
UNION
 SELECT 'shows'::text AS collection,
    sh.id,
    NULL::integer AS season_id,
    NULL::integer AS show_id,
    sh.agerating_code,
    sh.type,
    sh.publish_date,
    av.published,
    av.available_from,
    av.available_to,
    COALESCE(shr.roles, '{}'::character varying[]) AS roles,
    COALESCE(sh_tags.tags, '{}'::character varying[]) AS tags
   FROM (((shows sh
     LEFT JOIN show_roles shr ON ((shr.id = sh.id)))
     LEFT JOIN show_availability av ON ((av.id = sh.id)))
     LEFT JOIN sh_tags ON ((sh_tags.id = sh.id)));

GRANT SELECT ON TABLE "public"."filter_dataset" TO api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."filter_dataset" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."filter_dataset" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."filter_dataset" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."filter_dataset" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."filter_dataset" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."filter_dataset" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON MATERIALIZED VIEW "public"."filter_dataset"  IS NULL;

--- END CREATE MATERIALIZED VIEW "public"."filter_dataset" ---

-- +goose StatementBegin
CREATE OR REPLACE FUNCTION public.update_view(view character varying)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $$
BEGIN
    CASE
        WHEN view = 'filter_dataset' THEN
            REFRESH MATERIALIZED VIEW filter_dataset;
        ELSE
            RAISE EXCEPTION 'Invalid view';
    END CASE;
    INSERT INTO materialized_views_meta (last_refreshed, view_name)
    VALUES (NOW(), view)
    ON CONFLICT(view_name) DO UPDATE set last_refreshed = now();
    RETURN true;
END
$$
;
-- +goose StatementEnd
GRANT EXECUTE ON FUNCTION "public"."update_view"(character varying) TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT EXECUTE ON FUNCTION "public"."update_view"(character varying) TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON FUNCTION "public"."update_view"(character varying)  IS NULL;

--- BEGIN DROP FUNCTION "public"."update_access"(character varying) ---

DROP FUNCTION IF EXISTS "public"."update_access"(character varying);

--- END DROP FUNCTION "public"."update_access"(character varying) ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-02-13T06:53:35.645Z             ***/
/***********************************************************/



--- BEGIN DROP MATERIALIZED VIEW "public"."filter_dataset" ---

DROP MATERIALIZED VIEW IF EXISTS "public"."filter_dataset";
--- END DROP MATERIALIZED VIEW "public"."filter_dataset" ---

--- BEGIN CREATE VIEW "public"."filter_dataset" ---

CREATE OR REPLACE VIEW "public"."filter_dataset" AS  WITH e_tags AS (
         SELECT et.episodes_id AS id,
            array_agg(tags.code) AS tags
           FROM (episodes_tags et
             JOIN tags ON ((tags.id = et.tags_id)))
          GROUP BY et.episodes_id
        ), s_tags AS (
         SELECT st.seasons_id AS id,
            array_agg(tags.code) AS tags
           FROM (seasons_tags st
             JOIN tags ON ((tags.id = st.tags_id)))
          GROUP BY st.seasons_id
        ), sh_tags AS (
         SELECT sht.shows_id AS id,
            array_agg(tags.code) AS tags
           FROM (shows_tags sht
             JOIN tags ON ((tags.id = sht.tags_id)))
          GROUP BY sht.shows_id
        )
 SELECT 'episodes'::text AS collection,
    e.id,
    e.season_id,
    se.show_id,
    e.episode_number AS number,
    COALESCE(e.agerating_code, se.agerating_code) AS agerating_code,
    e.type,
    e.publish_date,
    av.published,
    av.available_from,
    av.available_to,
    COALESCE(roles.roles, '{}'::character varying[]) AS roles,
    ARRAY( SELECT DISTINCT unnest(array_cat(e_tags.tags, array_cat(s_tags.tags, sh_tags.tags))) AS unnest) AS tags
   FROM ((((((episodes e
     LEFT JOIN episode_roles roles ON ((roles.id = e.id)))
     LEFT JOIN episode_availability av ON ((av.id = e.id)))
     LEFT JOIN e_tags ON ((e_tags.id = e.id)))
     LEFT JOIN seasons se ON ((se.id = e.season_id)))
     LEFT JOIN s_tags ON ((s_tags.id = e.season_id)))
     LEFT JOIN sh_tags ON ((sh_tags.id = se.show_id)))
UNION
 SELECT 'seasons'::text AS collection,
    se.id,
    NULL::integer AS season_id,
    se.show_id,
    se.season_number AS number,
    se.agerating_code,
    NULL::character varying AS type,
    se.publish_date,
    av.published,
    av.available_from,
    av.available_to,
    COALESCE(roles.roles, '{}'::character varying[]) AS roles,
    ARRAY( SELECT DISTINCT unnest(array_cat(s_tags.tags, sh_tags.tags)) AS unnest) AS tags
   FROM ((((seasons se
     LEFT JOIN season_roles roles ON ((roles.id = se.id)))
     LEFT JOIN season_availability av ON ((av.id = se.id)))
     LEFT JOIN s_tags ON ((s_tags.id = se.id)))
     LEFT JOIN sh_tags ON ((sh_tags.id = se.show_id)))
UNION
 SELECT 'shows'::text AS collection,
    sh.id,
    NULL::integer AS season_id,
    NULL::integer AS show_id,
    NULL::integer AS number,
    sh.agerating_code,
    sh.type,
    sh.publish_date,
    av.published,
    av.available_from,
    av.available_to,
    COALESCE(shr.roles, '{}'::character varying[]) AS roles,
    COALESCE(sh_tags.tags, '{}'::character varying[]) AS tags
   FROM (((shows sh
     LEFT JOIN show_roles shr ON ((shr.id = sh.id)))
     LEFT JOIN show_availability av ON ((av.id = sh.id)))
     LEFT JOIN sh_tags ON ((sh_tags.id = sh.id)));
GRANT SELECT ON TABLE "public"."filter_dataset" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON VIEW "public"."filter_dataset"  IS NULL;

--- END CREATE VIEW "public"."filter_dataset" ---

-- +goose StatementBegin
CREATE OR REPLACE FUNCTION public.update_access(view character varying)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $$
DECLARE
    lr timestamptz;
BEGIN
    SELECT last_refreshed INTO lr FROM materialized_views_meta WHERE view_name = view;
    IF (
            lr IS NULL OR
            (SELECT MAX(date_updated) FROM shows) > lr OR
            (SELECT MAX(date_updated) FROM seasons) > lr OR
            (SELECT MAX(date_updated) FROM episodes) > lr OR
            (SELECT MAX(date_updated) FROM episodes_usergroups) > lr OR
            (SELECT MAX(date_updated) FROM episodes_usergroups_download) > lr OR
            (SELECT MAX(date_updated) FROM episodes_usergroups_earlyaccess) > (lr)) THEN
        RAISE NOTICE 'Refreshing view';
        CASE
            WHEN view = 'episodes_access' THEN
                REFRESH MATERIALIZED VIEW CONCURRENTLY episodes_access;
            WHEN view = 'seasons_access' THEN
                REFRESH MATERIALIZED VIEW CONCURRENTLY seasons_access;
            WHEN view = 'shows_access' THEN
                REFRESH MATERIALIZED VIEW CONCURRENTLY shows_access;
            ELSE
                RAISE EXCEPTION 'Invalid view';
        END CASE;
        INSERT INTO materialized_views_meta (last_refreshed, view_name)
        VALUES (NOW(), view)
        ON CONFLICT(view_name) DO UPDATE set last_refreshed = now();
        RETURN true;
    END IF;
    RETURN false;
END
$$
;
-- +goose StatementEnd
GRANT EXECUTE ON FUNCTION "public"."update_access"(character varying) TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT EXECUTE ON FUNCTION "public"."update_access"(character varying) TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON FUNCTION "public"."update_access"(character varying)  IS NULL;

--- BEGIN DROP FUNCTION "public"."update_view"(character varying) ---

DROP FUNCTION IF EXISTS "public"."update_view"(character varying);

--- END DROP FUNCTION "public"."update_view"(character varying) ---
