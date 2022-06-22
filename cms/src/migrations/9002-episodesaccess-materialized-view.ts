import { Knex } from 'knex';

const episode_access_view_sql = `
CREATE MATERIALIZED VIEW IF NOT EXISTS episodes_access AS (WITH
eu AS (SELECT episodes_id, array_agg(usergroups_code) as usergroups_codes FROM episodes_usergroups GROUP BY episodes_id),
ed AS (SELECT episodes_id, array_agg(usergroups_code) as usergroups_codes FROM episodes_usergroups_download GROUP BY episodes_id),
ee AS (SELECT episodes_id, array_agg(usergroups_code) as usergroups_codes FROM episodes_usergroups_earlyaccess GROUP BY episodes_id)
SELECT
e.id,
e.status = 'published' AND se.status = 'published' AND s.status = 'published' as published,
COALESCE(GREATEST(e.available_from, se.available_from, s.available_from), '1800-01-01') as available_from,
COALESCE(LEAST(e.available_to, se.available_to, s.available_to), '3000-01-01') as available_to,
COALESCE(eu.usergroups_codes, array[]::text[]) as usergroups,
COALESCE(ed.usergroups_codes, array[]::text[]) as usergroups_downloads,
COALESCE(ee.usergroups_codes, array[]::text[]) as usergroups_earlyaccess
FROM episodes e
LEFT JOIN seasons se ON e.season_id = se.id
LEFT JOIN shows s ON se.show_id = s.id
LEFT JOIN eu ON e.id = eu.episodes_id
LEFT JOIN ed ON e.id = ed.episodes_id
LEFT JOIN ee ON e.id = ee.episodes_id);
`;

const materialized_views_meta = `
CREATE TABLE IF NOT EXISTS public.materialized_views_meta (
	view_name text NOT NULL,
	last_refreshed timestamptz DEFAULT NOW(),
	CONSTRAINT materialized_views_meta_pk PRIMARY KEY (view_name)
);
`

// Usage: `SELECT * FROM update_episodes_access();`
const refresh_episode_access_function = `
CREATE OR REPLACE FUNCTION update_episodes_access() RETURNS boolean
AS $$
DECLARE
	last_refreshed timestamptz;
BEGIN
	SELECT date_refreshed INTO last_refreshed FROM materialized_views_meta WHERE view_name = 'episodes_access';

	IF (
 (SELECT MAX(date_updated) FROM shows) > last_refreshed  OR
 (SELECT MAX(date_updated) FROM seasons) > last_refreshed OR
 (SELECT MAX(date_updated) FROM episodes) > last_refreshed OR
 (SELECT MAX(date_updated) FROM episodes_usergroups) > last_refreshed OR
 (SELECT MAX(date_updated) FROM episodes_usergroups_download) >last_refreshed OR
 (SELECT MAX(date_updated) FROM episodes_usergroups_earlyaccess) > (last_refreshed)) THEN
		RAISE NOTICE 'Refreshing view';
		REFRESH MATERIALIZED VIEW CONCURRENTLY episodes_access;
		UPDATE materialized_views_meta SET date_refreshed = NOW() WHERE view_name = 'episodes_access';
		RETURN true;
    END IF;
	RETURN false;
END $$ LANGUAGE plpgsql;
`

module.exports = {
	async up(k : Knex) {
		await k.raw(episode_access_view_sql);
		await k.raw(`CREATE UNIQUE INDEX IF NOT EXISTS episodes_access_idx ON episodes_access(id);`);
		await k.raw(materialized_views_meta);
		await k.raw(refresh_episode_access_function);
	},

	async down(k : Knex) {
		await k.raw(`DROP MATERIALIZED VIEW IF EXISTS episodes_access`);
		await k.raw(`DROP TABLE IF EXISTS public.materialized_views_meta CASCADE`);
	}
}
