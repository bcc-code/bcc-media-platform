-- name: listCollections :many
SELECT *
FROM collections;

-- name: getCollections :many
SELECT *
FROM collections c
WHERE c.id = ANY ($1::int[]);

-- name: getCollectionItemsForCollections :many
SELECT *
FROM collections_items ci
WHERE ci.collection_id = ANY ($1::int[]);

-- name: getCollectionItemsForCollectionsWithRoles :many
SELECT ci.*
FROM collections_items ci
         LEFT JOIN episode_roles er ON er.id = ci.episode_id
         LEFT JOIN episode_availability ea ON ea.id = ci.episode_id
         LEFT JOIN season_roles sr ON sr.id = ci.season_id
         LEFT JOIN season_availability sa ON sa.id = ci.season_id
         LEFT JOIN show_roles shr ON shr.id = ci.show_id
         LEFT JOIN show_availability sha ON sha.id = ci.show_id
WHERE ci.collection_id = ANY ($1::int[])
  AND (ci.episode_id IS NULL OR (
        ea.published
        AND ea.available_to > now()
        AND er.roles && $2::varchar[] AND ea.available_from < now()
    ))
  AND ci.season_id IS NULL
  AND (ci.show_id IS NULL OR (
        sha.published
        AND sha.available_to > now()
        AND shr.roles && $2::varchar[] AND sha.available_from < now()
    ))
ORDER BY ci.sort;

-- getCollectionEntriesWithRoles :many
SELECT ce.*
FROM collections_entries ce
         LEFT JOIN episode_roles er ON ce.collection = 'episodes' AND er.id::varchar = ce.item
         LEFT JOIN episode_availability ea ON ce.collection = 'episodes' AND ea.id::varchar = ce.item
         LEFT JOIN season_roles sr ON ce.collection = 'seasons' AND sr.id::varchar = ce.item
         LEFT JOIN season_availability sa ON ce.collection = 'seasons' AND sa.id::varchar = ce.item
         LEFT JOIN show_roles shr ON ce.collection = 'shows' AND shr.id::varchar = ce.item
         LEFT JOIN show_availability sha ON ce.collection = 'shows' AND sha.id::varchar = ce.item
WHERE ce.collections_id = ANY ($1::int[])
    AND(ce.collection != 'episodes' OR (
        ea.published
        AND ea.available_to > now()
        AND er.roles && $2 AND ea.available_from < now()
    ))
  AND ce.collection != 'seasons'
  AND (ce.collection != 'shows' OR (
        sha.published
        AND sha.available_to > now()
        AND shr.roles && $3 AND sha.available_from < now()
    ))
ORDER BY ce.sort;
