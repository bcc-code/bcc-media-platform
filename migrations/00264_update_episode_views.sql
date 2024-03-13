-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-03-12T10:56:26.346Z             ***/
/***********************************************************/

--- BEGIN ALTER VIEW "public"."episode_roles" ---

CREATE OR REPLACE VIEW "public"."episode_roles" AS  SELECT e.id,
    array_remove(array_agg(DISTINCT eu.usergroups_code), NULL::character varying) AS roles,
    array_remove(array_agg(DISTINCT eud.usergroups_code), NULL::character varying) AS roles_download,
    array_remove(array_agg(DISTINCT eue.usergroups_code), NULL::character varying) AS roles_earlyaccess
   FROM (((episodes e
     LEFT JOIN mediaitems_usergroups eu ON ((eu.mediaitems_id = e.mediaitem_id)))
     LEFT JOIN episodes_usergroups_download eud ON ((e.id = eud.episodes_id)))
     LEFT JOIN episodes_usergroups_earlyaccess eue ON ((e.id = eue.episodes_id)))
  GROUP BY e.id;

GRANT SELECT ON TABLE "public"."episode_roles" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON VIEW "public"."episode_roles"  IS NULL;

--- END ALTER VIEW "public"."episode_roles" ---

--- BEGIN ALTER VIEW "public"."episode_availability" ---

CREATE OR REPLACE VIEW "public"."episode_availability" AS  SELECT e.id,
    (((e.status)::text = 'published'::text) AND ((e.season_id IS NULL) OR (((se.status)::text = 'published'::text) AND ((s.status)::text = 'published'::text)))) AS published,
    COALESCE(GREATEST(mi.available_from, se.available_from, s.available_from), '1800-01-01 00:00:00'::timestamp without time zone) AS available_from,
    COALESCE(LEAST(mi.available_to, se.available_to, s.available_to), '3000-01-01 00:00:00'::timestamp without time zone) AS available_to,
    COALESCE(GREATEST(mi.published_at, se.publish_date, s.publish_date), '3000-01-01 00:00:00'::timestamp without time zone) AS published_on
   FROM (((episodes e
     JOIN mediaitems mi ON ((mi.id = e.mediaitem_id)))
     LEFT JOIN seasons se ON ((e.season_id = se.id)))
     LEFT JOIN shows s ON ((se.show_id = s.id)));

GRANT SELECT ON TABLE "public"."episode_availability" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON VIEW "public"."episode_availability"  IS NULL;

--- END ALTER VIEW "public"."episode_availability" ---

--- BEGIN ALTER VIEW "public"."season_roles" ---

CREATE OR REPLACE VIEW "public"."season_roles" AS  SELECT s.id,
    array_remove(array_agg(DISTINCT eu.usergroups_code), NULL::character varying) AS roles,
    array_remove(array_agg(DISTINCT eud.usergroups_code), NULL::character varying) AS roles_download,
    array_remove(array_agg(DISTINCT eue.usergroups_code), NULL::character varying) AS roles_earlyaccess
   FROM ((((seasons s
     LEFT JOIN episodes e ON ((e.season_id = s.id)))
     LEFT JOIN mediaitems_usergroups eu ON ((eu.mediaitems_id = e.mediaitem_id)))
     LEFT JOIN episodes_usergroups_download eud ON ((e.id = eud.episodes_id)))
     LEFT JOIN episodes_usergroups_earlyaccess eue ON ((e.id = eue.episodes_id)))
  WHERE (((e.status)::text = 'published'::text) OR ((e.status)::text = 'unlisted'::text))
  GROUP BY s.id;

GRANT SELECT ON TABLE "public"."season_roles" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON VIEW "public"."season_roles"  IS NULL;

--- END ALTER VIEW "public"."season_roles" ---

--- BEGIN ALTER VIEW "public"."show_roles" ---

CREATE OR REPLACE VIEW "public"."show_roles" AS  SELECT sh.id,
    array_remove(array_agg(DISTINCT eu.usergroups_code), NULL::character varying) AS roles,
    array_remove(array_agg(DISTINCT eud.usergroups_code), NULL::character varying) AS roles_download,
    array_remove(array_agg(DISTINCT eue.usergroups_code), NULL::character varying) AS roles_earlyaccess
   FROM (((((shows sh
     LEFT JOIN seasons s ON ((s.show_id = sh.id)))
     LEFT JOIN episodes e ON ((e.season_id = s.id)))
     LEFT JOIN mediaitems_usergroups eu ON ((eu.mediaitems_id = e.mediaitem_id)))
     LEFT JOIN episodes_usergroups_download eud ON ((e.id = eud.episodes_id)))
     LEFT JOIN episodes_usergroups_earlyaccess eue ON ((e.id = eue.episodes_id)))
  WHERE ((((e.status)::text = 'published'::text) OR ((e.status)::text = 'unlisted'::text)) AND (((s.status)::text = 'published'::text) OR ((s.status)::text = 'unlisted'::text)))
  GROUP BY sh.id;

GRANT SELECT ON TABLE "public"."show_roles" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON VIEW "public"."show_roles"  IS NULL;

