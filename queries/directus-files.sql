-- name: getFiles :many
SELECT * FROM directus_files WHERE id = ANY($1::uuid[]);

-- name: InsertDirectusFile :one
INSERT INTO directus_files (
    id,
    storage,
    filename_disk,
    filename_download,
    title,
    type,
    folder,
    charset,
    filesize,
    width,
    height,
    duration,
    embed,
    description,
    location,
    tags,
    metadata
)
VALUES (
    @id,
    @storage,
    @filename_disk::varchar,
    @filename_download,
    @title,
    @type,
    @folder,
    @charset,
    @filesize,
    @width,
    @height,
    @duration,
    @embed,
    @description,
    @location,
    @tags,
    @metadata
)
RETURNING id;
