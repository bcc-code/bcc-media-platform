-- name: getCalendarEntries :many
SELECT e.id,
       e.event_id,
       e.link_type,
       e.start,
       e.end,
       COALESCE(e.is_replay, false) = true AS is_replay,
       ea.id                               AS episode_id,
       se.id                               AS season_id,
       sh.id                               AS show_id,
       ts.title,
       ts.description
FROM calendarentries e
         LEFT JOIN LATERAL (SELECT json_object_agg(ts.languages_code, ts.title)       AS title,
                                   json_object_agg(ts.languages_code, ts.description) AS description
                            FROM calendarentries_translations ts
                            WHERE ts.calendarentries_id = e.id) ts ON true
         LEFT JOIN episode_roles er ON er.id = e.episode_id AND er.roles && $2::varchar[]
         LEFT JOIN episode_availability ea ON ea.id = er.id AND ea.published
         LEFT JOIN seasons se ON se.id = e.season_id AND se.status = 'published'
         LEFT JOIN shows sh ON sh.id = e.show_id AND sh.status = 'published'
WHERE e.status = 'published'
  AND e.id = ANY ($1::int[]);

-- name: getCalendarEntryIDsForEvents :many
SELECT e.id, e.event_id as parent_id
FROM calendarentries e
WHERE e.status = 'published'
  AND e.event_id = ANY (@ids::int[])
ORDER BY e.start;

-- name: getCalendarEntryIDsForPeriod :many
SELECT e.id
FROM calendarentries e
WHERE e.status = 'published'
  AND (e.start >= $1::timestamptz AND e.start <= $2::timestamptz)
ORDER BY e.start;

-- name: listEvents :many
WITH t AS (SELECT ts.events_id,
                  json_object_agg(ts.languages_code, ts.title) AS title
           FROM events_translations ts
           GROUP BY ts.events_id)
SELECT e.id,
       e.start,
       e.end,
       t.title
FROM events e
         LEFT JOIN t ON e.id = t.events_id
WHERE e.status = 'published'
  AND e.end >= now() - '1 year'::interval
ORDER BY e.start;

-- name: getEvents :many
WITH t AS (SELECT ts.events_id,
                  json_object_agg(ts.languages_code, ts.title) AS title
           FROM events_translations ts
           GROUP BY ts.events_id)
SELECT e.id,
       e.start,
       e.end,
       t.title
FROM events e
         LEFT JOIN t ON e.id = t.events_id
WHERE e.status = 'published'
  AND e.id = ANY ($1::int[]);

-- name: getEventIDsForPeriod :many
SELECT e.id
FROM events e
WHERE e.status = 'published'
  AND ((e.start >= $1::timestamptz AND e.start <= $2::timestamptz) OR
       (e.end >= $1::timestamptz AND e.end <= $2::timestamptz))
ORDER BY e.start;

-- name: getCalendarEntriesByID :many
SELECT e.id,
       e.event_id,
       e.link_type,
       e.start,
       e.end,
       COALESCE(e.is_replay, false) = true AS is_replay,
       ea.id                               AS episode_id,
       se.id                               AS season_id,
       sh.id                               AS show_id,
       ts.title,
       ts.description
FROM calendarentries e
         LEFT JOIN LATERAL (SELECT json_object_agg(ts.languages_code, ts.title)       AS title,
                                   json_object_agg(ts.languages_code, ts.description) AS description
                            FROM calendarentries_translations ts
                            WHERE ts.calendarentries_id = e.id) ts ON true
         LEFT JOIN episode_roles er ON er.id = e.episode_id
         LEFT JOIN episode_availability ea ON ea.id = er.id
         LEFT JOIN seasons se ON se.id = e.season_id
         LEFT JOIN shows sh ON sh.id = e.show_id
WHERE e.id = ANY ($1::int[]);
