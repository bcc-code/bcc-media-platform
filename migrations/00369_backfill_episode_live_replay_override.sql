-- +goose Up

-- One-off backfill: from now on the jobs service (handleCalendarEntryEvent) keeps
-- these in sync when calendar entries are saved. Meeting episodes whose latest
-- published calendar entry is upcoming or ended less than 48h ago point to its
-- Live app replay from the entry end for 48h. The URL and window match the jobs
-- defaults.
WITH latest AS (SELECT DISTINCT ON (c.episode_id) c.episode_id, c.id, c."end"
                FROM calendarentries c
                WHERE c.episode_id IS NOT NULL
                  AND c.status = 'published'
                  AND c.link_type = 'episode'
                ORDER BY c.episode_id, c."end" DESC)
UPDATE episodes ep
SET override_url       = 'https://live.bcc-connect.org/replay/' || latest.id,
    override_url_from  = latest."end",
    override_url_until = latest."end" + interval '48 hours'
FROM latest
WHERE ep.id = latest.episode_id
  AND latest."end" + interval '48 hours' > now() AT TIME ZONE 'UTC';

-- +goose Down

UPDATE episodes
SET override_url       = NULL,
    override_url_from  = NULL,
    override_url_until = NULL
WHERE override_url LIKE 'https://live.bcc-connect.org/replay/%';
