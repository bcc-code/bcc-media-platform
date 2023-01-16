-- +goose Up
/**********************************************************/
/*** SCRIPT AUTHOR: Matjaz Debelak (matjaz@debelak.org) ***/
/***    CREATED ON: 2023-01-16T10:14:59.259Z            ***/
/**********************************************************/

--- BEGIN ALTER VIEW "public"."episode_availability" ---

--DROP VIEW IF EXISTS "public"."episode_availability";
CREATE OR REPLACE VIEW "public"."episode_availability" AS  SELECT e.id,
    (((e.status)::text = 'published'::text) AND ((e.season_id IS NULL) OR (((se.status)::text = 'published'::text) AND ((s.status)::text = 'published'::text)))) AS published,
    COALESCE(GREATEST(e.available_from, se.available_from, s.available_from), '1800-01-01 00:00:00'::timestamp without time zone) AS available_from,
    COALESCE(LEAST(e.available_to, se.available_to, s.available_to), '3000-01-01 00:00:00'::timestamp without time zone) AS available_to,
    COALESCE(GREATEST(e.publish_date, se.publish_date, s.publish_date), '3000-01-01 00:00:00'::timestamp without time zone) AS published_on
   FROM ((episodes e
     LEFT JOIN seasons se ON ((e.season_id = se.id)))
     LEFT JOIN shows s ON ((se.show_id = s.id)));

COMMENT ON VIEW "public"."episode_availability"  IS NULL;

--- END ALTER VIEW "public"."episode_availability" ---
-- +goose Down
/**********************************************************/
/*** SCRIPT AUTHOR: Matjaz Debelak (matjaz@debelak.org) ***/
/***    CREATED ON: 2023-01-16T10:15:00.874Z            ***/
/**********************************************************/

--- BEGIN ALTER VIEW "public"."episode_availability" ---

--DROP VIEW IF EXISTS "public"."episode_availability";
CREATE OR REPLACE VIEW "public"."episode_availability" AS  SELECT e.id,
    (((e.status)::text = 'published'::text) AND ((e.season_id IS NULL) OR (((se.status)::text = 'published'::text) AND ((s.status)::text = 'published'::text)))) AS published,
    COALESCE(GREATEST(e.available_from, se.available_from, s.available_from), '1800-01-01 00:00:00'::timestamp without time zone) AS available_from,
    COALESCE(LEAST(e.available_to, se.available_to, s.available_to), '3000-01-01 00:00:00'::timestamp without time zone) AS available_to
   FROM ((episodes e
     LEFT JOIN seasons se ON ((e.season_id = se.id)))
     LEFT JOIN shows s ON ((se.show_id = s.id)));

COMMENT ON VIEW "public"."episode_availability"  IS NULL;

--- END ALTER VIEW "public"."episode_availability" ---
