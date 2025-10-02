-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Claude AI (claude.ai/code)         ***/
/***    CREATED ON: 2025-10-02                          ***/
/***********************************************************/

--- BEGIN UPDATE MATERIALIZED VIEW "public"."episode_availability" ---

-- Drop and recreate the materialized view to include unlisted episodes in the published column
DROP MATERIALIZED VIEW IF EXISTS public.episode_availability;

CREATE MATERIALIZED VIEW public.episode_availability AS
SELECT e.id,
       (e.status::text = 'published'::text OR e.status::text = 'unlisted'::text) AND
       (e.season_id IS NULL OR se.status::text = 'published'::text AND s.status::text = 'published'::text) AS published,
       COALESCE(GREATEST(mi.available_from, se.available_from, s.available_from),
                '1800-01-01 00:00:00'::timestamp without time zone)                                        AS available_from,
       COALESCE(LEAST(mi.available_to, se.available_to, s.available_to),
                '3000-01-01 00:00:00'::timestamp without time zone)                                        AS available_to,
       COALESCE(GREATEST(mi.published_at, se.publish_date, s.publish_date),
                '3000-01-01 00:00:00'::timestamp without time zone)                                        AS published_on,
       COALESCE(array_remove(array_agg(DISTINCT aal.languages_code), NULL::character varying),
                '{}'::character varying[])                                                                 AS audio,
       COALESCE(array_remove(array_agg(DISTINCT asl.languages_code), NULL::character varying),
                '{}'::character varying[])                                                                 AS subtitle,
       e.season_id
FROM episodes e
         JOIN mediaitems mi ON mi.id = e.mediaitem_id
         LEFT JOIN seasons se ON e.season_id = se.id
         LEFT JOIN shows s ON se.show_id = s.id
         LEFT JOIN assetstreams astr ON mi.asset_id = astr.asset_id
         LEFT JOIN assetstreams_audio_languages aal ON astr.id = aal.assetstreams_id
         LEFT JOIN assetstreams_subtitle_languages asl ON astr.id = asl.assetstreams_id
GROUP BY e.id, mi.id, se.id, s.id;

-- Recreate the unique index
CREATE UNIQUE INDEX IF NOT EXISTS episode_availability_id_idx ON public.episode_availability (id);

-- Grant permissions
GRANT SELECT ON TABLE public.episode_availability TO api;
GRANT SELECT ON TABLE public.episode_availability TO background_worker;

--- END UPDATE MATERIALIZED VIEW "public"."episode_availability" ---

-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Claude AI (claude.ai/code)         ***/
/***    CREATED ON: 2025-10-02                          ***/
/***********************************************************/

--- BEGIN REVERT MATERIALIZED VIEW "public"."episode_availability" ---

-- Drop and recreate the original materialized view (without unlisted episodes)
DROP MATERIALIZED VIEW IF EXISTS public.episode_availability;

CREATE MATERIALIZED VIEW public.episode_availability AS
SELECT e.id,
       e.status::text = 'published'::text AND
       (e.season_id IS NULL OR se.status::text = 'published'::text AND s.status::text = 'published'::text) AS published,
       COALESCE(GREATEST(mi.available_from, se.available_from, s.available_from),
                '1800-01-01 00:00:00'::timestamp without time zone)                                        AS available_from,
       COALESCE(LEAST(mi.available_to, se.available_to, s.available_to),
                '3000-01-01 00:00:00'::timestamp without time zone)                                        AS available_to,
       COALESCE(GREATEST(mi.published_at, se.publish_date, s.publish_date),
                '3000-01-01 00:00:00'::timestamp without time zone)                                        AS published_on,
       COALESCE(array_remove(array_agg(DISTINCT aal.languages_code), NULL::character varying),
                '{}'::character varying[])                                                                 AS audio,
       COALESCE(array_remove(array_agg(DISTINCT asl.languages_code), NULL::character varying),
                '{}'::character varying[])                                                                 AS subtitle,
       e.season_id
FROM episodes e
         JOIN mediaitems mi ON mi.id = e.mediaitem_id
         LEFT JOIN seasons se ON e.season_id = se.id
         LEFT JOIN shows s ON se.show_id = s.id
         LEFT JOIN assetstreams astr ON mi.asset_id = astr.asset_id
         LEFT JOIN assetstreams_audio_languages aal ON astr.id = aal.assetstreams_id
         LEFT JOIN assetstreams_subtitle_languages asl ON astr.id = asl.assetstreams_id
GROUP BY e.id, mi.id, se.id, s.id;

-- Recreate the unique index
CREATE UNIQUE INDEX IF NOT EXISTS episode_availability_id_idx ON public.episode_availability (id);

-- Grant permissions
GRANT SELECT ON TABLE public.episode_availability TO api;
GRANT SELECT ON TABLE public.episode_availability TO background_worker;

--- END REVERT MATERIALIZED VIEW "public"."episode_availability" ---