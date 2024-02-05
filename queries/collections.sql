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
SELECT *
FROM collections_entries ci
WHERE ci.collections_id = ANY ($1::int[]);

-- name: getCollectionEntriesForCollectionsWithRoles :many
SELECT ce.id, ce.collections_id, ce.item, ce.collection, ce.sort
FROM collections_entries ce
         LEFT JOIN episode_roles er ON ce.collection = 'episodes' AND er.id::varchar = ce.item
         LEFT JOIN episode_availability ea ON ce.collection = 'episodes' AND ea.id::varchar = ce.item
         LEFT JOIN season_roles sr ON ce.collection = 'seasons' AND sr.id::varchar = ce.item
         LEFT JOIN season_availability sa ON ce.collection = 'seasons' AND sa.id::varchar = ce.item
         LEFT JOIN show_roles shr ON ce.collection = 'shows' AND shr.id::varchar = ce.item
         LEFT JOIN show_availability sha ON ce.collection = 'shows' AND sha.id::varchar = ce.item
         LEFT JOIN (SELECT gr.games_id::varchar, array_agg(gr.usergroups_code)::varchar[] roles
                    FROM games_usergroups gr
                    GROUP BY gr.games_id) gr ON ce.collection = 'games' AND gr.games_id::varchar = ce.item
         LEFT JOIN (SELECT pr.playlists_id::varchar, array_agg(pr.usergroups_code)::varchar[] roles
                    FROM playlists_usergroups pr
                    GROUP BY pr.playlists_id) pr ON ce.collection = 'playlists' AND pr.playlists_id = ce.item
         LEFT JOIN (SELECT s.page_id::varchar, array_agg(DISTINCT (ug.usergroups_code)) roles
                    FROM sections_usergroups ug
                             JOIN sections s ON s.id = ug.sections_id
                    GROUP BY s.page_id) pageroles ON ce.collection = 'pages' AND pageroles.page_id = ce.item
         LEFT JOIN (SELECT shortsr.shorts_id::varchar, array_agg(shortsr.usergroups_code)::varchar[] roles
                    FROM shorts_usergroups shortsr
                    GROUP BY shortsr.shorts_id::varchar) shortsr
                   ON ce.collection = 'shorts' AND shortsr.shorts_id = ce.item

WHERE ce.collections_id = ANY (@ids::int[])
  AND (
    (ce.collection = 'episodes'
        AND ea.published
        AND ea.available_to
         > now()
        AND er.roles && @roles::varchar[]
        AND
     ea.available_from
         < now())
        OR
    (ce.collection = 'seasons'
        AND sa.published
        AND sa.available_to
         > now()
        AND sr.roles && @roles::varchar[]
        AND
     sa.available_from
         < now())
        OR
    (ce.collection = 'shows'
        AND sha.published
        AND sha.available_to
         > now()
        AND shr.roles && @roles::varchar[]
        AND
     sha.available_from
         < now())
        OR
    (ce.collection = 'games' AND gr.roles && @roles::varchar[])
        OR
    (ce.collection = 'playlists' AND pr.roles && @roles::varchar[])
        OR
    (ce.collection = 'pages' AND pageroles.roles && @roles::varchar[])
        OR
    (ce.collection = 'shorts' AND shortsr.roles && @roles::varchar[])
        OR
    (ce.collection NOT IN ('episodes', 'seasons', 'shows', 'games', 'playlists', 'pages', 'shorts')))
ORDER BY ce.sort;

-- name: getCollectionIDsForCodes :many
SELECT c.id, ct.slug
FROM collections c
         JOIN collections_translations ct ON c.id = ct.collections_id AND ct.slug = ANY ($1::varchar[]);
