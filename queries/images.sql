
-- name: InsertStyledImage :one
INSERT INTO styledimages (
    id,
    style,
    language,
    file
) VALUES (
    gen_random_uuid(),
    @style,
    @language,
    @file
)
RETURNING id;

-- name: InsertTimedMetadataStyledImage :one
INSERT INTO timedmetadata_styledimages (
    timedmetadata_id,
    styledimages_id
) VALUES (
    @timed_metadata_id,
    @styled_image_id
)
RETURNING id;