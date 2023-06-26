-- name: getGames :many
WITH ts AS (SELECT games_id,
                   json_object_agg(languages_code, title)       as title,
                   json_object_agg(languages_code, description) as description
            FROM games_translations
            GROUP BY games_id),
     imgs AS (SELECT images.games_id, json_agg(images) as json
              FROM (SELECT simg.games_id, img.style, img.language, df.filename_disk
                    FROM games_styledimages simg
                             JOIN styledimages img ON img.id = simg.styledimages_id
                             JOIN directus_files df on img.file = df.id) images
              GROUP BY images.games_id)
SELECT i.id,
       i.title       as original_title,
       i.description as original_description,
       ts.title,
       ts.description,
       l.url,
       l.requires_authentication,
       img.json      as images
FROM games i
         LEFT JOIN ts ON ts.games_id = i.id
         LEFT JOIN imgs img ON img.games_id = i.id
         JOIN links l ON i.link_id = l.id
WHERE i.id = ANY (@ids::uuid[]);
