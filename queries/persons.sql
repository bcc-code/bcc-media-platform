
-- name: getPersons :many
SELECT p.*, COALESCE(images.images, '{}'::json) AS images
FROM persons p
LEFT JOIN (
    SELECT
    simg.persons_id,
    json_agg(json_build_object('style', img.style, 'language', img.language, 'filename_disk', df.filename_disk)) AS images
    FROM persons_styledimages simg
    JOIN styledimages img ON (img.id = simg.styledimages_id)
    JOIN directus_files df ON (img.file = df.id)
    WHERE simg.persons_id = ANY(@ids::uuid[])
    GROUP BY simg.persons_id
) images ON (images.persons_id = p.id)
WHERE id = ANY (@ids::uuid[]);

-- name: GetPersonIDsByNames :many
SELECT p.id, p.name
FROM persons p
WHERE name = ANY (@names::varchar[]);

-- name: InsertPerson :exec
INSERT INTO "public"."persons" (id, name)
VALUES (@id, @name);
