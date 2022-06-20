CREATE MATERIALIZED VIEW episodes_access AS (WITH
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

CREATE UNIQUE INDEX episodes_access_idx ON episodes_access(id);
