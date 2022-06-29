import { Knex } from 'knex';

// Usage: `SELECT * FROM update_episodes_access();`
const refresh_episode_access_function = `
CREATE OR REPLACE FUNCTION public.update_episodes_access() RETURNS boolean
SECURITY DEFINER -- This function runs as the user defining it. This is needed because a non-owner can't refresh a view
    LANGUAGE plpgsql
    AS $$
DECLARE
	lr timestamptz;
BEGIN
	SELECT last_refreshed INTO lr FROM materialized_views_meta WHERE view_name = 'episodes_access';

	IF (
 (SELECT MAX(date_updated) FROM shows) > lr  OR
 (SELECT MAX(date_updated) FROM seasons) > lr OR
 (SELECT MAX(date_updated) FROM episodes) > lr OR
 (SELECT MAX(date_updated) FROM episodes_usergroups) > lr OR
 (SELECT MAX(date_updated) FROM episodes_usergroups_download) >lr OR
 (SELECT MAX(date_updated) FROM episodes_usergroups_earlyaccess) > (lr)) THEN
		RAISE NOTICE 'Refreshing view';
		REFRESH MATERIALIZED VIEW CONCURRENTLY episodes_access;
		UPDATE materialized_views_meta SET last_refreshed = NOW() WHERE view_name = 'episodes_access';
		RETURN true;
    END IF;
	RETURN false;
END $$;
`

module.exports = {
	async up(k : Knex) {
		await k.raw(refresh_episode_access_function);
	},

	async down(_ : Knex) {
		return
	}
}
