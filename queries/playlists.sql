-- name: getPlaylists :many
SELECT p.id,
       p.collection_id,
       p.title                                     AS original_title,
       p.description                               AS original_description,
       coalesce(title_agg.title, '{}')             AS title,
       coalesce(description_agg.description, '{}') AS description,
       coalesce(images_agg.images, '{}')           AS images
FROM public.playlists p
         LEFT JOIN (SELECT ts.playlists_id, json_object_agg(ts.languages_code, ts.title) AS title
                    FROM playlists_translations ts
                    GROUP BY ts.playlists_id) AS title_agg ON title_agg.playlists_id = p.id
         LEFT JOIN (SELECT ts.playlists_id, json_object_agg(ts.languages_code, ts.description) AS description
                    FROM playlists_translations ts
                    GROUP BY ts.playlists_id) AS description_agg ON description_agg.playlists_id = p.id
         LEFT JOIN (SELECT simg.playlists_id,
                           json_agg(json_build_object('style', img.style, 'language', img.language, 'filename_disk',
                                                      df.filename_disk)) AS images
                    FROM playlists_styledimages simg
                             JOIN styledimages img ON img.id = simg.styledimages_id
                             JOIN directus_files df ON img.file = df.id
                    GROUP BY simg.playlists_id) AS images_agg ON images_agg.playlists_id = p.id
WHERE p.id = ANY (@ids::uuid[]);

-- name: listPlaylists :many
SELECT p.id,
       p.collection_id,
       p.title                                     AS original_title,
       p.description                               AS original_description,
       coalesce(title_agg.title, '{}')             AS title,
       coalesce(description_agg.description, '{}') AS description,
       coalesce(images_agg.images, '{}')           AS images
FROM public.playlists p
         LEFT JOIN (SELECT ts.playlists_id, json_object_agg(ts.languages_code, ts.title) AS title
                    FROM playlists_translations ts
                    GROUP BY ts.playlists_id) AS title_agg ON title_agg.playlists_id = p.id
         LEFT JOIN (SELECT ts.playlists_id, json_object_agg(ts.languages_code, ts.description) AS description
                    FROM playlists_translations ts
                    GROUP BY ts.playlists_id) AS description_agg ON description_agg.playlists_id = p.id
         LEFT JOIN (SELECT simg.playlists_id,
                           json_agg(json_build_object('style', img.style, 'language', img.language, 'filename_disk',
                                                      df.filename_disk)) AS images
                    FROM playlists_styledimages simg
                             JOIN styledimages img ON img.id = simg.styledimages_id
                             JOIN directus_files df ON img.file = df.id
                    GROUP BY simg.playlists_id) AS images_agg ON images_agg.playlists_id = p.id;

-- name: GetRolesForPlaylists :many
SELECT roles.playlists_id, array_agg(roles.usergroups_code)::varchar[] AS roles
FROM playlists_usergroups roles
WHERE roles.playlists_id = ANY (@ids::uuid[])
GROUP BY roles.playlists_id;