--- END ALTER VIEW "public"."show_roles" ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-03-12T10:56:27.965Z             ***/
/***********************************************************/

--- BEGIN ALTER VIEW "public"."episode_availability" ---

CREATE OR REPLACE VIEW "public"."episode_availability" AS  SELECT e.id,
    (((e.status)::text = 'published'::text) AND ((e.season_id IS NULL) OR (((se.status)::text = 'published'::text) AND ((s.status)::text = 'published'::text)))) AS published,
    COALESCE(GREATEST(e.available_from, se.available_from, s.available_from), '1800-01-01 00:00:00'::timestamp without time zone) AS available_from,
    COALESCE(LEAST(e.available_to, se.available_to, s.available_to), '3000-01-01 00:00:00'::timestamp without time zone) AS available_to,
    COALESCE(GREATEST(e.publish_date, se.publish_date, s.publish_date), '3000-01-01 00:00:00'::timestamp without time zone) AS published_on
   FROM ((episodes e
     LEFT JOIN seasons se ON ((e.season_id = se.id)))
     LEFT JOIN shows s ON ((se.show_id = s.id)));

GRANT SELECT ON TABLE "public"."episode_availability" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON VIEW "public"."episode_availability"  IS NULL;

--- END ALTER VIEW "public"."episode_availability" ---

--- BEGIN ALTER VIEW "public"."episode_roles" ---

CREATE OR REPLACE VIEW "public"."episode_roles" AS  SELECT e.id,
    array_remove(array_agg(DISTINCT eu.usergroups_code), NULL::character varying) AS roles,
    array_remove(array_agg(DISTINCT eud.usergroups_code), NULL::character varying) AS roles_download,
    array_remove(array_agg(DISTINCT eue.usergroups_code), NULL::character varying) AS roles_earlyaccess
   FROM (((episodes e
     LEFT JOIN episodes_usergroups eu ON ((eu.episodes_id = e.id)))
     LEFT JOIN episodes_usergroups_download eud ON ((e.id = eud.episodes_id)))
     LEFT JOIN episodes_usergroups_earlyaccess eue ON ((e.id = eue.episodes_id)))
  GROUP BY e.id;

GRANT SELECT ON TABLE "public"."episode_roles" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON VIEW "public"."episode_roles"  IS NULL;

--- END ALTER VIEW "public"."episode_roles" ---

--- BEGIN ALTER VIEW "public"."season_roles" ---

CREATE OR REPLACE VIEW "public"."season_roles" AS  SELECT s.id,
    array_remove(array_agg(DISTINCT eu.usergroups_code), NULL::character varying) AS roles,
    array_remove(array_agg(DISTINCT eud.usergroups_code), NULL::character varying) AS roles_download,
    array_remove(array_agg(DISTINCT eue.usergroups_code), NULL::character varying) AS roles_earlyaccess
   FROM ((((seasons s
     LEFT JOIN episodes e ON ((e.season_id = s.id)))
     LEFT JOIN episodes_usergroups eu ON ((eu.episodes_id = e.id)))
     LEFT JOIN episodes_usergroups_download eud ON ((e.id = eud.episodes_id)))
     LEFT JOIN episodes_usergroups_earlyaccess eue ON ((e.id = eue.episodes_id)))
  WHERE (((e.status)::text = 'published'::text) OR ((e.status)::text = 'unlisted'::text))
  GROUP BY s.id;

GRANT SELECT ON TABLE "public"."season_roles" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."season_roles" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."season_roles" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."season_roles" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."season_roles" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."season_roles" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."season_roles" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON VIEW "public"."season_roles"  IS NULL;

--- END ALTER VIEW "public"."season_roles" ---

--- BEGIN ALTER VIEW "public"."show_roles" ---

CREATE OR REPLACE VIEW "public"."show_roles" AS  SELECT sh.id,
    array_remove(array_agg(DISTINCT eu.usergroups_code), NULL::character varying) AS roles,
    array_remove(array_agg(DISTINCT eud.usergroups_code), NULL::character varying) AS roles_download,
    array_remove(array_agg(DISTINCT eue.usergroups_code), NULL::character varying) AS roles_earlyaccess
   FROM (((((shows sh
     LEFT JOIN seasons s ON ((s.show_id = sh.id)))
     LEFT JOIN episodes e ON ((e.season_id = s.id)))
     LEFT JOIN episodes_usergroups eu ON ((eu.episodes_id = e.id)))
     LEFT JOIN episodes_usergroups_download eud ON ((e.id = eud.episodes_id)))
     LEFT JOIN episodes_usergroups_earlyaccess eue ON ((e.id = eue.episodes_id)))
  WHERE ((((e.status)::text = 'published'::text) OR ((e.status)::text = 'unlisted'::text)) AND (((s.status)::text = 'published'::text) OR ((s.status)::text = 'unlisted'::text)))
  GROUP BY sh.id;

GRANT SELECT ON TABLE "public"."show_roles" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."show_roles" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."show_roles" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."show_roles" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."show_roles" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."show_roles" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."show_roles" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON VIEW "public"."show_roles"  IS NULL;

--- END ALTER VIEW "public"."show_roles" ---

