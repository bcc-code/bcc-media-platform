-- name: listCalendarEntries :many
WITH t AS (SELECT ts.calendarentries_id,
                  json_object_agg(ts.languages_code, ts.title)       AS title,
                  json_object_agg(ts.languages_code, ts.description) AS description
           FROM calendarentries_translations ts
           GROUP BY ts.calendarentries_id)
SELECT e.id,
       e.event_id,
       e.link_type,
       e.start,
       e.end,
       e.episode_id,
       e.season_id,
       e.show_id,
       t.title,
       t.description
FROM calendarentries e
         LEFT JOIN t ON e.id = t.calendarentries_id
WHERE e.status = 'published';

-- name: getCalendarEntries :many
WITH t AS (SELECT ts.calendarentries_id,
                  json_object_agg(ts.languages_code, ts.title)       AS title,
                  json_object_agg(ts.languages_code, ts.description) AS description
           FROM calendarentries_translations ts
           GROUP BY ts.calendarentries_id)
SELECT e.id,
       e.event_id,
       e.link_type,
       e.start,
       e.end,
       e.episode_id,
       e.season_id,
       e.show_id,
       t.title,
       t.description
FROM calendarentries e
         LEFT JOIN t ON e.id = t.calendarentries_id
WHERE e.status = 'published'
  AND e.id = ANY ($1::int[]);

-- name: getCalendarEntriesForEvents :many
WITH t AS (SELECT ts.calendarentries_id,
                  json_object_agg(ts.languages_code, ts.title)       AS title,
                  json_object_agg(ts.languages_code, ts.description) AS description
           FROM calendarentries_translations ts
           GROUP BY ts.calendarentries_id)
SELECT e.id,
       e.event_id,
       e.link_type,
       e.start,
       e.end,
       e.episode_id,
       e.season_id,
       e.show_id,
       t.title,
       t.description
FROM calendarentries e
         LEFT JOIN t ON e.id = t.calendarentries_id
WHERE e.status = 'published'
  AND e.event_id = ANY ($1::int[]);

-- name: getCalendarEntryIDsForPeriod :many
SELECT e.id
FROM calendarentries e
WHERE e.status = 'published'
  AND ((e.start >= $1::timestamptz AND e.start <= $2::timestamptz)
    OR (e.end >= $1::timestamptz AND e.end <= $2::timestamptz)
    OR (e.start <= $1::timestamptz AND e.end >= $2::timestamptz))
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
WHERE e.status = 'published';

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
