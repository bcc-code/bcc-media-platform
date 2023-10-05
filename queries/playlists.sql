-- name: getPlaylists :many
SELECT p.id,
       p.collection_id,
       p.title                                             AS original_title,
       p.description                                       AS original_description,
       (SELECT json_object_agg(ts.languages_code, ts.title)
        FROM playlists_translations ts
        WHERE ts.playlists_id = p.id)                      AS title,
       (SELECT json_object_agg(ts.languages_code, ts.description)
        FROM playlists_translations ts
        WHERE ts.playlists_id = p.id)                      AS description,
       (SELECT json_agg((SELECT img.style, img.language, df.filename_disk
                         FROM playlists_styledimages simg
                                  JOIN styledimages img ON img.id = simg.styledimages_id
                                  JOIN directus_files df on img.file = df.id
                         WHERE simg.playlists_id = p.id))) AS images
FROM public.playlists p
WHERE p.id = ANY (@ids::uuid[]);
