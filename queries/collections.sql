-- name: getCollections :many
WITH ts AS (SELECT collections_id,
                   json_object_agg(languages_code, title) AS title,
                   json_object_agg(languages_code, slug)  AS slugs
            FROM collections_translations
            GROUP BY collections_id)
SELECT c.id,
       c.advanced_type,
       c.date_created,
       c.date_updated,
       c.filter_type,
       c.query_filter,
       c.number_in_titles,
       ts.title,
       ts.slugs
FROM collections c
         LEFT JOIN ts ON ts.collections_id = c.id
WHERE c.id = ANY ($1::int[]);

-- name: getCollectionEntriesForCollections :many
SELECT ci.id, ci.collections_id, ci.item, ci.collection, ci.sort
FROM collections_entries ci
WHERE ci.collections_id = ANY ($1::int[]);

-- name: getCollectionEntriesForCollectionsWithRoles :many
SELECT ce.id, ce.collections_id, ce.item, ce.collection, ce.sort
FROM collections_entries ce
         JOIN episode_roles er        ON er.id::varchar = ce.item
         JOIN episode_availability ea ON ea.id::varchar = ce.item
WHERE ce.collections_id = ANY (@ids::int[])
  AND ce.collection = 'episodes'
  AND ea.published
  AND ea.available_to   > now()
  AND ea.available_from < now()
  AND er.roles && @roles::varchar[]
UNION ALL
SELECT ce.id, ce.collections_id, ce.item, ce.collection, ce.sort
FROM collections_entries ce
         JOIN season_roles sr        ON sr.id::varchar = ce.item
         JOIN season_availability sa ON sa.id::varchar = ce.item
WHERE ce.collections_id = ANY (@ids::int[])
  AND ce.collection = 'seasons'
  AND sa.published
  AND sa.available_to   > now()
  AND sa.available_from < now()
  AND sr.roles && @roles::varchar[]
UNION ALL
SELECT ce.id, ce.collections_id, ce.item, ce.collection, ce.sort
FROM collections_entries ce
         JOIN show_roles shr        ON shr.id::varchar = ce.item
         JOIN show_availability sha ON sha.id::varchar = ce.item
WHERE ce.collections_id = ANY (@ids::int[])
  AND ce.collection = 'shows'
  AND sha.published
  AND sha.available_to   > now()
  AND sha.available_from < now()
  AND shr.roles && @roles::varchar[]
UNION ALL
SELECT ce.id, ce.collections_id, ce.item, ce.collection, ce.sort
FROM collections_entries ce
WHERE ce.collections_id = ANY (@ids::int[])
  AND ce.collection = 'games'
  AND EXISTS (SELECT 1 FROM games_usergroups gu
              WHERE gu.games_id::varchar = ce.item
                AND gu.usergroups_code = ANY (@roles::varchar[]))
UNION ALL
SELECT ce.id, ce.collections_id, ce.item, ce.collection, ce.sort
FROM collections_entries ce
WHERE ce.collections_id = ANY (@ids::int[])
  AND ce.collection = 'playlists'
  AND EXISTS (SELECT 1 FROM playlists_usergroups pu
              WHERE pu.playlists_id::varchar = ce.item
                AND pu.usergroups_code = ANY (@roles::varchar[]))
UNION ALL
SELECT ce.id, ce.collections_id, ce.item, ce.collection, ce.sort
FROM collections_entries ce
WHERE ce.collections_id = ANY (@ids::int[])
  AND ce.collection = 'pages'
  AND EXISTS (SELECT 1 FROM sections_usergroups sug
                       JOIN sections s ON s.id = sug.sections_id
              WHERE s.page_id::varchar = ce.item
                AND sug.usergroups_code = ANY (@roles::varchar[]))
UNION ALL
SELECT ce.id, ce.collections_id, ce.item, ce.collection, ce.sort
FROM collections_entries ce
WHERE ce.collections_id = ANY (@ids::int[])
  AND ce.collection = 'shorts'
  AND EXISTS (SELECT 1 FROM shorts_usergroups shu
              WHERE shu.shorts_id::varchar = ce.item
                AND shu.usergroups_code = ANY (@roles::varchar[]))
UNION ALL
SELECT ce.id, ce.collections_id, ce.item, ce.collection, ce.sort
FROM collections_entries ce
WHERE ce.collections_id = ANY (@ids::int[])
  AND ce.collection NOT IN ('episodes', 'seasons', 'shows', 'games', 'playlists', 'pages', 'shorts')
ORDER BY sort;

-- name: getCollectionIDsForCodes :many
SELECT c.id, ct.slug
FROM collections c
         JOIN collections_translations ct ON c.id = ct.collections_id AND ct.slug = ANY ($1::varchar[]);

-- name: getCollectionEntriesForCollectionsFilteredByRolesAndLanguages :many
SELECT ce.id, ce.collections_id, ce.item, ce.collection, ce.sort
FROM collections_entries ce
         JOIN episode_roles er        ON er.id::varchar = ce.item
         JOIN episode_availability ea ON ea.id::varchar = ce.item
WHERE ce.collections_id = ANY (@ids::int[])
  AND ce.collection = 'episodes'
  AND ea.published
  AND ea.available_to   > now()
  AND ea.available_from < now()
  AND er.roles && @roles::varchar[]
  AND (NOT @only_prefered_languages
       OR ea.audio    && @preferred_audio_languages::varchar[]
       OR ea.subtitle && @preferred_subtitle_languages::varchar[])
UNION ALL
SELECT ce.id, ce.collections_id, ce.item, ce.collection, ce.sort
FROM collections_entries ce
         JOIN season_roles sr        ON sr.id::varchar = ce.item
         JOIN season_availability sa ON sa.id::varchar = ce.item
WHERE ce.collections_id = ANY (@ids::int[])
  AND ce.collection = 'seasons'
  AND sa.published
  AND sa.available_to   > now()
  AND sa.available_from < now()
  AND sr.roles && @roles::varchar[]
  AND (NOT @only_prefered_languages
       OR sa.audio     && @preferred_audio_languages::varchar[]
       OR sa.subtitles && @preferred_subtitle_languages::varchar[])
UNION ALL
SELECT ce.id, ce.collections_id, ce.item, ce.collection, ce.sort
FROM collections_entries ce
         JOIN show_roles shr        ON shr.id::varchar = ce.item
         JOIN show_availability sha ON sha.id::varchar = ce.item
WHERE ce.collections_id = ANY (@ids::int[])
  AND ce.collection = 'shows'
  AND sha.published
  AND sha.available_to   > now()
  AND sha.available_from < now()
  AND shr.roles && @roles::varchar[]
  AND (NOT @only_prefered_languages
       OR sha.audio     && @preferred_audio_languages::varchar[]
       OR sha.subtitles && @preferred_subtitle_languages::varchar[])
UNION ALL
SELECT ce.id, ce.collections_id, ce.item, ce.collection, ce.sort
FROM collections_entries ce
WHERE ce.collections_id = ANY (@ids::int[])
  AND ce.collection = 'games'
  AND EXISTS (SELECT 1 FROM games_usergroups gu
              WHERE gu.games_id::varchar = ce.item
                AND gu.usergroups_code = ANY (@roles::varchar[]))
UNION ALL
SELECT ce.id, ce.collections_id, ce.item, ce.collection, ce.sort
FROM collections_entries ce
WHERE ce.collections_id = ANY (@ids::int[])
  AND ce.collection = 'playlists'
  AND EXISTS (SELECT 1 FROM playlists_usergroups pu
              WHERE pu.playlists_id::varchar = ce.item
                AND pu.usergroups_code = ANY (@roles::varchar[]))
UNION ALL
SELECT ce.id, ce.collections_id, ce.item, ce.collection, ce.sort
FROM collections_entries ce
WHERE ce.collections_id = ANY (@ids::int[])
  AND ce.collection = 'pages'
  AND EXISTS (SELECT 1 FROM sections_usergroups sug
                       JOIN sections s ON s.id = sug.sections_id
              WHERE s.page_id::varchar = ce.item
                AND sug.usergroups_code = ANY (@roles::varchar[]))
UNION ALL
SELECT ce.id, ce.collections_id, ce.item, ce.collection, ce.sort
FROM collections_entries ce
WHERE ce.collections_id = ANY (@ids::int[])
  AND ce.collection = 'shorts'
  AND EXISTS (SELECT 1 FROM shorts_usergroups shu
              WHERE shu.shorts_id::varchar = ce.item
                AND shu.usergroups_code = ANY (@roles::varchar[]))
UNION ALL
SELECT ce.id, ce.collections_id, ce.item, ce.collection, ce.sort
FROM collections_entries ce
WHERE ce.collections_id = ANY (@ids::int[])
  AND ce.collection NOT IN ('episodes', 'seasons', 'shows', 'games', 'playlists', 'pages', 'shorts')
ORDER BY sort;
